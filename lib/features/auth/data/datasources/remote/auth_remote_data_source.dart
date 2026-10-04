import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/validation.dart';
import '../../../../../core/network/api_call.dart';
import '../../../../../core/network/interceptors/auth_interceptor.dart';
import '../../../domain/entities/registration.dart';
import '../../models/login_response_model.dart';
import '../../models/registration_request_model.dart';

/// Remote source for authentication.
abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  /// Opens an applicant account. Answers with the session it starts with,
  /// in the same envelope as [login].
  Future<LoginResponseModel> register(Registration registration);
}

/// Dio backed implementation.
///
/// Receives the already configured client from the service locator; it never
/// builds its own.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  /// Endpoint paths. Relative to the environment base URL from `AppConfig`.
  static const String loginPath = '/auth/login';
  static const String registerPath = '/auth/register';

  /// The status the register endpoint answers an address it already holds.
  static const int conflictStatusCode = 409;

  final Dio _dio;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiCall(
      () => _dio.post<Map<String, dynamic>>(
        loginPath,
        data: <String, dynamic>{'email': email, 'password': password},
        // The login call itself must not carry (stale) credentials.
        options: Options(extra: const {AuthInterceptor.skipAuth: true}),
      ),
    );

    return _sessionFrom(response.data, 'Login response was empty');
  }

  @override
  Future<LoginResponseModel> register(Registration registration) async {
    final Response<Map<String, dynamic>> response;
    try {
      response = await apiCall(
        () => _dio.post<Map<String, dynamic>>(
          registerPath,
          data: RegistrationRequestModel(registration).toJson(),
          // Nobody is signed in yet.
          options: Options(extra: const {AuthInterceptor.skipAuth: true}),
        ),
      );
    } on ServerException catch (error) {
      // A conflict here has exactly one meaning, and it belongs under the
      // email field rather than in a generic server banner.
      if (error.statusCode == conflictStatusCode) {
        throw ValidationException(
          field: ValidationField.email,
          validationCode: ValidationCode.emailAlreadyRegistered,
          message: error.message,
          statusCode: error.statusCode,
          cause: error.cause,
        );
      }
      rethrow;
    }

    return _sessionFrom(response.data, 'Register response was empty');
  }

  LoginResponseModel _sessionFrom(
    Map<String, dynamic>? body,
    String emptyMessage,
  ) {
    if (body == null || body.isEmpty) {
      throw ServerException(emptyMessage);
    }
    return LoginResponseModel.fromJson(body);
  }
}
