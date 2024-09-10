/*
abstract class AppException implements Exception {
}
*/

class NoAccessTokenException implements Exception {
  final String message;

  const NoAccessTokenException(this.message);

  @override
  String toString() {
    return message;
  }
}