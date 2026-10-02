import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'validation.dart';

/// Translates transport level [DioException]s into typed [AppException]s.
///
/// Kept as a pure function so the mapping can be unit tested without a real
/// `Dio` instance.
abstract final class DioExceptionMapper {
  const DioExceptionMapper._();

  /// Maps [error] onto the matching [AppException].
  static AppException map(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout => NetworkException(
        'Request timed out (${error.type.name})',
        code: error.type.name,
        cause: error,
      ),
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => NetworkException(
        error.message ?? 'Unable to reach the server',
        code: error.type.name,
        cause: error,
      ),
      DioExceptionType.cancel => NetworkException(
        'Request cancelled',
        code: error.type.name,
        cause: error,
      ),
      DioExceptionType.badResponse => _fromResponse(error),
      DioExceptionType.unknown => UnexpectedException(
        error.message ?? 'Unexpected network error',
        code: error.type.name,
        cause: error,
      ),
    };
  }

  static AppException _fromResponse(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final serverMessage = _messageFromBody(response?.data);

    switch (statusCode) {
      case 400 || 422:
        return ValidationException(
          field: ValidationField.generic,
          validationCode: ValidationCode.invalidRequest,
          message: serverMessage ?? 'Request was rejected',
          statusCode: statusCode,
          cause: error,
        );
      case 401 || 403:
        return UnauthorizedException(
          serverMessage ?? 'Unauthorized',
          statusCode: statusCode,
          cause: error,
        );
      default:
        return ServerException(
          serverMessage ?? 'Server returned $statusCode',
          statusCode: statusCode,
          cause: error,
        );
    }
  }

  /// Best effort extraction of a human readable message from an error body
  /// shaped like `{"message": "..."}` or `{"error": "..."}`.
  static String? _messageFromBody(Object? body) {
    if (body is! Map) return null;
    final candidate = body['message'] ?? body['error'];
    return candidate is String && candidate.isNotEmpty ? candidate : null;
  }
}
