import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/error/dio_exception_mapper.dart';
import 'package:the_legion_mobile/core/error/exceptions.dart';
import 'package:the_legion_mobile/core/error/validation.dart';

void main() {
  final requestOptions = RequestOptions(path: '/auth/login');

  DioException errorOf(DioExceptionType type, {Response<dynamic>? response}) {
    return DioException(
      requestOptions: requestOptions,
      type: type,
      response: response,
    );
  }

  Response<dynamic> responseWith(int statusCode, {Object? body}) {
    return Response<dynamic>(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: body,
    );
  }

  group('DioExceptionMapper', () {
    test('maps timeouts to a network exception', () {
      final result = DioExceptionMapper.map(
        errorOf(DioExceptionType.receiveTimeout),
      );

      expect(result, isA<NetworkException>());
    });

    test('maps connection errors to a network exception', () {
      final result = DioExceptionMapper.map(
        errorOf(DioExceptionType.connectionError),
      );

      expect(result, isA<NetworkException>());
    });

    test('maps 401 to an unauthorized exception', () {
      final result = DioExceptionMapper.map(
        errorOf(DioExceptionType.badResponse, response: responseWith(401)),
      );

      expect(result, isA<UnauthorizedException>());
      expect(result.statusCode, 401);
    });

    test('maps 422 to a validation exception', () {
      final result = DioExceptionMapper.map(
        errorOf(
          DioExceptionType.badResponse,
          response: responseWith(422, body: const {'message': 'invalid'}),
        ),
      );

      expect(result, isA<ValidationException>());
      expect((result as ValidationException).field, ValidationField.generic);
    });

    test('extracts the server message from the error body', () {
      final result = DioExceptionMapper.map(
        errorOf(
          DioExceptionType.badResponse,
          response: responseWith(500, body: const {'message': 'boom'}),
        ),
      );

      expect(result, isA<ServerException>());
      expect(result.message, 'boom');
    });

    test('falls back to the status code when the body has no message', () {
      final result = DioExceptionMapper.map(
        errorOf(DioExceptionType.badResponse, response: responseWith(503)),
      );

      expect(result, isA<ServerException>());
      expect(result.message, contains('503'));
    });

    test('every exception converts into a failure', () {
      final result = DioExceptionMapper.map(errorOf(DioExceptionType.cancel));

      expect(result.toFailure(), isNotNull);
    });
  });
}
