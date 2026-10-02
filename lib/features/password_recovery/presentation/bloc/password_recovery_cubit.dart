import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/password_policy.dart';
import '../mock/password_recovery_fixtures.dart';
import 'password_recovery_state.dart';

/// Drives the four-step account-recovery flow.
///
/// Presentation only — the steps, timers and validation live here, and the
/// fake code is a constant in [RecoveryRules] until the API dispatches real
/// ones. Deliberately has no repository/use case: nothing to fetch yet.
class PasswordRecoveryCubit extends Cubit<PasswordRecoveryState> {
  PasswordRecoveryCubit({PasswordPolicy policy = const PasswordPolicy()})
    : _policy = policy,
      super(const PasswordRecoveryState());

  final PasswordPolicy _policy;

  Timer? _ticker;

  /// The policy the password step is measured against.
  PasswordPolicy get policy => _policy;

  // --- Step 1: request the code ------------------------------------------

  void identifierChanged(String value) {
    emit(state.copyWith(identifier: value, clearError: true));
  }

  /// Requests a recovery code and moves to the verification step.
  void requestCode() {
    final identifier = state.identifier.trim();
    if (identifier.isEmpty) return;

    emit(
      state.copyWith(status: RecoveryStatus.requestingCode, clearError: true),
    );
    // Simulated round trip; the API will answer here.
    emit(
      state.copyWith(
        step: RecoveryStep.verifyCode,
        status: RecoveryStatus.codeSent,
        maskedEmail: maskEmail(identifier),
        maskedPhone: RecoveryFixtures.demoMaskedPhone,
        code: '',
        attemptedCodes: 0,
        codeExpiresIn: RecoveryRules.codeLifetime,
        resendAvailableIn: RecoveryRules.resendCooldown,
        clearError: true,
      ),
    );
    _startTicker();
  }

  /// Restarts the dispatch window and cooldown.
  void resendCode() {
    if (!state.canResend || state.isBusy) return;

    emit(
      state.copyWith(
        status: RecoveryStatus.codeSent,
        codeExpiresIn: RecoveryRules.codeLifetime,
        resendAvailableIn: RecoveryRules.resendCooldown,
        clearError: true,
      ),
    );
    _ensureTicker();
  }

  // --- Step 2: verify the code ------------------------------------------

  void codeChanged(String code) {
    final digits = _digitsOnly(code);
    emit(
      state.copyWith(
        code: digits.length > RecoveryRules.codeLength
            ? digits.substring(0, RecoveryRules.codeLength)
            : digits,
        clearError: true,
      ),
    );
  }

  /// Verifies the entered code, advancing to the password step on success.
  void verifyCode() {
    if (state.isBusy || state.isCodeLocked) return;

    emit(
      state.copyWith(status: RecoveryStatus.verifyingCode, clearError: true),
    );

    if (state.code != RecoveryRules.demoCode) {
      _registerWrongCode();
      return;
    }

    emit(
      state.copyWith(
        step: RecoveryStep.setPassword,
        status: RecoveryStatus.codeVerified,
        clearError: true,
      ),
    );
  }

  void _registerWrongCode() {
    final attempts = state.attemptedCodes + 1;
    final remaining = RecoveryRules.maxCodeAttempts - attempts;

    if (remaining <= 0) {
      emit(
        state.copyWith(
          status: RecoveryStatus.failed,
          attemptedCodes: attempts,
          codeLockedFor: RecoveryRules.codeLockout,
          errorMessage: null,
        ),
      );
      _ensureTicker();
      return;
    }

    emit(
      state.copyWith(
        status: RecoveryStatus.failed,
        attemptedCodes: attempts,
        code: '',
        errorMessage: null,
      ),
    );
  }

