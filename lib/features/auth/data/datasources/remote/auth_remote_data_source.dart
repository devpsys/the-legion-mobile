import 'package:dio/dio.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/network/api_call.dart';
import '../../../../../core/network/interceptors/auth_interceptor.dart';
import '../../models/login_response_model.dart';

/// Remote source for authentication.
abstract interface class AuthRemoteDataSource {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });
}

/// Dio backed implementation.
///
/// Receives the already configured client from the service locator; it never
/// builds its own.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  /// Endpoint paths. Relative to the environment base URL from `AppConfig`.
  static const String loginPath = '/auth/login';

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

    final body = response.data;
    if (body == null || body.isEmpty) {
      throw const ServerException('Login response was empty');
    }

    return LoginResponseModel.fromJson(body);
  }
}
