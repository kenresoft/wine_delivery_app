/*
import 'package:dio/dio.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/core/network/dio_client.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';

enum RequestMethod { get, post, put, delete }

final Dio _dio = DioClient(AuthLocalDataSourceImpl()).dio;

/// API Request Wrapper
Future<Response> makeRequest(
  String endpoint, {
  RequestMethod method = RequestMethod.get,
  Map<String, String>? headers,
  dynamic body,
}) async {
  String? accessToken = await AuthLocalDataSourceImpl().getAccessToken();

  headers ??= {};
  headers['Authorization'] = 'Bearer $accessToken';
  logger.d(headers);

  try {
    final Response response = await _getResponse(method, endpoint, headers, body);
    logger.d(response.statusCode);
    return response;
  } catch (e) {
    rethrow;
  }
}

Future<Response> _getResponse(
  RequestMethod method,
  String endpoint,
  Map<String, String> headers,
  dynamic body,
) async {
  return switch (method) {
    RequestMethod.get => await _dio.get(endpoint, options: Options(headers: headers)),
    RequestMethod.post => await _dio.post(endpoint, options: Options(headers: headers), data: body),
    RequestMethod.put => await _dio.put(endpoint, options: Options(headers: headers), data: body),
    RequestMethod.delete => await _dio.delete(endpoint, options: Options(headers: headers), data: body),
  };
}
*/
