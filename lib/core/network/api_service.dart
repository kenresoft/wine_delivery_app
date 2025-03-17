import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:vintiora/core/error/failures.dart';
import 'package:vintiora/core/network/client/network_client.dart';

/// Abstract API service definition using Either for error handling
abstract class IApiService {
  /// Generic request method with parser function
  Future<Either<Failure, T>> request<T>({
    required String endpoint,
    required T Function(dynamic data) parser,
    RequestMethod method = RequestMethod.get,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  });

  /// Simplified method for common API requests
  Future<Either<Failure, Response>> makeRequest(
    String endpoint, {
    RequestMethod method = RequestMethod.get,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool requiresAuth = true,
    CancelToken? cancelToken,
  });

  CancelToken createCancelToken();

  void cancelRequest(CancelToken token);
}
