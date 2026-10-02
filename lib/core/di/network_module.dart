import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../config/app_config.dart';
import '../network/auth_token_provider.dart';
import '../network/dio_client.dart';
import '../utils/app_logger.dart';

/// Registers the shared HTTP client.
///
/// The single [Dio] instance is built from [AppConfig]; features receive it
/// through the service locator and never create their own client.
void registerNetworkModule(GetIt sl) {
  sl.registerLazySingleton<Dio>(
    () =>
        createDio(sl<AppConfig>(), authTokenProvider: sl<AuthTokenProvider>()),
  );
}

/// Silences the logger for production builds.
void configureLogging(GetIt sl) {
  if (sl<AppConfig>().environment.isProduction) {
    AppLogger.silence();
  }
}
