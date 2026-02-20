class AppException implements Exception {
  final String message;
  final Object? cause;

  AppException(this.message, {this.cause});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException(super.message);
}

class CacheException extends AppException {
  CacheException(super.message);
}