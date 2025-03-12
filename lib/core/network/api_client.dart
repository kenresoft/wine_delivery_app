import 'package:dio/dio.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_interceptor.dart';

class ApiClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${Constants.baseUrl}/',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    ),
  );

  static Dio get dio {
    _dio.interceptors.clear();
    _dio.interceptors.add(AuthInterceptor(ApiConstants.baseUrl));
    return _dio;
  }
}
