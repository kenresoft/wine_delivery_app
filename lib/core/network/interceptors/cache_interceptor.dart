import 'package:dio/dio.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/core/cache/cache_policy.dart';
import 'package:vintiora/core/cache/cache_service.dart';

class CacheInterceptor extends Interceptor {
  final CacheService cacheService;

  CacheInterceptor({required this.cacheService});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
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
    // After a response, decide if we should cache it
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
}
