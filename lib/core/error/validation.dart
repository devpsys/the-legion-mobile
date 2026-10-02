/// The field a [ValidationFailure] refers to.
///
/// Lives in `core` so both the domain layer (which raises validation
/// failures) and the presentation layer (which renders them) can agree on it
/// without the domain depending on Flutter.
enum ValidationField { email, password, generic }

/// A machine readable reason why input was rejected.
///
/// The presentation layer maps these codes onto localized strings, which keeps
/// user-facing copy out of the domain layer.
enum ValidationCode {
  required,
  invalidEmail,
  passwordTooShort,
  invalidCredentials,
  invalidRequest,
}
