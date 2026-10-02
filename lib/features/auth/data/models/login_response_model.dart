import 'auth_tokens_model.dart';
import 'user_model.dart';

/// Envelope returned by `POST /auth/login`.
class LoginResponseModel {
  const LoginResponseModel({required this.user, required this.tokens});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final tokens =
        json['tokens'] as Map<String, dynamic>? ?? const <String, dynamic>{};
    return LoginResponseModel(
      user: UserModel.fromJson((json['user'] as Map<String, dynamic>?) ?? json),
      tokens: AuthTokensModel.fromJson(tokens),
    );
  }

  final UserModel user;
  final AuthTokensModel tokens;
}
