import 'dart:async';

import 'package:dio/dio.dart';

import '../../utils/app_logger.dart';
import '../auth_token_provider.dart';

/// Attaches the `Authorization` header to outgoing requests and reports
/// unauthorized responses back to the session owner.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider);

  /// Set as `RequestOptions.extra[skipAuth]` to perform a request without
  /// credentials, e.g. the login call itself.
  static const String skipAuth = 'skipAuth';

  static const String _authorizationHeader = 'Authorization';

  final AuthTokenProvider _tokenProvider;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_skipsAuth(options)) {
      handler.next(options);
      return;
    }

    try {
      final token = await _tokenProvider.accessToken();
      if (token != null && token.isNotEmpty) {
        options.headers[_authorizationHeader] = 'Bearer $token';
      }
    } catch (error, stackTrace) {
      // A failing token lookup must not block the request; the API will
      // answer with 401 if the credentials were actually required.
      AppLogger.instance.w(
        'Could not read the access token',
        error,
        stackTrace,
      );
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 && !_skipsAuth(err.requestOptions)) {
      unawaited(_notifyUnauthorized(err));
    }
    handler.next(err);
  }

  Future<void> _notifyUnauthorized(DioException error) async {
    try {
      await _tokenProvider.onUnauthorized();
    } catch (e, stackTrace) {
      AppLogger.instance.w('Failed to clear the session', e, stackTrace);
    }
  }

  bool _skipsAuth(RequestOptions options) => options.extra[skipAuth] == true;
}
