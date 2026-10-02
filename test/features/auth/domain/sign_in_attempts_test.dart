import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/sign_in_attempts.dart';

void main() {
  final start = DateTime.utc(2026, 1, 1, 9);

  group('SignInAttempts', () {
    test('starts with a full allowance', () {
      const attempts = SignInAttempts();

      expect(attempts.failedAttempts, 0);
      expect(attempts.remainingAttempts, SignInAttempts.maxAttempts);
      expect(attempts.isLockedAt(start), isFalse);
      expect(attempts.remainingCooldownAt(start), Duration.zero);
    });

    test('counts failures without locking until the fifth', () {
      var attempts = const SignInAttempts();

      for (var i = 1; i < SignInAttempts.maxAttempts; i++) {
        attempts = attempts.registerFailure(start);
        expect(attempts.failedAttempts, i);
        expect(attempts.isLockedAt(start), isFalse);
        expect(attempts.remainingAttempts, SignInAttempts.maxAttempts - i);
      }
    });

    test('locks on the fifth wrong attempt', () {
      var attempts = const SignInAttempts();
      for (var i = 0; i < SignInAttempts.maxAttempts; i++) {
        attempts = attempts.registerFailure(start);
      }

      expect(attempts.failedAttempts, SignInAttempts.maxAttempts);
      expect(attempts.isLockedAt(start), isTrue);
      expect(attempts.remainingAttempts, 0);
      expect(attempts.remainingCooldownAt(start), SignInAttempts.cooldown);
    });

    test('cooldown counts down and expires', () {
      var attempts = const SignInAttempts();
      for (var i = 0; i < SignInAttempts.maxAttempts; i++) {
        attempts = attempts.registerFailure(start);
      }

      final halfway = start.add(SignInAttempts.cooldown ~/ 2);
      expect(attempts.isLockedAt(halfway), isTrue);
      expect(
        attempts.remainingCooldownAt(halfway),
        SignInAttempts.cooldown - SignInAttempts.cooldown ~/ 2,
      );

      final after = start.add(SignInAttempts.cooldown);
      expect(attempts.isLockedAt(after), isFalse);
      expect(attempts.remainingCooldownAt(after), Duration.zero);
    });

    test('further failures while locked keep the original window', () {
      var attempts = const SignInAttempts();
      for (var i = 0; i < SignInAttempts.maxAttempts; i++) {
        attempts = attempts.registerFailure(start);
      }

      final later = start.add(const Duration(seconds: 5));
      final again = attempts.registerFailure(later);

      expect(again.lockedUntil, attempts.lockedUntil);
      expect(again.isLockedAt(later), isTrue);
    });

    test('cleared restores the full allowance', () {
      var attempts = const SignInAttempts();
      for (var i = 0; i < SignInAttempts.maxAttempts; i++) {
        attempts = attempts.registerFailure(start);
      }

      final cleared = attempts.cleared;

      expect(cleared.failedAttempts, 0);
      expect(cleared.lockedUntil, isNull);
      expect(cleared.isLockedAt(start), isFalse);
      expect(cleared.remainingAttempts, SignInAttempts.maxAttempts);
    });

    test('the limit is five attempts', () {
      expect(SignInAttempts.maxAttempts, 5);
    });
  });
}
