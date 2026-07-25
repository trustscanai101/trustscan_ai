import 'package:flutter_test/flutter_test.dart';
import 'package:trustscan_ai/core/error/exception_mapper.dart';
import 'package:trustscan_ai/core/error/exceptions.dart';
import 'package:trustscan_ai/core/error/failures.dart';

void main() {
  group('mapExceptionToFailure', () {
    test('maps NetworkException to NetworkFailure', () {
      const exception = NetworkException(
        message: 'No internet connection',
        isTimeout: true,
      );

      final failure = mapExceptionToFailure(exception);

      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'No internet connection');
      expect((failure as NetworkFailure).isTimeout, isTrue);
    });

    test('maps ServerException to ServerFailure with provider metadata', () {
      const exception = ServerException(
        message: 'Gemini request failed',
        statusCode: 503,
        errorCode: 'UNAVAILABLE',
        provider: 'gemini',
      );

      final failure = mapExceptionToFailure(exception);

      expect(failure, isA<ServerFailure>());
      final serverFailure = failure as ServerFailure;
      expect(serverFailure.statusCode, 503);
      expect(serverFailure.errorCode, 'UNAVAILABLE');
      expect(serverFailure.provider, 'gemini');
    });

    test('maps ValidationException to ValidationFailure', () {
      const exception = ValidationException(
        message: 'Invalid phone number',
        field: 'phoneNumber',
      );

      final failure = mapExceptionToFailure(exception);

      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).field, 'phoneNumber');
    });

    test('maps AuthException to AuthFailure', () {
      const exception = AuthException(
        message: 'Sign-in cancelled',
        code: 'sign_in_cancelled',
        provider: 'firebase',
      );

      final failure = mapExceptionToFailure(exception);

      expect(failure, isA<AuthFailure>());
      final authFailure = failure as AuthFailure;
      expect(authFailure.code, 'sign_in_cancelled');
      expect(authFailure.provider, 'firebase');
    });

    test('maps CacheException to CacheFailure', () {
      const exception = CacheException(
        message: 'Failed to read scan history',
        operation: 'read',
      );

      final failure = mapExceptionToFailure(exception);

      expect(failure, isA<CacheFailure>());
      expect((failure as CacheFailure).operation, 'read');
    });

    test('returns same instance when error is already a Failure', () {
      const failure = UnknownFailure(message: 'Unexpected');

      expect(mapExceptionToFailure(failure), same(failure));
    });

    test('maps unknown objects to UnknownFailure', () {
      final failure = mapExceptionToFailure(Exception('Something broke'));

      expect(failure, isA<UnknownFailure>());
      expect(failure.message, contains('Something broke'));
    });
  });

  group('mapScanAnalysisException', () {
    test('creates ScanAnalysisFailure with provider context', () {
      final failure = mapScanAnalysisException(
        message: 'Safe Browsing lookup failed',
        provider: 'google_safe_browsing',
        errorCode: 'THREAT_INTEL_UNAVAILABLE',
      );

      expect(failure, isA<ScanAnalysisFailure>());
      final scanFailure = failure as ScanAnalysisFailure;
      expect(scanFailure.provider, 'google_safe_browsing');
      expect(scanFailure.errorCode, 'THREAT_INTEL_UNAVAILABLE');
    });
  });
}
