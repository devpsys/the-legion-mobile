/// The deployment environments the application can be built against.
///
/// The active environment is selected at compile time through the
/// `ENVIRONMENT` dart-define, so no environment specific value is ever
/// hardcoded in feature code.
enum Environment {
  development,
  staging,
  production;

  /// Resolves an environment from its `--dart-define` name, falling back to
  /// [Environment.development] for unknown or missing values so that a
  /// developer build never accidentally targets production.
  static Environment fromName(String? name) {
    final normalized = name?.trim().toLowerCase();
    return Environment.values.firstWhere(
      (environment) => environment.name == normalized,
      orElse: () => Environment.development,
    );
  }

  bool get isDevelopment => this == Environment.development;

  bool get isProduction => this == Environment.production;

  /// Whether developer oriented tooling (network logging, debug banners)
  /// should be active for this environment.
  bool get enableDeveloperTools => !isProduction;
}
