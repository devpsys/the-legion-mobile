import 'package:equatable/equatable.dart';

import 'environment.dart';

/// Immutable, compile-time resolved application configuration.
///
/// Every environment specific value is read from a `--dart-define`, which
/// keeps secrets and environment URLs out of the source tree and works
/// identically on Android, iOS and Web.
///
/// ```sh
/// flutter run --dart-define=ENVIRONMENT=staging \
///   --dart-define=STAGING_API_BASE_URL=https://staging.example.com
/// ```
class AppConfig extends Equatable {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.networkTimeout,
    required this.enableNetworkLogging,
  });

  /// Builds the configuration from the compile-time environment.
  factory AppConfig.fromEnvironment() {
    final environment = Environment.fromName(_environmentName);
    return AppConfig(
      environment: environment,
      apiBaseUrl: _apiBaseUrls[environment]!,
      networkTimeout: _networkTimeout,
      enableNetworkLogging:
          _enableNetworkLogging && environment.enableDeveloperTools,
    );
  }

  static const String _environmentName = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static const bool _enableNetworkLogging = bool.fromEnvironment(
    'ENABLE_NETWORK_LOGGING',
    defaultValue: true,
  );

  static const Duration _networkTimeout = Duration(
    seconds: int.fromEnvironment('API_TIMEOUT_SECONDS', defaultValue: 30),
  );

  static const Map<Environment, String> _apiBaseUrls = {
    Environment.development: String.fromEnvironment(
      'DEV_API_BASE_URL',
      defaultValue: 'https://dev-api.the-legion.example.com',
    ),
    Environment.staging: String.fromEnvironment(
      'STAGING_API_BASE_URL',
      defaultValue: 'https://staging-api.the-legion.example.com',
    ),
    Environment.production: String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'https://api.the-legion.example.com',
    ),
  };

  /// The environment this build was compiled for.
  final Environment environment;

  /// Base URL every request is resolved against. Never hardcode this in a
  /// feature; inject [AppConfig] instead.
  final String apiBaseUrl;

  /// Connect, send and receive timeout shared by all requests.
  final Duration networkTimeout;

  /// Whether request/response bodies may be written to the console.
  final bool enableNetworkLogging;

  @override
  List<Object?> get props => [
    environment,
    apiBaseUrl,
    networkTimeout,
    enableNetworkLogging,
  ];
}
