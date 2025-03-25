import 'package:dio/dio.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/foundation.dart';

/// A centralized service for handling errors in a consistent,
/// user-friendly manner throughout the application.
class ErrorHandlingService {
  ErrorHandlingService._();

  /// Categorizes and formats network errors for user presentation
  static String getNetworkErrorMessage(DioException error) {
    // Default message that's helpful but not too technical
    String message = 'Unable to connect to services. Please try again.';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timed out. Please check your internet connection.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Request timed out. Please try again when you have a stronger connection.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Server is taking too long to respond. Please try again later.';
        break;
      case DioExceptionType.badResponse:
        final response = error.response;
        if (response != null) {
          try {
            if (response.data is Map && response.data['message'] != null) {
              message = response.data['message'];
            } else {
              switch (response.statusCode) {
                case 400:
                  message = 'Invalid request. Please check your information.';
                  break;
                case 401:
                  message = 'Session expired. Please sign in again.';
                  break;
                case 403:
                  message = 'You don\'t have permission to access this resource.';
                  break;
                case 404:
                  message = 'The requested resource was not found.';
                  break;
                case 500:
                case 502:
                case 503:
                case 504:
                  message = 'Server error. Please try again later.';
                  break;
                default:
                  message = 'An unexpected error occurred. Please try again.';
              }
            }
          } catch (_) {
            message = 'An error occurred while processing the server response.';
          }
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network settings.';
        break;
      default:
        message = 'An unexpected network error occurred. Please try again.';
        break;
    }

    if (kDebugMode) {
      logger.d('Network Error: ${error.type} - ${error.message}');
      print('Response Data: ${error.response?.data}');
      logger.d('Response Headers: ${error.response?.headers}');
    }

    return message;
  }

  /// Formats authentication errors with guidance on how to resolve
  static String getAuthErrorMessage(dynamic error) {
    if (error is DioException) {
      return getNetworkErrorMessage(error);
    }

    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('invalid credentials') || errorMessage.contains('incorrect password')) {
      return 'Invalid email or password. Please try again.';
    } else if (errorMessage.contains('user not found')) {
      return 'Account not found. Please check your email or sign up.';
    } else if (errorMessage.contains('email already in use')) {
      return 'This email is already registered. Please use a different email or try logging in.';
    } else if (errorMessage.contains('otp') || errorMessage.contains('verification')) {
      return 'Verification code is invalid or expired. Please request a new code.';
    } else if (errorMessage.contains('token')) {
      return 'Your session has expired. Please sign in again.';
    }

    return 'Authentication error. Please try again or contact support.';
  }

  /// Formats general application errors
  static String getGeneralErrorMessage(dynamic error) {
    if (error is DioException) {
      return getNetworkErrorMessage(error);
    }

    // Fallback for unexpected errors
    return 'Something went wrong. Please try again later.';
  }
}
