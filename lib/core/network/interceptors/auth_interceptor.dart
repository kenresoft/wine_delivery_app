import 'package:dio/dio.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vintiora/features/auth/data/models/auth_tokens_model.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;

  AuthInterceptor({
    required this.dio,
    required this.authLocalDataSource,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token for the refresh token endpoint
    if (options.path != ApiConstants.refreshToken) {
      final accessToken = await authLocalDataSource.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await authLocalDataSource.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await dio.post(
            ApiConstants.refreshToken,
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['accessToken'];
            final newRefreshToken = response.data['refreshToken'];

            // Update tokens via the auth local data source
            await authLocalDataSource.cacheTokens(
              AuthTokensModel(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              ),
            );

            // Retry the original request with the new token
            final opts = err.requestOptions.copyWith(
              headers: {
                ...err.requestOptions.headers,
                'Authorization': 'Bearer $newAccessToken',
              },
            );
            final retryResponse = await dio.fetch(opts);
            return handler.resolve(retryResponse);
          }
          // Log the redirected URL if 301 error
          else if (response.statusCode == 301) {
            logger.w('Redirected to: ${response.headers['location']}');
          } else {
            logger.e(
              'Failed to refresh token: ${response.statusCode}, ${response.data}',
            );
            await authLocalDataSource.clearUserData();
            return handler.reject(err);
          }
        } catch (e) {
          logger.e('Error refreshing token: $e');
          await authLocalDataSource.clearUserData();
          return handler.reject(err);
        }
      }
    }
    handler.next(err);
  }
}
