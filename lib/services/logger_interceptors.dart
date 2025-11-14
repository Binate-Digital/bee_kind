// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/web.dart';

class LoggingInterceptor extends Interceptor {
  final Logger logger;

  LoggingInterceptor()
    : logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0, // Number of method calls to be displayed
          errorMethodCount:
              5, // Number of method calls if stacktrace is provided
          lineLength: 120, // Width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: true, // Should each log print contain a timestamp
        ),
      );

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _logRequest(options);
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _logError(err);
    handler.next(err);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _logResponse(response);
    handler.next(response);
  }

  void _logRequest(RequestOptions options) {
    logger.d('*** API Request - Start ***');
    logger.d('URI: ${options.uri}');
    logger.d('METHOD: ${options.method}');
    logger.d('HEADERS: ${_formatMap(options.headers)}');
    logger.d('REQUEST BODY: ${_formatBody(options.data)}');
    logger.d('*** API Request - End ***');
  }

  void _logError(DioError err) {
    logger.e('*** API Error - Start ***');
    logger.e('URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      logger.e('STATUS CODE: ${err.response?.statusCode}');
      logger.e('REDIRECT: ${err.response?.realUri}');
      logger.e('ERROR BODY: ${err.response?.data.toString()}');
    }
    logger.e('ERROR MESSAGE: ${err.toString()}');
    logger.e('*** API Error - End ***');
  }

  void _logResponse(Response response) {
    logger.i('*** API Response - Start ***');
    logger.i('URI: ${response.requestOptions.uri}');
    logger.i('STATUS CODE: ${response.statusCode}');
    logger.i('REDIRECT: ${response.isRedirect}');
    logger.i('RESPONSE BODY: ${_formatBody(response.data)}');
    logger.i('*** API Response - End ***');
  }

  String _formatBody(dynamic body) {
    if (body is Map) {
      return const JsonEncoder.withIndent('  ').convert(body);
    } else if (body is FormData) {
      final fields = body.fields
          .map((field) => '${field.key}: ${field.value}')
          .join('\n');
      final files = body.files
          .map((file) => '${file.key}: ${file.value.filename}')
          .join('\n');
      return 'Fields:\n$fields\nFiles:\n$files';
    } else {
      return body.toString();
    }
  }

  String _formatMap(Map<String, dynamic> map) {
    return map.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
  }
}
