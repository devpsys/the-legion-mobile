import 'package:equatable/equatable.dart';

/// Step of the account-recovery flow.
enum RecoveryStep {
  /// Enter an email address or registration number.
  requestCode,

  /// Enter the 6-digit code sent to the verified channels.
  verifyCode,

  /// Choose and confirm a new password.
  setPassword,

  /// Audit summary of the completed recovery.
  completed,
}

/// What the flow is currently doing.
enum RecoveryStatus {
  idle,

  requestingCode,

  codeSent,

  verifyingCode,

  codeVerified,

  updatingPassword,

  completed,

  failed,
}

/// Immutable state of the recovery flow.
///
/// One cubit instance spans the whole flow, so navigating between steps keeps
/// the identifier, the masked destinations and the attempt counters.
class PasswordRecoveryState extends Equatable {
  const PasswordRecoveryState({
    this.step = RecoveryStep.requestCode,
    this.status = RecoveryStatus.idle,
    this.identifier = '',
    this.maskedEmail,
    this.maskedPhone,
    this.code = '',
    this.attemptedCodes = 0,
    this.resendAvailableIn = Duration.zero,
    this.codeExpiresIn = Duration.zero,
    this.codeLockedFor = Duration.zero,
    this.password = '',
    this.confirmPassword = '',
    this.terminateOtherSessions = true,
    this.errorMessage,
  });

  final RecoveryStep step;
  final RecoveryStatus status;

  /// Email or registration number entered in the first step.
  final String identifier;

  /// Masked destinations shown on the verification step.
  final String? maskedEmail;
  final String? maskedPhone;

  /// The 6-digit code currently entered.
  final String code;

  /// Wrong codes submitted so far; three locks the flow.
  final int attemptedCodes;

  final Duration resendAvailableIn;
  final Duration codeExpiresIn;

  /// Non-zero while a wrong-code lockout is running.
  final Duration codeLockedFor;

  final String password;
  final String confirmPassword;

  /// Whether other sessions are revoked with the new password.
  final bool terminateOtherSessions;

  /// Already-localized message for the current failure, if any.
  final String? errorMessage;

  bool get isBusy =>
      status == RecoveryStatus.requestingCode ||
      status == RecoveryStatus.verifyingCode ||
      status == RecoveryStatus.updatingPassword;

  /// `true` while a wrong-code lockout is running.
  bool get isCodeLocked => codeLockedFor > Duration.zero;

  bool get canResend => resendAvailableIn <= Duration.zero;

  /// `true` once the code is entered to full length.
  bool get isCodeComplete => code.length == RecoveryRules.codeLength;

  PasswordRecoveryState copyWith({
    RecoveryStep? step,
    RecoveryStatus? status,
    String? identifier,
    String? maskedEmail,
    String? maskedPhone,
    String? code,
    int? attemptedCodes,
    Duration? resendAvailableIn,
    Duration? codeExpiresIn,
    Duration? codeLockedFor,
    String? password,
    String? confirmPassword,
    bool? terminateOtherSessions,
    String? errorMessage,
    bool clearError = false,
    bool clearDestinations = false,
  }) {
    return PasswordRecoveryState(
      step: step ?? this.step,
      status: status ?? this.status,
      identifier: identifier ?? this.identifier,
      maskedEmail: clearDestinations ? null : (maskedEmail ?? this.maskedEmail),
      maskedPhone: clearDestinations ? null : (maskedPhone ?? this.maskedPhone),
      code: code ?? this.code,
      attemptedCodes: attemptedCodes ?? this.attemptedCodes,
      resendAvailableIn: resendAvailableIn ?? this.resendAvailableIn,
      codeExpiresIn: codeExpiresIn ?? this.codeExpiresIn,
      codeLockedFor: codeLockedFor ?? this.codeLockedFor,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      terminateOtherSessions:
          terminateOtherSessions ?? this.terminateOtherSessions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    step,
    status,
    identifier,
    maskedEmail,
    maskedPhone,
    code,
    attemptedCodes,
    resendAvailableIn,
    codeExpiresIn,
    codeLockedFor,
    password,
    confirmPassword,
    terminateOtherSessions,
    errorMessage,
  ];
}

/// Timing rules of the recovery flow.
///
/// Client-side for now; the API becomes the source of truth once it sends
/// real codes.
abstract final class RecoveryRules {
  /// Length of the one-time code.
  static const int codeLength = 6;

  /// Wrong codes allowed before the flow locks.
  static const int maxCodeAttempts = 3;

  /// How long a wrong-code lockout lasts.
  static const Duration codeLockout = Duration(minutes: 15);

  /// Validity of a dispatched code.
  static const Duration codeLifetime = Duration(minutes: 10);

  /// Wait before the code can be resent.
  static const Duration resendCooldown = Duration(minutes: 1);

  /// The code accepted while the backend is pending. Any other code fails.
  static const String demoCode = '123456';
}
