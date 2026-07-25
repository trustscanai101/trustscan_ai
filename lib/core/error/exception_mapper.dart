import 'exceptions.dart';
import 'failures.dart';

/// Maps data-layer exceptions into presentation-safe [Failure] values.
Failure mapExceptionToFailure(Object error) {
  if (error is Failure) {
    return error;
  }

  if (error is AppException) {
    return switch (error) {
      NetworkException(:final message, :final statusCode, :final isTimeout) =>
        NetworkFailure(
          message: message,
          statusCode: statusCode,
          isTimeout: isTimeout,
        ),
      ServerException(
        :final message,
        :final statusCode,
        :final errorCode,
        :final provider,
      ) =>
        ServerFailure(
          message: message,
          statusCode: statusCode,
          errorCode: errorCode,
          provider: provider,
        ),
      ValidationException(:final message, :final field) => ValidationFailure(
          message: message,
          field: field,
        ),
      AuthException(:final message, :final code, :final provider) => AuthFailure(
          message: message,
          code: code,
          provider: provider,
        ),
      CacheException(:final message, :final operation) => CacheFailure(
          message: message,
          operation: operation,
        ),
    };
  }

  return UnknownFailure(message: error.toString());
}

/// Maps provider-specific scan/analysis exceptions into [ScanAnalysisFailure].
Failure mapScanAnalysisException({
  required String message,
  String? provider,
  String? errorCode,
  Object? cause,
}) {
  return ScanAnalysisFailure(
    message: message,
    provider: provider,
    errorCode: errorCode,
  );
}
