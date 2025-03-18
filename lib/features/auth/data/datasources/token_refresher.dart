import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vintiora/features/auth/data/models/auth_tokens_model.dart';

class TokenRefresher {
  final INetworkClient _networkClient;
  final AuthLocalDataSource _localDataSource;
  final Lock _refreshLock = Lock();

  TokenRefresher({
    required INetworkClient networkClient,
    required AuthLocalDataSource localDataSource,
  })  : _networkClient = networkClient,
        _localDataSource = localDataSource;

  Future<Either<Failure, String>> refreshToken() async {
    // Only one refresh operation at a time
    return _refreshLock.synchronized(() async {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken == null) {
        return Left(ServerFailure("No refresh token available"));
      }

      try {
        final response = await _networkClient.post(
          ApiConstants.refreshToken,
          data: {'refreshToken': refreshToken},
          queryParameters: null,
          headers: <String, String>{},
          cancelToken: _networkClient.createCancelToken(),
        );

        final data = response.data;
        if (data is Map && data['success'] == true && data.containsKey('accessToken')) {
          final newAccessToken = data['accessToken'] as String;
          await _localDataSource.cacheTokens(
            AuthTokensModel(
              accessToken: newAccessToken,
              refreshToken: refreshToken,
            ),
          );
          return Right(newAccessToken);
        } else {
          return Left(ServerFailure("Failed to refresh token"));
        }
      } on DioException catch (e) {
        return Left(ServerFailure(e.toString()));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    });
  }
}
