import 'package:dio/dio.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_interceptor.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';

class DioClient {
  final Dio dio;
  final AuthLocalDataSource localDataSource;

  DioClient(this.localDataSource)
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
    dio.interceptors.add(AuthInterceptor(dio));
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true)); // Add a log interceptor for debugging
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          // Cache the response
          await localDataSource.cacheResponse(response.requestOptions.path, response.data);
          return handler.next(response);
        },
        onRequest: (options, handler) async {
          //Check if the response is cached.
          final cachedResponse = await localDataSource.getCachedResponse(options.path);
          cachedResponse.fold(
            () => handler.next(options), // No cached data, proceed with request
            (data) => handler.resolve(
              // Found cached data, resolve immediately
              Response(
                requestOptions: options,
                data: data,
                statusCode: 200,
                statusMessage: 'CACHED_RESPONSE',
              ),
            ),
          );
        },
      ),
    );
  }
}
