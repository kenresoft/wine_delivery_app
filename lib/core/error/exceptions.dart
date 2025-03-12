// Base exception class
import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() {
    return message;
  }
}

class Throws<T> {
  final List<T> exceptions;

  const Throws(this.exceptions);
}

// Specific exception classes
class NoAccessTokenException extends AppException {
  const NoAccessTokenException(super.message);
}

class NoRefreshTokenException extends AppException {
  const NoRefreshTokenException(super.message);
}

class InvalidAccessTokenException extends AppException {
  const InvalidAccessTokenException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class BadRequestException extends AppDioException {
  BadRequestException(super.error, {required super.message}) : super.noRequestOptions();
}

class ServerErrorException extends AppDioException {
  ServerErrorException(super.error, {required super.message}) : super.noRequestOptions();
}

class NetworkErrorException extends AppDioException {
  NetworkErrorException(super.error, {required super.message}) : super.noRequestOptions();
}

class UnauthorizedException extends AppDioException {
  UnauthorizedException(super.error, {required super.message}) : super.noRequestOptions();
}

class UnexpectedException extends AppDioException {
  UnexpectedException(super.error, {required super.message}) : super.noRequestOptions();
}

class NotFoundException extends AppDioException {
  NotFoundException(super.error, {required super.message}) : super.noRequestOptions();
}

class ForbiddenException extends AppException {
  const ForbiddenException(super.message);
}

class TooManyRequestsException extends AppException {
  const TooManyRequestsException(super.message);
}

class ServiceUnavailableException extends AppException {
  const ServiceUnavailableException(super.message);
}

class AppDioException extends DioException {
  AppDioException({super.error, required super.requestOptions});

  AppDioException.noRequestOptions(DioException error, {required String message})
      : super(
          message: message,
          requestOptions: error.requestOptions,
        );
}