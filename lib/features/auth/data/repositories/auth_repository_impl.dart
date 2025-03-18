import 'package:dartz/dartz.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/foundation.dart';
import 'package:vintiora/core/error/error_handling_service.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vintiora/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vintiora/features/auth/data/models/auth_tokens_model.dart';
import 'package:vintiora/features/auth/domain/entities/auth_tokens.dart';
import 'package:vintiora/features/auth/domain/entities/user.dart';
import 'package:vintiora/features/auth/domain/repositories/auth_repository.dart';

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
      return await remoteDataSource.register(username, email, password);
    } catch (e) {
      return Left(ServerFailure(ErrorHandlingService.getAuthErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    try {
      return await remoteDataSource.login(email, password);
    } catch (e) {
      return Left(ServerFailure(ErrorHandlingService.getAuthErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, Tuple2<User, AuthTokens>>> verifyOtp(String email, String otp) async {
    try {
      final result = await remoteDataSource.verifyOtp(email, otp);

      return result.fold((failure) => Left(failure), (data) async {
        final user = data['user'] as User;
        final tokens = data['tokens'] as AuthTokens;

        // Cache user and tokens
        await localDataSource.cacheUser(data['user']);
        await localDataSource.cacheTokens(data['tokens']);

        return Right(Tuple2(user, tokens));
      });
    } catch (e) {
      if (kDebugMode) {
        print('OTP Verification Error: $e');
      }
      return Left(ServerFailure(ErrorHandlingService.getAuthErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, User>> getProfile() async {
    try {
      final result = await remoteDataSource.getProfile();

      return result.fold((failure) async {
        // Try to get cached user if remote fails
        final cachedUser = await localDataSource.getLastUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        }
        return Left(failure);
      }, (user) async {
        // Cache the fresh user data
        await localDataSource.cacheUser(user);
        return Right(user);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Get Profile Error: $e');
      }

      // Try to get cached user if remote fails
      final cachedUser = await localDataSource.getLastUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      return Left(ServerFailure(ErrorHandlingService.getGeneralErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, User>> checkAuth() async {
    try {
      final result = await remoteDataSource.checkAuth();

      return result.fold((failure) async {
        if (kDebugMode) {
          logger.e('Auth Check Failed: ${failure.message}');
        }

        // If remote check fails, attempt to refresh token
        try {
          final refreshToken = await localDataSource.getRefreshToken();
          if (refreshToken != null) {
            final tokenResult = await remoteDataSource.refreshToken(refreshToken);

            return tokenResult.fold((tokenFailure) async {
              // If token refresh fails, return cached user if available
              final cachedUser = await localDataSource.getLastUser();
              if (cachedUser != null) {
                return Right(cachedUser);
              }
              return Left(AuthFailure.sessionExpired());
            }, (newAccessToken) async {
              await localDataSource.cacheTokens(
                AuthTokensModel(
                  accessToken: newAccessToken,
                  refreshToken: refreshToken,
                ),
              );

              // Try again with new token
              final retryResult = await remoteDataSource.checkAuth();
              return retryResult.fold((retryFailure) async {
                // If still fails, try cached user
                final cachedUser = await localDataSource.getLastUser();
                if (cachedUser != null) {
                  return Right(cachedUser);
                }
                return Left(AuthFailure.unableToAuthenticate());
              }, (user) async {
                await localDataSource.cacheUser(user);
                return Right(user);
              });
            });
          }

          // No refresh token available
          return Left(failure);
        } catch (refreshError) {
          if (kDebugMode) {
            logger.e('Token Refresh Error: $refreshError');
          }

          // If even token refresh fails, return cached user if available
          final cachedUser = await localDataSource.getLastUser();
          if (cachedUser != null) {
            return Right(cachedUser);
          }
          return Left(AuthFailure.unableToAuthenticate());
        }
      }, (user) async {
        await localDataSource.cacheUser(user);
        return Right(user);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Check Auth Error: $e');
      }

      // Final fallback - try cached user
      final cachedUser = await localDataSource.getLastUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      return Left(AuthFailure.unableToAuthenticate());
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    try {
      final result = await remoteDataSource.refreshToken(refreshToken);

      return result.fold((failure) => Left(failure), (newAccessToken) async {
        await localDataSource.cacheTokens(
          AuthTokensModel(
            accessToken: newAccessToken,
            refreshToken: refreshToken,
          ),
        );
        return Right(newAccessToken);
      });
    } catch (e) {
      return Left(ServerFailure(ErrorHandlingService.getAuthErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUserData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure.logout());
    }
  }
}
