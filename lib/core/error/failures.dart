/// Base failure class for all application failures
abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

/// Unified failure type for network operations
class ServerFailure extends Failure {
  final int? statusCode;

  ServerFailure(super.message, {this.statusCode});
}

/// Failure for cache-related operations
class CacheFailure extends Failure {
  CacheFailure(super.message);
}

/// Failure for authentication-related operations
class AuthFailure extends Failure {
  AuthFailure(super.message);
}
