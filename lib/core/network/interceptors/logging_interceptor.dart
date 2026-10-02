import 'package:dio/dio.dart';

import '../../utils/app_logger.dart';

/// Logs requests, responses and errors in development builds.
///
/// Credentials are masked before anything reaches the console, and bodies are
/// only logged when the app runs with network logging enabled.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({this.logBodies = true, this.maxBodyLength = 1000});

  final bool logBodies;
  final int maxBodyLength;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.instance.d(
      '--> ${options.method} ${options.uri}\n'
      'headers: ${redactHeaders(options.headers)}',
    );
    if (logBodies && options.data != null) {
      AppLogger.instance.d(
        '--> body: ${_truncate(redactPayload(options.data))}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    AppLogger.instance.d(
      '<-- ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri}',
    );
    if (logBodies && response.data != null) {
      AppLogger.instance.d(
        '<-- body: ${_truncate(redactPayload(response.data))}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.instance.e(
      '<-- ${err.response?.statusCode ?? err.type.name} '
      '${err.requestOptions.method} ${err.requestOptions.uri}',
      err,
    );
    handler.next(err);
  }

  Object? _truncate(Object? value) {
    final sanitized = redactPayload(value);
    final encoded = sanitized.toString();
    if (encoded.length <= maxBodyLength) return sanitized;
    return '${encoded.substring(0, maxBodyLength)}… '
        '(truncated, ${encoded.length} chars)';
  }
}
