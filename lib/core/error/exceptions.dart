/// Base type for recoverable errors raised inside the data layer.
sealed class AppException implements Exception {
  const AppException({
    required this.message,
    this.cause,
  });

  final String message;
  final Object? cause;

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType: $message');
    if (cause != null) {
      buffer.write(' (cause: $cause)');
    }
    return buffer.toString();
  }
}

/// Connectivity, timeout, or transport-level request failures.
final class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.cause,
    this.statusCode,
    this.isTimeout = false,
  });

  final int? statusCode;
  final bool isTimeout;
}

/// Non-success HTTP/API responses from remote providers.
final class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.cause,
    this.statusCode,
    this.errorCode,
    this.provider,
  });

  final int? statusCode;
  final String? errorCode;
  final String? provider;
}

/// Invalid user input or malformed local payloads.
final class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.cause,
    this.field,
  });

  final String? field;
}

/// Authentication and authorization failures.
final class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.cause,
    this.code,
    this.provider,
  });

  final String? code;
  final String? provider;
}

/// Local persistence read/write failures.
final class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.cause,
    this.operation,
  });

  final String? operation;
}
