import 'package:dartz/dartz.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/core/storage/local_storage.dart';

import '../../core/failures/failures.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_tokens_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> register(String username, String email, String password) async {
    try {
      final result = await remoteDataSource.register(username, email, password);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Tuple2<User, AuthTokens>>> verifyOtp(String email, String otp) async {
    try {
      final result = await remoteDataSource.verifyOtp(email, otp);
      final user = result['user'] as User;
      final tokens = result['tokens'] as AuthTokens;

      // Cache user and tokens
      await localDataSource.cacheUser(result['user']);
      await localDataSource.cacheTokens(result['tokens']);

      return Right(Tuple2(user, tokens));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final user = await remoteDataSource.getProfile();
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      // Try to get cached user if remote fails
      final cachedUser = await localDataSource.getLastUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> checkAuth() async {
    try {
      final user = await remoteDataSource.checkAuth();
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      // If remote check fails, attempt to refresh token
      logger.w('ATTEMPTING TOKEN REFRESH', error: e);
      try {
        final refreshToken = await localDataSource.getRefreshToken();
        if (refreshToken != null) {
          final newAccessToken = await remoteDataSource.refreshToken(refreshToken);
          await localDataSource.cacheTokens(
            AuthTokensModel(
              accessToken: newAccessToken,
              refreshToken: refreshToken,
            ),
          );

          // Try again with new token
          final user = await remoteDataSource.checkAuth();
          await localDataSource.cacheUser(user);
          return Right(user);
        }
        logger.e('No refresh token available');
        throw Exception('No refresh token available');
      } catch (_) {
        // If even token refresh fails, return cached user if available
        final cachedUser = await localDataSource.getLastUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        }
        return Left(AuthFailure('User is not authenticated'));
      }
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    try {
      final newAccessToken = await remoteDataSource.refreshToken(refreshToken);
      await localDataSource.cacheTokens(
        AuthTokensModel(
          accessToken: newAccessToken,
          refreshToken: refreshToken,
        ),
      );
      return Right(newAccessToken);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUserData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
