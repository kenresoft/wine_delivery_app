import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vintiora/core/error/error_handling_service.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';

class ApiService implements IApiService {
  final INetworkClient _networkClient;
  final AuthLocalDataSource _localDataSource;

  ApiService({
    required INetworkClient networkClient,
    required AuthLocalDataSource localDataSource,
  })  : _networkClient = networkClient,
        _localDataSource = localDataSource;

  Future<Response> _executeRequest({
    required String endpoint,
    required RequestMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required Map<String, String> headers,
    CancelToken? cancelToken,
  }) async {
    final RequestMethod finalMethod = (data != null && method == RequestMethod.get) ? RequestMethod.post : method;

    return switch (finalMethod) {
      RequestMethod.get => await _networkClient.get(
          endpoint,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        ),
      RequestMethod.post => await _networkClient.post(
          endpoint,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        ),
      RequestMethod.put => await _networkClient.put(
          endpoint,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        ),
      RequestMethod.patch => await _networkClient.patch(
          endpoint,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        ),
      RequestMethod.delete => await _networkClient.delete(
          endpoint,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        ),
    };
  }

  @override
  Future<Either<Failure, T>> request<T>({
    required String endpoint,
    required T Function(dynamic data) parser,
    RequestMethod method = RequestMethod.get,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final requestHeaders = await _prepareHeaders(headers, requiresAuth);
      final response = await _executeRequest(
        endpoint: endpoint,
        method: method,
        data: data,
        queryParameters: queryParameters,
        headers: requestHeaders,
        cancelToken: cancelToken,
      );

      return Right(parser(response.data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 && requiresAuth) {
        return Left(AuthFailure.sessionExpired());
      }
      final failureMessage = ErrorHandlingService.getNetworkErrorMessage(e);
      return Left(ServerFailure(failureMessage, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(ErrorHandlingService.getGeneralErrorMessage(e)));
    }
  }

  @override
  Future<Either<Failure, Response>> makeRequest(
    String endpoint, {
    RequestMethod method = RequestMethod.get,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final requestHeaders = await _prepareHeaders(headers, requiresAuth);
      final response = await _executeRequest(
        endpoint: endpoint,
        method: method,
        data: data,
        queryParameters: queryParameters,
        headers: requestHeaders,
        cancelToken: cancelToken,
      );
      return Right(response);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 && requiresAuth) {
        return Left(AuthFailure.sessionExpired());
      }
      final failureMessage = ErrorHandlingService.getNetworkErrorMessage(e);
      return Left(ServerFailure(failureMessage, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(ErrorHandlingService.getGeneralErrorMessage(e)));
    }
  }

  Future<Map<String, String>> _prepareHeaders(
    Map<String, String>? headers,
    bool requiresAuth,
  ) async {
    final requestHeaders = headers != null ? Map<String, String>.from(headers) : <String, String>{};
    if (requiresAuth) {
      final token = await _localDataSource.getAccessToken();
      if (token != null && token.isNotEmpty) {
        requestHeaders['Authorization'] = 'Bearer $token';
      }
    }
    return requestHeaders;
  }

  @override
  CancelToken createCancelToken() {
    return _networkClient.createCancelToken();
  }

  @override
  void cancelRequest(CancelToken token) {
    _networkClient.cancelRequest(token);
  }
}
