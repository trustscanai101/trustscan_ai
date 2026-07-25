import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../error/exceptions.dart';
import 'logging_interceptor.dart';

/// HTTP client wrapper using Dio with configured timeouts and interceptors.
final class DioClient {
  DioClient._({
    required this.appConfig,
    required this.dio,
  });

  /// Creates a DioClient with the given [AppConfig].
  factory DioClient.create({
    required AppConfig appConfig,
    bool enableLogging = false,
  }) {
    final dio = Dio();

    // Configure base options
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add logging interceptor if enabled
    if (enableLogging) {
      dio.interceptors.add(LoggingInterceptor());
    }

    // Add error handling interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final exception = _mapDioException(error);
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: exception,
            message: exception.message,
          ));
        },
      ),
    );

    return DioClient._(
      appConfig: appConfig,
      dio: dio,
    );
  }

  final AppConfig appConfig;
  final Dio dio;

  /// Creates a Dio instance configured for Gemini API.
  Dio get geminiDio {
    final geminiDio = Dio(dio.options);
    geminiDio.options.baseUrl = appConfig.geminiApiBaseUrl;
    geminiDio.options.queryParameters = {'key': appConfig.geminiApiKey};
    return geminiDio;
  }

  /// Creates a Dio instance configured for Google Safe Browsing API.
  Dio get googleSafeBrowsingDio {
    final safeBrowsingDio = Dio(dio.options);
    safeBrowsingDio.options.baseUrl = appConfig.googleSafeBrowsingApiBaseUrl;
    safeBrowsingDio.options.queryParameters = {'key': appConfig.googleSafeBrowsingApiKey};
    return safeBrowsingDio;
  }

  /// Creates a Dio instance configured for VirusTotal API.
  Dio get virusTotalDio {
    final virusTotalDio = Dio(dio.options);
    virusTotalDio.options.baseUrl = appConfig.virusTotalApiBaseUrl;
    virusTotalDio.options.headers['x-apikey'] = appConfig.virusTotalApiKey;
    return virusTotalDio;
  }

  /// Creates a Dio instance with a custom base URL.
  Dio createCustomDio(String baseUrl) {
    final customDio = Dio(dio.options);
    customDio.options.baseUrl = baseUrl;
    return customDio;
  }

  /// Maps Dio exceptions to application-specific exceptions.
  static AppException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          message: 'Request timeout. Please check your connection.',
          isTimeout: true,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _getErrorMessage(statusCode);
        return ServerException(
          message: message,
          statusCode: statusCode,
          provider: _getProviderFromUrl(error.requestOptions.uri),
        );

      case DioExceptionType.cancel:
        return NetworkException(
          message: 'Request was cancelled.',
        );

      case DioExceptionType.unknown:
        return NetworkException(
          message: 'An unknown network error occurred.',
          cause: error.error,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'SSL certificate error.',
        );

      case DioExceptionType.transformTimeout:
        return NetworkException(
          message: 'Data transformation timeout.',
          isTimeout: true,
        );
    }
  }

  static String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Invalid API key.';
      case 403:
        return 'Forbidden. Access denied.';
      case 404:
        return 'Resource not found.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
      case 503:
      case 504:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Request failed with status: $statusCode';
    }
  }

  static String? _getProviderFromUrl(Uri uri) {
    if (uri.host.contains('googleapis.com')) {
      return 'Google';
    } else if (uri.host.contains('virustotal.com')) {
      return 'VirusTotal';
    }
    return null;
  }
}
