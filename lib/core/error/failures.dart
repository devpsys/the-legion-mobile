import 'package:equatable/equatable.dart';

import 'validation.dart';

/// Domain level error.
///
/// Datasources throw [AppException]s, repositories translate them into a
/// [Failure] and only [Failure]s reach the presentation layer. A `Failure`
/// carries a diagnostic [message] for logs and structured [code] metadata for
/// branching; user-facing text is produced by the localization layer so this
/// class never has to know about `AppLocalizations`.
abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    this.code,
    this.statusCode,
    this.cause,
  });

  /// Developer-facing description. Safe to log, never shown verbatim.
  final String message;

  /// Optional machine readable error code returned by the API.
  final String? code;

  /// HTTP status code when the failure originated from a response.
  final int? statusCode;

  /// Underlying error, kept for logging only.
  final Object? cause;

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// The API responded, but with an unusable result (5xx, malformed payload).
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.statusCode,
    super.cause,
  });
}

/// The device could not reach the API (offline, timeout, TLS problem).
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code, super.cause});
}

/// Credentials are missing, invalid or insufficient (401/403).
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.statusCode,
    super.cause,
  });
}

/// User input was rejected, either locally or by the API.
class ValidationFailure extends Failure {
  const ValidationFailure({
    required this.field,
    required this.validationCode,
    String? message,
    super.statusCode,
    super.cause,
  }) : super(message: message ?? 'Validation failed');

  /// The input field the error belongs to.
  final ValidationField field;

  /// Machine readable reason, mapped to localized copy by the UI layer.
  final ValidationCode validationCode;

  @override
  List<Object?> get props => [...super.props, field, validationCode];
}

/// Local persistence failed (Hive, secure storage).
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code, super.cause});
}

/// Last resort failure for anything that should not have happened.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.code, super.cause});
}
