import 'package:dio/dio.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/core/network/cache_policy.dart';
import 'package:vintiora/core/network/cache_service.dart';
import 'package:vintiora/core/storage/local_storage.dart';
import 'package:vintiora/features/auth/core/utils/constants.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final CacheService cacheService;

  AuthInterceptor(this.dio, this.cacheService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token for refresh token endpoint
    if (options.path != ApiConstants.refreshToken) {
      final accessToken = LocalStorage.get<String>('CACHED_ACCESS_TOKEN');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    // Check caching based on our policy
    if (CachePolicy.shouldCache(options.path)) {
      final cachedData = await cacheService.get(options.path);
      if (cachedData != null) {
        logger.i('CACHED RESPONSE for ${options.path}: $cachedData');
        return handler.resolve(Response(
          requestOptions: options,
          data: cachedData,
          statusCode: 200,
          statusMessage: 'CACHED_RESPONSE',
        ));
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // After response, decide if we should cache it
    if (CachePolicy.shouldCache(response.requestOptions.path)) {
      final expiry = CachePolicy.getExpiry(response.requestOptions.path);
      await cacheService.set(
        response.requestOptions.path,
        response.data,
        expiry: expiry,
      );
    }
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = LocalStorage.get<String>('CACHED_REFRESH_TOKEN');
      if (refreshToken != null) {
        try {
          final response = await dio.post(
            ApiConstants.refreshToken,
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['accessToken'];
            final newRefreshToken = response.data['refreshToken'];
            await LocalStorage.set<String>('CACHED_ACCESS_TOKEN', newAccessToken);
            if (newRefreshToken != null) {
              await LocalStorage.set<String>('CACHED_REFRESH_TOKEN', newRefreshToken);
            }

            // Retry the original request
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
            logger.e('Failed to refresh token: ${response.statusCode}, ${response.data}');
            await LocalStorage.clear();
            return handler.reject(err);
          }
        } catch (e) {
          logger.e('Error refreshing token: $e');
          await LocalStorage.clear();
          return handler.reject(err);
        }
      }
    }
    handler.next(err);
  }
}
