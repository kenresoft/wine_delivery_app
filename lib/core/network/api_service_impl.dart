import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/core/network/api_service.dart';
import 'package:vintiora/core/network/client/network_client.dart';
import 'package:vintiora/core/utils/constants.dart';
import 'package:vintiora/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vintiora/features/auth/data/models/auth_tokens_model.dart';

class ApiService implements IApiService {
  final INetworkClient _networkClient;
  final AuthLocalDataSource _localDataSource;

  ApiService({
    required INetworkClient networkClient,
    required AuthLocalDataSource localDataSource,
  })  : _networkClient = networkClient,
        _localDataSource = localDataSource;

  // Helper method to execute network request based on RequestMethod
  Future<Response> _executeRequest({
    required String endpoint,
    required RequestMethod method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required Map<String, String> headers,
    CancelToken? cancelToken,
  }) async {
    switch (method) {
      case RequestMethod.get:
        return await _networkClient.get(
          endpoint,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        );
      case RequestMethod.post:
        return await _networkClient.post(
          endpoint,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        );
      case RequestMethod.put:
        return await _networkClient.put(
          endpoint,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        );
      case RequestMethod.patch:
        return await _networkClient.patch(
          endpoint,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        );
      case RequestMethod.delete:
        return await _networkClient.delete(
          endpoint,
          data: data,
          queryParameters: queryParameters,
          headers: headers,
          cancelToken: cancelToken,
        );
    }
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
      if (e.response?.statusCode == 401) {
        final refreshResult = await _handleTokenRefresh();
        if (refreshResult) {
          return request(
            endpoint: endpoint,
            parser: parser,
            method: method,
            headers: headers,
            queryParameters: queryParameters,
            data: data,
            requiresAuth: requiresAuth,
            cancelToken: cancelToken,
          );
        }
      }
      final failureMessage = _getErrorMessage(e);
      return Left(ServerFailure(failureMessage, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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
      if (e.response?.statusCode == 401) {
        final refreshResult = await _handleTokenRefresh();
        if (refreshResult) {
          return makeRequest(
            endpoint,
            method: method,
            data: data,
            queryParameters: queryParameters,
            headers: headers,
            requiresAuth: requiresAuth,
            cancelToken: cancelToken,
          );
        }
      }
      final failureMessage = _getErrorMessage(e);
      return Left(ServerFailure(failureMessage, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Map<String, String>> _prepareHeaders(Map<String, String>? headers, bool requiresAuth) async {
    final requestHeaders = headers != null ? Map<String, String>.from(headers) : <String, String>{};
    if (requiresAuth) {
      final token = await _localDataSource.getAccessToken();
      if (token != null && token.isNotEmpty) {
        requestHeaders['Authorization'] = 'Bearer $token';
      }
    }
    return requestHeaders;
  }

  Future<Either<Failure, String>> _refreshToken(String refreshToken) async {
    try {
      final result = await request<Map<String, dynamic>>(
        endpoint: ApiConstants.refreshToken,
        method: RequestMethod.post,
        data: {
          'refreshToken': refreshToken,
        },
        parser: (data) => data as Map<String, dynamic>,
        requiresAuth: false,
      );

      final newAccessToken = result.fold(
        (failure) => throw Exception(failure.message),
        (data) {
          if (data['success'] == true && data.containsKey('accessToken')) {
            return data['accessToken'] as String;
          } else {
            throw Exception('Failed to refresh token');
          }
        },
      );
      await _localDataSource.cacheTokens(
        AuthTokensModel(
          accessToken: newAccessToken,
          refreshToken: refreshToken,
        ),
      );
      return Right(newAccessToken);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<bool> _handleTokenRefresh() async {
    try {
      final refreshToken = await _localDataSource.getRefreshToken();
      if (refreshToken != null) {
        final result = await _refreshToken(refreshToken);
        return result.fold(
          (failure) async {
            await _localDataSource.clearUserData();
            return false;
          },
          (newToken) => true,
        );
      }
      await _localDataSource.clearUserData();
      return false;
    } catch (_) {
      await _localDataSource.clearUserData();
      return false;
    }
  }

  String _getErrorMessage(DioException error) {
    String message = 'Network error occurred';
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timed out';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Request timed out';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Response timed out';
        break;
      case DioExceptionType.badResponse:
        final response = error.response;
        if (response != null) {
          try {
            if (response.data is Map && response.data['message'] != null) {
              message = response.data['message'];
            } else {
              message = 'Server responded with error ${response.statusCode}';
            }
          } catch (_) {
            message = 'Server error occurred';
          }
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        message = 'Unknown error occurred';
        break;
    }
    return message;
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
