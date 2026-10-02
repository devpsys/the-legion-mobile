import '../../../../core/error/failures.dart';
import '../../../../core/error/validation.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Authenticates a user.
///
/// Input rules are a business concern, so they live here (in the domain layer)
/// rather than in a widget. Validation problems are reported as a
/// [ValidationFailure]; the presentation layer maps the code to localized copy.
class LoginUseCase {
  const LoginUseCase(this._repository);

  /// Minimum length enforced for passwords locally.
  static const int minPasswordLength = 8;

  final AuthRepository _repository;

  Future<User> call({required String email, required String password}) async {
    if (email.isBlank) {
      throw _failure(ValidationField.email, ValidationCode.required);
    }
    if (!email.isValidEmail) {
      throw _failure(ValidationField.email, ValidationCode.invalidEmail);
    }
    if (password.isBlank) {
      throw _failure(ValidationField.password, ValidationCode.required);
    }
    if (password.length < minPasswordLength) {
      throw _failure(ValidationField.password, ValidationCode.passwordTooShort);
    }

    return _repository.login(email: email.trimmed, password: password);
  }

  ValidationFailure _failure(ValidationField field, ValidationCode code) =>
      ValidationFailure(field: field, validationCode: code);
}
