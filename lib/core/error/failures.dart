import 'package:equatable/equatable.dart';

/// User-facing error model consumed by the presentation layer.
sealed class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Connectivity, timeout, or transport-level request failures.
final class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    this.statusCode,
    this.isTimeout = false,
  });

  final int? statusCode;
  final bool isTimeout;

  @override
  List<Object?> get props => [message, statusCode, isTimeout];
}

/// Non-success HTTP/API responses from remote providers.
final class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    this.statusCode,
    this.errorCode,
    this.provider,
  });

  final int? statusCode;
  final String? errorCode;
  final String? provider;

  @override
  List<Object?> get props => [message, statusCode, errorCode, provider];
}

/// Invalid user input or malformed local payloads.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.field,
  });

  final String? field;

  @override
  List<Object?> get props => [message, field];
}

/// Authentication and authorization failures.
final class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    this.code,
    this.provider,
  });

  final String? code;
  final String? provider;

  @override
  List<Object?> get props => [message, code, provider];
}

/// AI or threat-intelligence analysis pipeline failures.
final class ScanAnalysisFailure extends Failure {
  const ScanAnalysisFailure({
    required super.message,
    this.provider,
    this.errorCode,
  });

  final String? provider;
  final String? errorCode;

  @override
  List<Object?> get props => [message, provider, errorCode];
}

/// Local persistence read/write failures.
final class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    this.operation,
  });

  final String? operation;

  @override
  List<Object?> get props => [message, operation];
}

/// Unclassified or unexpected failures.
final class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
