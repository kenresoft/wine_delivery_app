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

class NoRefreshTokenException extends AppException {
  const NoRefreshTokenException(super.message);
}

class InvalidAccessTokenException extends AppException {
  const InvalidAccessTokenException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

// Other potential exceptions (add as needed)
class BadRequestException extends AppException {
  const BadRequestException(super.message);
}

class ServerErrorException extends AppException {
  const ServerErrorException(super.message);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message);
}

class UnexpectedException extends AppException {
  const UnexpectedException(super.message);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message);
}