/*
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:vintiora/core/error/exceptions.dart';
import 'package:vintiora/core/network/dio_client.dart';
import 'package:vintiora/features/auth/data/repositories/auth_repository.dart';

import '../storage/storage_repository.dart';

class ApiErrorHandler {
  static void handleDioError(DioException error, ErrorInterceptorHandler handler) async {
    return switch (error.type) {
      DioExceptionType.connectionTimeout => handler.next(NetworkErrorException(error, message: "Connection timed out. Please check your internet.")),
      DioExceptionType.receiveTimeout => handler.next(NetworkErrorException(error, message: "Receive timeout. Please try again later.")),
      DioExceptionType.sendTimeout => handler.next(NetworkErrorException(error, message: "Send timeout. Please check your connection.")),
      DioExceptionType.connectionError => error.error is SocketException ? handler.next(NetworkErrorException(error, message: "No internet connection. Please try again.")) : null,
      DioExceptionType.badResponse => _handleBadResponse(error, handler),
      DioExceptionType.cancel => {
          logger.i("Request was cancelled."),
          handler.next(error),
        },
      _ => {
          logger.e("Unexpected error: $error"),
          handler.next(UnexpectedException(error, message: "An unexpected error occurred. Please try again.")),
        },
    };
  }

  /// Handles unauthorized requests
  static Future<void> _handleUnauthorized(DioException error, ErrorInterceptorHandler handler) async {
    final refreshToken = await storageRepository.getRefreshToken();
    if (refreshToken != null) {
      try {
        final newAccessToken = await authRepository.refreshAccessToken(refreshToken);
        if (newAccessToken != null) {
          // Retry the original request with the new token
          error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final response = await DioClient.dio.request(
            error.requestOptions.path,
            options: Options(method: error.requestOptions.method, headers: error.requestOptions.headers),
          );
          handler.resolve(response);
        }
      } catch (e) {
        logger.e("Token refresh failed: $e");
        await _handleSessionExpiration(handler, error);
        return; // Stop further processing
      }
    } else {
      // If no refresh token is available, clear tokens and logout
      await _handleSessionExpiration(handler, error);
    }
  }

  /// Handles session expiration
  static Future<void> _handleSessionExpiration(ErrorInterceptorHandler handler, DioException error) async {
    try {
      await storageRepository.clearTokens();
      authRepository.triggerLogout();
      handler.next(UnauthorizedException(error, message: 'Your session has expired. Please log in again.'));
    } catch (e) {
      logger.e("Error during session cleanup: $e");
    }
  }

  /// Handles responses with HTTP error codes
  static Future<void> _handleBadResponse(DioException error, ErrorInterceptorHandler handler) async {
    final response = error.response;
    if (response != null) {
      final statusCode = response.statusCode;
      switch (statusCode) {
        case 400:
          handler.reject(BadRequestException(error, message: 'Bad request. Please check your input.'));
          break;
        case 401:
          await _handleUnauthorized(error, handler);
          break;
        case 403:
          handler.reject(UnauthorizedException(error, message: 'Unauthorized: Access Denied.'));
          break;
        case 404:
          handler.reject(NotFoundException(error, message: 'Resource not found.'));
          break;
        case 500:
          handler.reject(ServerErrorException(error, message: 'Internal server error, please try again later.'));
          break;
        default:
          handler.next(UnexpectedException(error, message: 'Unexpected error: $statusCode - ${response.statusMessage ?? "Unknown error"}'));
          break;
      }
    } else {
      handler.next(UnexpectedException(error, message: "No response received from server."));
    }
  }
}*/
