import 'package:equatable/equatable.dart';

import 'failures.dart';
import 'validation.dart';

/// Infrastructure level error.
///
/// Thrown by datasources (remote and local). Repositories convert these into
/// [Failure]s so that raw `DioException`/`HiveError` objects never escape the
/// data layer.
abstract class AppException extends Equatable implements Exception {
  const AppException(this.message, {this.code, this.statusCode, this.cause});

  final String message;
  final String? code;
  final int? statusCode;
  final Object? cause;

  /// The domain level representation of this error.
  Failure toFailure();

  @override
  List<Object?> get props => [message, code, statusCode];

  @override
  String toString() => '$runtimeType: $message';
}

/// The API answered with an error status or an unreadable body.
class ServerException extends AppException {
  const ServerException(
    super.message, {
    super.code,
    super.statusCode,
    super.cause,
  });

  @override
  Failure toFailure() => ServerFailure(
    message: message,
    code: code,
    statusCode: statusCode,
    cause: cause,
  );
}

/// No usable connection: offline, timeout, cancelled or bad certificate.
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.cause});

  @override
  Failure toFailure() =>
      NetworkFailure(message: message, code: code, cause: cause);
}

/// The API rejected the credentials (401/403).
class UnauthorizedException extends AppException {
  const UnauthorizedException(
    super.message, {
    super.code,
    super.statusCode,
    super.cause,
  });

  @override
  Failure toFailure() => AuthFailure(
    message: message,
    code: code,
    statusCode: statusCode,
    cause: cause,
  );
}

/// The API rejected the submitted payload.
class ValidationException extends AppException {
  const ValidationException({
    required this.field,
    required this.validationCode,
    String? message,
    super.statusCode,
    super.cause,
  }) : super(message ?? 'Validation failed');

  final ValidationField field;

  final ValidationCode validationCode;

  @override
  Failure toFailure() => ValidationFailure(
    field: field,
    validationCode: validationCode,
    message: message,
    statusCode: statusCode,
    cause: cause,
  );

  @override
  List<Object?> get props => [...super.props, field];
}

/// Reading from or writing to local storage failed.
class CacheException extends AppException {
  const CacheException(super.message, {super.code, super.cause});

  @override
  Failure toFailure() =>
      CacheFailure(message: message, code: code, cause: cause);
}

/// Anything unexpected that still needs a typed representation.
class UnexpectedException extends AppException {
  const UnexpectedException(super.message, {super.code, super.cause});

  @override
  Failure toFailure() =>
      UnexpectedFailure(message: message, code: code, cause: cause);
}
