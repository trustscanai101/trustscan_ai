import 'package:dio/dio.dart';

/// Logging interceptor for debugging HTTP requests and responses.
final class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = false,
    this.responseBody = false,
    this.error = true,
  });

  final bool request;
  final bool requestHeader;
  final bool requestBody;
  final bool responseHeader;
  final bool responseBody;
  final bool error;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request) {
      _printRequestHeader(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (responseBody) {
      _printResponseHeader(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (error) {
      _printError(err);
    }
    handler.next(err);
  }

  void _printRequestHeader(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.writeln('*** Request ***');
    buffer.writeln('uri: ${options.uri}');
    buffer.writeln('method: ${options.method}');
    if (requestHeader) {
      buffer.writeln('headers: ${options.headers}');
    }
    if (requestBody && options.data != null) {
      buffer.writeln('data: ${options.data}');
    }
    buffer.writeln('***');
    // In production, use proper logging framework
    // ignore: avoid_print
    print(buffer.toString());
  }

  void _printResponseHeader(Response response) {
    final buffer = StringBuffer();
    buffer.writeln('*** Response ***');
    buffer.writeln('uri: ${response.requestOptions.uri}');
    buffer.writeln('status code: ${response.statusCode}');
    if (responseHeader) {
      buffer.writeln('headers: ${response.headers}');
    }
    if (responseBody) {
      buffer.writeln('data: ${response.data}');
    }
    buffer.writeln('***');
    // In production, use proper logging framework
    // ignore: avoid_print
    print(buffer.toString());
  }

  void _printError(DioException err) {
    final buffer = StringBuffer();
    buffer.writeln('*** Dio Error ***');
    buffer.writeln('uri: ${err.requestOptions.uri}');
    buffer.writeln('type: ${err.type}');
    buffer.writeln('message: ${err.message}');
    if (err.response != null) {
      buffer.writeln('response: ${err.response}');
    }
    buffer.writeln('***');
    // In production, use proper logging framework
    // ignore: avoid_print
    print(buffer.toString());
  }
}
