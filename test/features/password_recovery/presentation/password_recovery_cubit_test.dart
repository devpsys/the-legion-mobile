import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/bloc/password_recovery_cubit.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/bloc/password_recovery_state.dart';

void main() {
  late PasswordRecoveryCubit cubit;

  setUp(() => cubit = PasswordRecoveryCubit());
  tearDown(() => cubit.close());

  void requestCode(String identifier) {
    cubit
      ..identifierChanged(identifier)
      ..requestCode();
  }

  group('step 1 — request the code', () {
    test('starts on the request step with no identifier', () {
      expect(cubit.state.step, RecoveryStep.requestCode);
      expect(cubit.state.status, RecoveryStatus.idle);
    });

    test('does nothing without an identifier', () {
      cubit.requestCode();

      expect(cubit.state.step, RecoveryStep.requestCode);
      expect(cubit.state.maskedEmail, isNull);
    });

    test('advances to verification and masks the destinations', () {
      requestCode('amaka.bello@legion.edu.ng');

      expect(cubit.state.step, RecoveryStep.verifyCode);
      expect(cubit.state.status, RecoveryStatus.codeSent);
      expect(cubit.state.maskedEmail, 'a•••••o@legion.edu.ng');
      expect(cubit.state.maskedPhone, isNotNull);
    });

    test('masks a registration number', () {
      requestCode('23/CSC/0412');

      expect(cubit.state.maskedEmail, '•••••••••12');
    });

    test('starts the expiry and resend windows', () {
      requestCode('ada@example.com');

      expect(cubit.state.codeExpiresIn, RecoveryRules.codeLifetime);
      expect(cubit.state.resendAvailableIn, RecoveryRules.resendCooldown);
      expect(cubit.state.canResend, isFalse);
    });
  });

  group('step 2 — verify the code', () {
    setUp(() => requestCode('ada@example.com'));

    test('keeps digits only and caps the length', () {
      cubit.codeChanged('12 34-56-7890');

      // Separators are dropped and the value is capped at the code length.
      expect(cubit.state.code, '123456');
    });

    test('reports when the code is complete', () {
      cubit.codeChanged('123');
      expect(cubit.state.isCodeComplete, isFalse);

      cubit.codeChanged('123456');
      expect(cubit.state.isCodeComplete, isTrue);
    });

    test('accepts the demo code and advances', () {
      cubit
        ..codeChanged(RecoveryRules.demoCode)
        ..verifyCode();

      expect(cubit.state.step, RecoveryStep.setPassword);
      expect(cubit.state.status, RecoveryStatus.codeVerified);
    });

    test('counts a wrong code and stays on the step', () {
      cubit
        ..codeChanged('000000')
        ..verifyCode();

      expect(cubit.state.step, RecoveryStep.verifyCode);
      expect(cubit.state.status, RecoveryStatus.failed);
      expect(cubit.state.attemptedCodes, 1);
      expect(cubit.state.code, isEmpty, reason: 'the wrong code is cleared');
    });

    test('locks the flow after the allowed number of wrong codes', () {
      for (var i = 0; i < RecoveryRules.maxCodeAttempts; i++) {
        cubit
          ..codeChanged('000000')
          ..verifyCode();
      }

      expect(cubit.state.attemptedCodes, RecoveryRules.maxCodeAttempts);
      expect(cubit.state.isCodeLocked, isTrue);
      expect(cubit.state.codeLockedFor, RecoveryRules.codeLockout);
    });

    test('ignores verification while locked', () {
      for (var i = 0; i < RecoveryRules.maxCodeAttempts; i++) {
        cubit
          ..codeChanged('000000')
          ..verifyCode();
      }

      cubit
        ..codeChanged(RecoveryRules.demoCode)
        ..verifyCode();

      expect(cubit.state.step, RecoveryStep.verifyCode);
    });

    test('resend is ignored during the cooldown', () {
      final before = cubit.state.codeExpiresIn;
      cubit.resendCode();

      expect(cubit.state.codeExpiresIn, before, reason: 'window not restarted');
    });

    test('resend restarts the window once the cooldown has elapsed', () {
      // Simulate the cooldown elapsing.
      cubit.emit(
        cubit.state.copyWith(
          status: RecoveryStatus.codeSent,
          resendAvailableIn: Duration.zero,
          codeExpiresIn: RecoveryRules.codeLifetime,
        ),
      );
      final before = cubit.state.codeExpiresIn;

      cubit.resendCode();

      expect(cubit.state.codeExpiresIn, before, reason: 'window restarted');
      expect(cubit.state.resendAvailableIn, RecoveryRules.resendCooldown);
    });

    test('a different method returns to the request step', () {
      cubit.useDifferentMethod();

      expect(cubit.state.step, RecoveryStep.requestCode);
      expect(cubit.state.maskedEmail, isNull);
      expect(cubit.state.codeLockedFor, Duration.zero);
    });
  });

  group('step 3 — set the new password', () {
    setUp(() {
      requestCode('ada@example.com');
      cubit
        ..codeChanged(RecoveryRules.demoCode)
        ..verifyCode();
    });

    test('evaluates the policy as the user types', () {
      cubit.passwordChanged('abc');

      final requirements = cubit.evaluatePassword(cubit.state.password);
      expect(requirements.every((requirement) => !requirement.isMet), isTrue);
    });

    test('rejects a password that misses a rule', () {
      cubit
        ..passwordChanged('short1!')
        ..confirmPasswordChanged('short1!')
        ..updatePassword();

      expect(cubit.state.step, RecoveryStep.setPassword);
      expect(
        cubit.state.errorMessage,
        RecoveryValidationError.policyNotMet.key,
      );
    });

    test('rejects mismatched passwords', () {
      cubit
        ..passwordChanged('Legion2024!')
        ..confirmPasswordChanged('Legion2024?')
        ..updatePassword();

      expect(cubit.state.errorMessage, RecoveryValidationError.mismatch.key);
      expect(cubit.state.step, RecoveryStep.setPassword);
    });

    test('completes with a compliant, matching password', () {
      cubit
        ..passwordChanged('Legion2024!')
        ..confirmPasswordChanged('Legion2024!')
        ..updatePassword();

      expect(cubit.state.step, RecoveryStep.completed);
      expect(cubit.state.status, RecoveryStatus.completed);
    });

    test('records the terminate-sessions choice', () {
      cubit.terminateOtherSessionsChanged(false);

      expect(cubit.state.terminateOtherSessions, isFalse);
    });
  });

  group('timers', () {
    test('the code expiry and resend cooldown count down', () async {
      requestCode('ada@example.com');
      final expiry = cubit.state.codeExpiresIn;

      await Future<void>.delayed(const Duration(milliseconds: 1150));

      expect(
        cubit.state.codeExpiresIn,
        lessThan(expiry),
        reason: 'expiry ticks down while the step is open',
      );
    }, timeout: const Timeout(Duration(seconds: 20)));
  });

  group('reset', () {
    test('returns the flow to its initial state', () {
      requestCode('ada@example.com');
      cubit.reset();

      expect(cubit.state, const PasswordRecoveryState());
    });
  });

  group('masking', () {
    test('maskEmail keeps the domain and the outer characters', () {
      expect(
        PasswordRecoveryCubit.maskEmail('amaka.bello@legion.edu.ng'),
        'a•••••o@legion.edu.ng',
      );
    });

    test('maskEmail handles a short local part', () {
      expect(PasswordRecoveryCubit.maskEmail('ab@x.com'), 'a•@x.com');
    });

    test('maskTail keeps the trailing characters', () {
      expect(PasswordRecoveryCubit.maskTail('23/CSC/0412'), '•••••••••12');
    });
  });
}
