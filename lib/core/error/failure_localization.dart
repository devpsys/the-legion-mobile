import '../l10n/gen/app_localizations.dart';
import 'failures.dart';
import 'validation.dart';

/// Maps a [ValidationCode] onto localized copy.
extension ValidationCodeLocalization on ValidationCode {
  String localize(AppLocalizations l10n) => switch (this) {
    ValidationCode.required => l10n.validationRequired,
    ValidationCode.invalidEmail => l10n.validationInvalidEmail,
    ValidationCode.passwordTooShort => l10n.validationPasswordTooShort,
    ValidationCode.invalidCredentials => l10n.validationInvalidCredentials,
    ValidationCode.invalidRequest => l10n.validationInvalidRequest,
  };
}

/// Maps a [Failure] onto localized, user-facing copy.
///
/// Presentation code calls `failure.localize(l10n)` instead of showing raw
/// exception messages, so no user-facing string is duplicated in widgets.
extension FailureLocalization on Failure {
  String localize(AppLocalizations l10n) => switch (this) {
    ValidationFailure(:final validationCode) => validationCode.localize(l10n),
    NetworkFailure() => l10n.errorsNetwork,
    AuthFailure() => l10n.errorsUnauthorized,
    ServerFailure() => l10n.errorsServer,
    CacheFailure() => l10n.errorsCache,
    // Wildcard: also covers failures added by future features.
    Failure() => l10n.errorsUnexpected,
  };
}
