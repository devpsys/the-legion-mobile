import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'auth_token_provider.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Builds the single, fully configured [Dio] instance of the application.
///
/// Base URL, timeouts and headers are derived from [AppConfig]; features
/// receive this client through dependency injection and must never build
/// their own.
Dio createDio(
  AppConfig config, {
  required AuthTokenProvider authTokenProvider,
  List<Interceptor> additionalInterceptors = const [],
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: config.networkTimeout,
      receiveTimeout: config.networkTimeout,
      sendTimeout: config.networkTimeout,
      headers: const <String, dynamic>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      responseType: ResponseType.json,
      followRedirects: true,
    ),
  );

  if (config.enableNetworkLogging) {
    dio.interceptors.add(LoggingInterceptor());
  }

  dio.interceptors.addAll(<Interceptor>[
    AuthInterceptor(authTokenProvider),
    ...additionalInterceptors,
  ]);

  return dio;
}
