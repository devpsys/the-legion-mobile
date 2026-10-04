import '../../../../core/error/failures.dart';
import '../../../../core/error/validation.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../entities/registration.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Opens an applicant account.
///
/// Input rules are a business concern, so they live here rather than in a
/// widget, and they are checked in the order the form shows its fields so the
/// first problem reported is the first one the applicant will look at.
/// Problems are reported as a [ValidationFailure] naming the field; the
/// presentation layer maps the code to localized copy.
///
/// The password rule is the applicant one — "8 or more characters, with
/// letters and numbers" — which is looser than the staff policy the recovery
/// flow enforces. An applicant is not yet inside the institution.
class RegisterUseCase {
  const RegisterUseCase(this._repository);

  /// Minimum length enforced for passwords locally, as at sign-in.
  static const int minPasswordLength = 8;

  /// A phone number as people write them: an optional `+`, then digits with
  /// the spaces, hyphens and brackets of a formatted number.
  static final RegExp _phoneShape = RegExp(r'^\+?[0-9(][0-9 \-()]*$');

  /// How many digits a phone number has once formatting is stripped.
  static const int minPhoneDigits = 7;
  static const int maxPhoneDigits = 15;

  static final RegExp _letter = RegExp('[A-Za-z]');
  static final RegExp _digit = RegExp('[0-9]');
  static final RegExp _nonDigit = RegExp('[^0-9]');

  final AuthRepository _repository;

  Future<User> call({
    required String firstName,
    required String surname,
    required String email,
    required String password,
    required String confirmPassword,
    String otherNames = '',
    String phone = '',
  }) async {
    if (firstName.isBlank) {
      throw _failure(ValidationField.firstName, ValidationCode.required);
    }
    if (surname.isBlank) {
      throw _failure(ValidationField.surname, ValidationCode.required);
    }
    if (email.isBlank) {
      throw _failure(ValidationField.email, ValidationCode.required);
    }
    if (!email.isValidEmail) {
      throw _failure(ValidationField.email, ValidationCode.invalidEmail);
    }
    if (phone.isNotBlank && !isPlausiblePhone(phone)) {
      throw _failure(ValidationField.phone, ValidationCode.invalidPhone);
    }
    if (password.isBlank) {
      throw _failure(ValidationField.password, ValidationCode.required);
    }
    if (password.length < minPasswordLength) {
      throw _failure(ValidationField.password, ValidationCode.passwordTooShort);
    }
    if (!hasLettersAndNumbers(password)) {
      throw _failure(
        ValidationField.password,
        ValidationCode.passwordNeedsLettersAndNumbers,
      );
    }
    if (confirmPassword.isBlank) {
      throw _failure(ValidationField.confirmPassword, ValidationCode.required);
    }
    if (confirmPassword != password) {
      throw _failure(
        ValidationField.confirmPassword,
        ValidationCode.passwordMismatch,
      );
    }

    return _repository.register(
      Registration(
        firstName: firstName.trimmed,
        surname: surname.trimmed,
        otherNames: otherNames.isBlank ? null : otherNames.trimmed,
        email: email.trimmed,
        phone: phone.isBlank ? null : phone.trimmed,
        password: password,
      ),
    );
  }

  /// `true` when [password] carries at least one letter and one digit.
  static bool hasLettersAndNumbers(String password) =>
      _letter.hasMatch(password) && _digit.hasMatch(password);

  /// `true` when [phone] has the shape of a number somebody could be called
  /// on. The API remains the source of truth.
  static bool isPlausiblePhone(String phone) {
    final value = phone.trimmed;
    if (!_phoneShape.hasMatch(value)) return false;
    final digits = value.replaceAll(_nonDigit, '').length;
    return digits >= minPhoneDigits && digits <= maxPhoneDigits;
  }

  ValidationFailure _failure(ValidationField field, ValidationCode code) =>
      ValidationFailure(field: field, validationCode: code);
}
