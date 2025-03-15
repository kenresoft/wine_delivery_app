import 'package:dio/dio.dart';
import 'package:vintiora/core/network/cache_service.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_interceptor.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';

class DioClient {
  final Dio dio;
  final CacheService cacheService;
  final AuthLocalDataSource authLocalDataSource;

  DioClient(this.cacheService, this.authLocalDataSource)
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
    dio.interceptors.add(AuthInterceptor(dio: dio, cacheService: cacheService, authLocalDataSource: authLocalDataSource));
  }
}
