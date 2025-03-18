/// Base failure class for all application failures
abstract class Failure {
  final String message;

  // Optional context for detailed error information (useful for debugging)
  final dynamic context;

  const Failure(this.message, {this.context});

  @override
  String toString() => message;
}

/// Unified failure type for network operations
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode, super.context});

  /// Creates a server failure with a user-friendly message based on the status code
  factory ServerFailure.fromStatusCode(int statusCode, {String? message, dynamic context}) {
    String defaultMessage;
    switch (statusCode) {
      case 400:
        defaultMessage = 'Invalid request. Please check your information.';
        break;
      case 401:
        defaultMessage = 'Your session has expired. Please sign in again.';
        break;
      case 403:
        defaultMessage = 'You don\'t have permission to access this resource.';
        break;
      case 404:
        defaultMessage = 'The requested resource was not found.';
        break;
      case 429:
        defaultMessage = 'Too many requests. Please try again later.';
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        defaultMessage = 'Server error. Please try again later.';
        break;
      default:
        defaultMessage = 'An unexpected error occurred. Please try again.';
    }

    return ServerFailure(message ?? defaultMessage, statusCode: statusCode, context: context);
  }
}

/// Failure for cache-related operations
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.context});

  factory CacheFailure.read() => const CacheFailure('Could not retrieve saved information. Please try again.');

  factory CacheFailure.write() => const CacheFailure('Could not save information. Please try again.');

  factory CacheFailure.clear() => const CacheFailure('Could not clear saved information. Please try again.');

  factory CacheFailure.logout() => const CacheFailure('Failed to clear login data. Please try again.');
}

/// Failure for authentication-related operations
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.context});

  factory AuthFailure.invalidCredentials() => const AuthFailure('Invalid email or password. Please try again.');

  factory AuthFailure.sessionExpired() => const AuthFailure('Your session has expired. Please sign in again.');

  factory AuthFailure.unauthorized() => const AuthFailure('You are not authorized to perform this action.');

  factory AuthFailure.invalidOtp() => const AuthFailure('Invalid verification code. Please try again.');

  factory AuthFailure.unableToAuthenticate() => const AuthFailure('Unable to authenticate. Please sign in again.');
}

/// Failure for form validation
class ValidationFailure extends Failure {
  final String? field;

  const ValidationFailure(super.message, {this.field, super.context});

  factory ValidationFailure.invalidEmail() => const ValidationFailure('Please enter a valid email address.', field: 'email');

  factory ValidationFailure.invalidPassword() => const ValidationFailure('Password must be at least 8 characters with letters and numbers.', field: 'password');

  factory ValidationFailure.invalidUsername() => const ValidationFailure('Username must be 3-20 characters and contain only letters, numbers, and underscores.', field: 'username');

  factory ValidationFailure.requiredField(String fieldName) => ValidationFailure('Please enter your $fieldName.', field: fieldName.toLowerCase());
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.context});

  factory NetworkFailure.noConnection() => const NetworkFailure('No internet connection. Please check your network settings and try again.');

  factory NetworkFailure.timeout() => const NetworkFailure('Connection timed out. Please try again when you have a stronger connection.');
}
