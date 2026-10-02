import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_legion_mobile/core/error/failures.dart';
import 'package:the_legion_mobile/core/error/validation.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/sign_in_attempts.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/user.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_state.dart';

class _MockLogin extends Mock implements LoginUseCase {}

class _MockLogout extends Mock implements LogoutUseCase {}

class _MockRestoreSession extends Mock implements RestoreSessionUseCase {}

/// Clock anchored to a fixed instant that advances with real time, plus an
/// offset the test can jump forward.
class _FakeClock {
  _FakeClock()
    : _base = DateTime.utc(2026, 1, 1, 9),
      _realBase = DateTime.now();

  final DateTime _base;
  final DateTime _realBase;
  Duration _offset = Duration.zero;

  DateTime call() => _base.add(DateTime.now().difference(_realBase) + _offset);

  void advance(Duration duration) => _offset += duration;
}

void main() {
  late _MockLogin login;
  late _MockLogout logout;
  late _MockRestoreSession restoreSession;
  late _FakeClock clock;

  const user = User(id: '1', email: 'ada@the-legion.dev', displayName: 'Ada');

  setUpAll(() {
    registerFallbackValue(const User(id: '', email: '', displayName: ''));
  });

  setUp(() {
    login = _MockLogin();
    logout = _MockLogout();
    restoreSession = _MockRestoreSession();
    clock = _FakeClock();

    when(() => logout.call()).thenAnswer((_) async {});
  });

  AuthCubit build({Duration cooldown = const Duration(seconds: 2)}) =>
      AuthCubit(
        login: login,
        logout: logout,
        restoreSession: restoreSession,
        now: clock.call,
        cooldown: cooldown,
      );

  void rejectCredentials() {
    when(
      () => login(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenThrow(const AuthFailure(message: 'bad credentials'));
  }

  Future<void> attempt(AuthCubit cubit) =>
      cubit.signIn(email: 'ada@the-legion.dev', password: 'legion123');

  group('rate limiting', () {
    test('locks sign-in after five rejected credentials', () async {
      rejectCredentials();
      final cubit = build();
      addTearDown(cubit.close);

      for (var i = 0; i < 4; i++) {
        await attempt(cubit);
        expect(cubit.state.isRateLimited, isFalse);
        expect(cubit.state.attempts.failedAttempts, i + 1);
      }

      await attempt(cubit);

      expect(cubit.state.isRateLimited, isTrue);
      expect(cubit.state.attempts.failedAttempts, 5);
      expect(cubit.state.cooldownRemaining, const Duration(seconds: 2));
      expect(cubit.state.failure, isA<AuthFailure>());
    });

    test('ignores further attempts while locked', () async {
      rejectCredentials();
      final cubit = build();
      addTearDown(cubit.close);

      for (var i = 0; i < 5; i++) {
        await attempt(cubit);
      }
      expect(cubit.state.isRateLimited, isTrue);
      verify(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).called(5);

      // The sixth attempt is dropped before it reaches the use case.
      await attempt(cubit);

      verifyNever(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
      expect(cubit.state.isRateLimited, isTrue);
    });

    test('unlocks and restores the allowance after the cooldown', () async {
      rejectCredentials();
      final cubit = build(cooldown: const Duration(seconds: 1));
      addTearDown(cubit.close);

      for (var i = 0; i < 5; i++) {
        await attempt(cubit);
      }
      expect(cubit.state.isRateLimited, isTrue);

      // Jump past the window, then let one ticker tick observe it.
      clock.advance(const Duration(seconds: 2));
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      expect(cubit.state.isRateLimited, isFalse);
      expect(cubit.state.attempts.failedAttempts, 0);
      expect(cubit.state.cooldownRemaining, Duration.zero);
    }, timeout: const Timeout(Duration(seconds: 20)));

    test('a successful sign-in clears the streak', () async {
      rejectCredentials();
      final cubit = build();
      addTearDown(cubit.close);

      await attempt(cubit);
      await attempt(cubit);
      expect(cubit.state.attempts.failedAttempts, 2);

      when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => user);
      await attempt(cubit);

      expect(cubit.state.isAuthenticated, isTrue);
      expect(cubit.state.attempts.failedAttempts, 0);
    });

    test('validation failures do not count towards the lockout', () async {
      when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(
        const ValidationFailure(
          field: ValidationField.password,
          validationCode: ValidationCode.passwordTooShort,
        ),
      );
      final cubit = build();
      addTearDown(cubit.close);

      for (var i = 0; i < 6; i++) {
        await attempt(cubit);
      }

      expect(cubit.state.isRateLimited, isFalse);
      expect(cubit.state.attempts.failedAttempts, 0);
    });

    test('network failures do not count towards the lockout', () async {
      when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const NetworkFailure(message: 'offline'));
      final cubit = build();
      addTearDown(cubit.close);

      for (var i = 0; i < 6; i++) {
        await attempt(cubit);
      }

      expect(cubit.state.isRateLimited, isFalse);
      expect(cubit.state.attempts.failedAttempts, 0);
    });
  });

  group('cooldown progress', () {
    test('reports the fraction of the window still to elapse', () {
      final half = SignInAttempts.cooldown ~/ 2;
      final state = AuthState(
        status: AuthStatus.rateLimited,
        cooldownRemaining: half,
      );

      // Half of the five-minute window remains.
      expect(state.cooldownProgress, closeTo(0.5, 0.001));
    });

    test('is full at the start of the window', () {
      final state = AuthState(
        status: AuthStatus.rateLimited,
        cooldownRemaining: SignInAttempts.cooldown,
      );

      expect(state.cooldownProgress, closeTo(1.0, 0.001));
    });

    test('clamps to the valid range', () {
      const elapsed = AuthState(
        status: AuthStatus.unauthenticated,
        cooldownRemaining: Duration(hours: 1),
      );

      expect(elapsed.cooldownProgress, 1.0);
    });
  });
}
