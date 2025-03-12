import 'package:dio/dio.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_interceptor.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${Constants.baseUrl}/api',
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
      receiveDataWhenStatusError: true,
      followRedirects: true,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Dio get dio {
    _dio.interceptors.clear();
    _dio.interceptors.add(AuthInterceptor(ApiConstants.baseUrl));
    return _dio;
  }
}
