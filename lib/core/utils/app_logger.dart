import 'package:logger/logger.dart';

/// Centralized logger.
///
/// Replaces scattered `print`/`debugPrint` calls with a levelled logger that
/// stays silent in release builds. Callers must never pass passwords, tokens
/// or other secrets; use [redactPayload] when logging a payload of unknown
/// shape.
class AppLogger {
  AppLogger({LogFilter? filter, LogPrinter? printer, Level level = Level.debug})
    : _filter = filter ?? DevelopmentFilter() {
    _filter.level = level;
    _logger = Logger(
      filter: _filter,
      printer: printer ?? PrettyPrinter(methodCount: 0, printEmojis: false),
    );
  }

  /// Root instance used across the app. Assign a custom instance in tests.
  // ignore: use_setters_to_change_properties
  static AppLogger instance = AppLogger();

  final LogFilter _filter;
  late final Logger _logger;

  /// The underlying logger, exposed for infrastructure such as interceptors
  /// that need structured access.
  Logger get logger => _logger;

  void setLevel(Level level) => _filter.level = level;

  void d(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  void i(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  void w(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  /// Disables logging output for production builds.
  static void silence() => instance.setLevel(Level.off);
}

/// Replaces a value with a fixed mask so it can be logged safely.
const String redactedValue = '***';

/// Keys whose values must never be written to the console.
const Set<String> sensitiveKeys = {
  'authorization',
  'password',
  'newPassword',
  'oldPassword',
  'accessToken',
  'refreshToken',
  'token',
  'secret',
  'apiKey',
};

/// Returns a copy of [headers] with every credential masked.
Map<String, Object?> redactHeaders(Map<String, dynamic> headers) {
  return {
    for (final entry in headers.entries)
      entry.key: isSensitiveKey(entry.key) ? redactedValue : entry.value,
  };
}

/// Returns a loggable representation of [data], masking credential fields.
Object? redactPayload(Object? data) {
  if (data is Map) {
    return {
      for (final entry in data.entries)
        entry.key.toString(): isSensitiveKey(entry.key.toString())
            ? redactedValue
            : redactPayload(entry.value),
    };
  }
  if (data is Iterable) {
    return data.map(redactPayload).toList(growable: false);
  }
  return data;
}

/// `true` when [key] names a credential that must be masked before logging.
bool isSensitiveKey(String key) => sensitiveKeys.any(
  (sensitive) => key.toLowerCase() == sensitive.toLowerCase(),
);
