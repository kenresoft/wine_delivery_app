// Base exception class
abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() {
    return message;
  }
}

// Specific exception classes
class NoAccessTokenException extends AppException {
  const NoAccessTokenException(super.message);
}

class InvalidAccessTokenException extends AppException {
  const InvalidAccessTokenException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

// Other potential exceptions (add as needed)
class ServerErrorException extends AppException {
  const ServerErrorException(super.message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}