import 'package:dio/dio.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vintiora/features/auth/data/models/auth_tokens_model.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;
  final Lock _refreshLock = Lock();
  bool _isRefreshing = false;
  String? _cachedAccessToken;

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
      final accessToken = _cachedAccessToken ?? await authLocalDataSource.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && err.requestOptions.path != ApiConstants.refreshToken) {
      final refreshToken = await authLocalDataSource.getRefreshToken();

      if (refreshToken == null) {
        logger.e('No refresh token available, logging out.');
        await authLocalDataSource.clearUserData();
        return handler.reject(err);
      }

      return _refreshLock.synchronized(() async {
        if (_isRefreshing) {
          // If another request is already refreshing, wait and retry with new token
          try {
            await Future.delayed(const Duration(milliseconds: 100));
            final newToken = await authLocalDataSource.getAccessToken();
            if (newToken != null) {
              return _retryRequest(err.requestOptions, newToken, handler);
            }
          } catch (e) {
            logger.e('Error while waiting for token refresh: $e');
          }
          return handler.reject(err);
        }

        _isRefreshing = true;

        try {
          // Create a new Dio instance without interceptors for the refresh request
          final refreshDio = Dio(BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: {
              'Content-Type': 'application/json',
            },
          ));

          final response = await refreshDio.post(
            ApiConstants.refreshToken,
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200 && response.data != null) {
            final newAccessToken = response.data['accessToken'] as String;
            final newRefreshToken = response.data['refreshToken'] as String? ?? refreshToken;

            // Update cached token
            _cachedAccessToken = newAccessToken;

            // Cache new tokens
            await authLocalDataSource.cacheTokens(
              AuthTokensModel(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              ),
            );

            // Retry original request with new token
            return _retryRequest(err.requestOptions, newAccessToken, handler);
          } else {
            logger.e('Failed to refresh token: ${response.statusCode}, ${response.data}');
            await authLocalDataSource.clearUserData();
            return handler.reject(err);
          }
        } catch (e) {
          logger.e('Error during token refresh: $e');
          await authLocalDataSource.clearUserData();
          return handler.reject(err);
        } finally {
          _isRefreshing = false;
        }
      });
    }

    handler.next(err);
  }

  Future<void> _retryRequest(
    RequestOptions requestOptions,
    String newAccessToken,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final opts = requestOptions.copyWith(
        headers: {
          ...requestOptions.headers,
          'Authorization': 'Bearer $newAccessToken',
        },
      );
      final retryResponse = await dio.fetch(opts);
      handler.resolve(retryResponse);
    } catch (e) {
      handler.reject(e as DioException);
    }
  }
}
