import 'package:dio/dio.dart';
import 'package:vintiora/core/network/dio_client.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';

enum RequestMethod { get, post, put, patch, delete }

class ApiService {
  final DioClient dioClient;
  final AuthLocalDataSource authLocalDataSource;

  ApiService({required this.dioClient, required this.authLocalDataSource});

  Future<Response> makeRequest(
    String endpoint, {
    RequestMethod method = RequestMethod.get,
    Map<String, String>? headers,
    dynamic data,
  }) async {
    final dio = dioClient.dio; // Access Dio instance from DioClient
    String? accessToken = await authLocalDataSource.getAccessToken();

    headers ??= {};
    headers['Authorization'] = 'Bearer $accessToken';

    // If a body is provided and the method is GET, default to POST.
    final RequestMethod finalMethod = (data != null && method == RequestMethod.get) ? RequestMethod.post : method;

    try {
      final Response response = await _getResponse(finalMethod, endpoint, headers, data, dio);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> _getResponse(
    RequestMethod method,
    String endpoint,
    Map<String, String> headers,
    dynamic data,
    Dio dio,
  ) async {
    switch (method) {
      case RequestMethod.get:
        return await dio.get(endpoint, options: Options(headers: headers));
      case RequestMethod.post:
        return await dio.post(endpoint, options: Options(headers: headers), data: data);
      case RequestMethod.put:
        return await dio.put(endpoint, options: Options(headers: headers), data: data);
      case RequestMethod.patch:
        return await dio.patch(endpoint, options: Options(headers: headers), data: data);
      case RequestMethod.delete:
        return await dio.delete(endpoint, options: Options(headers: headers), data: data);
    }
  }
}