  // --- Step 3: set the new password -------------------------------------

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, clearError: true));
  }

  void confirmPasswordChanged(String value) {
    emit(state.copyWith(confirmPassword: value, clearError: true));
  }

  void terminateOtherSessionsChanged(bool value) {
    emit(state.copyWith(terminateOtherSessions: value));
  }

  /// Live policy evaluation for the strength meter and checklist.
  List<PasswordRequirement> evaluatePassword(String value) =>
      _policy.evaluate(value);

  /// Validates the password step. Returns the failure key, or `null` if valid.
  RecoveryValidationError? validatePassword() {
    if (!_policy.isCompliant(state.password)) {
      return RecoveryValidationError.policyNotMet;
    }
    if (state.password != state.confirmPassword) {
      return RecoveryValidationError.mismatch;
    }
    return null;
  }

  /// Completes the recovery and moves to the audit summary.
  void updatePassword() {
    if (state.isBusy) return;

    final error = validatePassword();
    if (error != null) {
      emit(
        state.copyWith(status: RecoveryStatus.failed, errorMessage: error.key),
      );
      return;
    }

    emit(
      state.copyWith(status: RecoveryStatus.updatingPassword, clearError: true),
    );
    emit(
      state.copyWith(
        step: RecoveryStep.completed,
        status: RecoveryStatus.completed,
        clearError: true,
      ),
    );
    _cancelTicker();
  }

  /// Returns to the verification step to correct the identifier.
  void useDifferentMethod() {
    emit(
      state.copyWith(
        step: RecoveryStep.requestCode,
        status: RecoveryStatus.idle,
        clearDestinations: true,
        code: '',
        codeLockedFor: Duration.zero,
        clearError: true,
      ),
    );
    _cancelTicker();
  }

  /// Restarts the flow for a fresh attempt.
  void reset() {
    _cancelTicker();
    emit(const PasswordRecoveryState());
  }

  // --- Timers ------------------------------------------------------------

  /// Ticks the expiry, resend cooldown and lockout countdowns together.
  void _startTicker() {
    _cancelTicker();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _ensureTicker() {
    if (_ticker == null) _startTicker();
  }

  void _tick() {
    if (state.codeExpiresIn <= Duration.zero &&
        state.resendAvailableIn <= Duration.zero &&
        state.codeLockedFor <= Duration.zero) {
      _cancelTicker();
      return;
    }

    // Lockout elapsed: hand the user a fresh set of attempts.
    if (state.isCodeLocked &&
        _nextSecond(state.codeLockedFor) == Duration.zero) {
      emit(
        state.copyWith(
          status: RecoveryStatus.codeSent,
          attemptedCodes: 0,
          codeLockedFor: Duration.zero,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        codeExpiresIn: _nextSecond(state.codeExpiresIn),
        resendAvailableIn: _nextSecond(state.resendAvailableIn),
        codeLockedFor: _nextSecond(state.codeLockedFor),
      ),
    );
  }

  static Duration _nextSecond(Duration value) {
    if (value <= Duration.zero) return Duration.zero;
    final remaining = value - const Duration(seconds: 1);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  void _cancelTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  Future<void> close() {
    _cancelTicker();
    return super.close();
  }

  /// `a•••••o@legion.edu.ng` — enough to recognise, never enough to leak.
  static String maskEmail(String identifier) {
    // Registration numbers and phone numbers are not addresses.
    if (!identifier.contains('@')) return maskTail(identifier);

    final parts = identifier.split('@');
    final local = parts.first;
    if (local.length <= 2) return '${local[0]}•@${parts.last}';
    return '${local[0]}${_mask(List.filled(5, '•'))}${local[local.length - 1]}@${parts.last}';
  }

  /// Registration number or phone: keep only the trailing characters.
  static String maskTail(String value, {int visible = 2}) {
    if (value.length <= visible) return _mask(List.filled(value.length, '•'));
    return '${_mask(List.filled(value.length - visible, '•'))}${value.substring(value.length - visible)}';
  }

  /// Keeps digits only, so a pasted code with spaces still works.
  static String _digitsOnly(String value) => value
      .split('')
      .where((c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57)
      .join();

  static String _mask(List<String> characters) => characters.join();
}

/// Why the password step was rejected. The UI maps these to localized copy.
enum RecoveryValidationError {
  policyNotMet('policyNotMet'),
  mismatch('passwordMismatch');

  const RecoveryValidationError(this.key);

  /// Stable key for the presentation layer to localize.
  final String key;
}
