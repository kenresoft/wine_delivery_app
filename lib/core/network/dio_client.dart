import 'package:dio/dio.dart';
import 'package:vintiora/core/network/cache_service.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_interceptor.dart';

class DioClient {
  final Dio dio;
  final CacheService cacheService;

  DioClient(this.cacheService)
      : dio = Dio(
          BaseOptions(
            baseUrl: '${Constants.baseUrl}/api',
            connectTimeout: const Duration(milliseconds: 5000),
            receiveTimeout: const Duration(milliseconds: 3000),
            receiveDataWhenStatusError: true,
            followRedirects: true,
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    dio.interceptors.add(AuthInterceptor(dio, cacheService));
  }
}
