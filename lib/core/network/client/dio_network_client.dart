import 'package:dio/dio.dart';
import 'package:vintiora/core/cache/cache_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/core/network/interceptors/auth_interceptor.dart';
import 'package:vintiora/core/network/interceptors/cache_interceptor.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';

class DioNetworkClient implements INetworkClient {
  final Dio _dio;

  DioNetworkClient({
    required AuthLocalDataSource authDataSource,
    required CacheService cacheService,
  }) : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: Constants.connectionTimeout,
          receiveTimeout: Constants.receiveTimeout,
          receiveDataWhenStatusError: true,
          followRedirects: true,
          headers: {
            'Content-Type': 'application/json',
          },
        )) {
    _dio.interceptors.addAll([
      AuthInterceptor(
        dio: _dio,
        authLocalDataSource: authDataSource,
      ),
      CacheInterceptor(
        cacheService: cacheService,
      ),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        // logPrint: logger.d,
      ),
    ]);
  }

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
  }

  @override
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    CancelToken? cancelToken,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
      cancelToken: cancelToken,
    );
  }

  @override
  CancelToken createCancelToken() {
    return CancelToken();
  }

  @override
  void cancelRequest(CancelToken token) {
    if (!token.isCancelled) {
      token.cancel('Request cancelled by user');
    }
  }
}
