import 'package:dio/dio.dart';

/// HTTP request methods supported by the API
enum RequestMethod { get, post, put, patch, delete }

/// Abstract definition of network client capabilities
abstract class INetworkClient {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Map<String, String>? headers, CancelToken? cancelToken});

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Map<String, String>? headers, CancelToken? cancelToken});

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Map<String, String>? headers, CancelToken? cancelToken});

  Future<Response> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters, Map<String, String>? headers, CancelToken? cancelToken});

  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Map<String, String>? headers, CancelToken? cancelToken});

  CancelToken createCancelToken();

  void cancelRequest(CancelToken token);
}
