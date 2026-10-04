import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_legion_mobile/core/error/failures.dart';
import 'package:the_legion_mobile/core/error/validation.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/sign_in_attempts.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/user.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/register.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_state.dart';

class _MockLogin extends Mock implements LoginUseCase {}

class _MockLogout extends Mock implements LogoutUseCase {}

class _MockRegister extends Mock implements RegisterUseCase {}

class _MockRestoreSession extends Mock implements RestoreSessionUseCase {}

void main() {
  late _MockLogin login;
  late _MockLogout logout;
  late _MockRegister register;
  late _MockRestoreSession restoreSession;

  const user = User(id: '1', email: 'ada@example.com', displayName: 'Ada');

  setUpAll(() {
    registerFallbackValue(const User(id: '', email: '', displayName: ''));
  });

  setUp(() {
    login = _MockLogin();
    logout = _MockLogout();
    register = _MockRegister();
    restoreSession = _MockRestoreSession();

    when(() => logout.call()).thenAnswer((_) async {});
  });

  AuthCubit build() => AuthCubit(
    login: login,
    logout: logout,
    register: register,
    restoreSession: restoreSession,
  );

  group('bootstrap', () {
    blocTest<AuthCubit, AuthState>(
      'emits authenticated when a session was restored',
      setUp: () => when(restoreSession.call).thenAnswer((_) async => user),
      build: build,
      act: (cubit) => cubit.bootstrap(),
      expect: () => [
        const AuthState(status: AuthStatus.restoringSession),
        const AuthState.authenticated(user),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits unauthenticated when no session exists',
      setUp: () => when(restoreSession.call).thenAnswer((_) async => null),
      build: build,
      act: (cubit) => cubit.bootstrap(),
      expect: () => [
        const AuthState(status: AuthStatus.restoringSession),
        const AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'exposes the session to the router',
      setUp: () => when(restoreSession.call).thenAnswer((_) async => user),
      build: build,
      act: (cubit) async => cubit.bootstrap(),
      verify: (cubit) {
        expect(cubit.isSessionResolved, isTrue);
        expect(cubit.isAuthenticated, isTrue);
      },
    );
  });

  group('signIn', () {
    blocTest<AuthCubit, AuthState>(
      'emits authenticating then authenticated',
      setUp: () => when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => user),
      build: build,
      act: (cubit) =>
          cubit.signIn(email: 'ada@example.com', password: 'password123'),
      expect: () => [
        const AuthState(status: AuthStatus.authenticating),
        const AuthState.authenticated(user),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'surfaces a failure as unauthenticated with the failure',
      setUp: () => when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthFailure(message: 'bad credentials')),
      build: build,
      act: (cubit) =>
          cubit.signIn(email: 'ada@example.com', password: 'password123'),
      expect: () => [
        const AuthState(status: AuthStatus.authenticating),
        const AuthState.unauthenticated(
          failure: AuthFailure(message: 'bad credentials'),
          // Rejected credentials count towards the lockout.
          attempts: SignInAttempts(failedAttempts: 1),
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'converts unexpected errors into an unexpected failure',
      setUp: () => when(
        () => login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(StateError('boom')),
      build: build,
      act: (cubit) =>
          cubit.signIn(email: 'ada@example.com', password: 'password123'),
      verify: (cubit) => expect(cubit.state.failure, isA<UnexpectedFailure>()),
    );
  });

  group('register', () {
    Future<void> act(AuthCubit cubit) => cubit.register(
      firstName: 'Ada',
      surname: 'Lovelace',
      email: 'ada@example.com',
      password: 'legion123',
      confirmPassword: 'legion123',
    );

    void stubRegister(Object Function() answer) =>
        when(
          () => register(
            firstName: any(named: 'firstName'),
            surname: any(named: 'surname'),
            otherNames: any(named: 'otherNames'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
            password: any(named: 'password'),
            confirmPassword: any(named: 'confirmPassword'),
          ),
        ).thenAnswer((_) async {
          final result = answer();
          if (result is Failure) throw result;
          return result as User;
        });

    blocTest<AuthCubit, AuthState>(
      'emits registering then authenticated: a new applicant is signed in',
      setUp: () => stubRegister(() => user),
      build: build,
      act: act,
      expect: () => [
        const AuthState(status: AuthStatus.registering),
        const AuthState.authenticated(user),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'keeps a rejected form out of the sign-in limit',
      setUp: () => stubRegister(
        () => const ValidationFailure(
          field: ValidationField.email,
          validationCode: ValidationCode.emailAlreadyRegistered,
        ),
      ),
      build: build,
      seed: () => const AuthState.unauthenticated(
        attempts: SignInAttempts(failedAttempts: 2),
      ),
      act: act,
      expect: () => [
        const AuthState(
          status: AuthStatus.registering,
          attempts: SignInAttempts(failedAttempts: 2),
        ),
        const AuthState.unauthenticated(
          failure: ValidationFailure(
            field: ValidationField.email,
            validationCode: ValidationCode.emailAlreadyRegistered,
          ),
          // Unchanged: nobody guessed a password.
          attempts: SignInAttempts(failedAttempts: 2),
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'converts unexpected errors into an unexpected failure',
      setUp: () => stubRegister(() => throw StateError('boom')),
      build: build,
      act: act,
      verify: (cubit) => expect(cubit.state.failure, isA<UnexpectedFailure>()),
    );

    blocTest<AuthCubit, AuthState>(
      'does nothing while sign-in is locked',
      build: build,
      seed: () => const AuthState(
        status: AuthStatus.rateLimited,
        attempts: SignInAttempts(failedAttempts: 5),
      ),
      act: act,
      expect: () => const <AuthState>[],
      verify: (_) => verifyNever(
        () => register(
          firstName: any(named: 'firstName'),
          surname: any(named: 'surname'),
          otherNames: any(named: 'otherNames'),
          email: any(named: 'email'),
          phone: any(named: 'phone'),
          password: any(named: 'password'),
          confirmPassword: any(named: 'confirmPassword'),
        ),
      ),
    );
  });

  group('clearFailure', () {
    blocTest<AuthCubit, AuthState>(
      'drops the failure and nothing else',
      build: build,
      seed: () => const AuthState.unauthenticated(
        failure: AuthFailure(message: 'bad credentials'),
        attempts: SignInAttempts(failedAttempts: 1),
      ),
      act: (cubit) => cubit.clearFailure(),
      expect: () => [
        const AuthState.unauthenticated(
          attempts: SignInAttempts(failedAttempts: 1),
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits nothing when there is no failure to drop',
      build: build,
      seed: () => const AuthState.unauthenticated(),
      act: (cubit) => cubit.clearFailure(),
      expect: () => const <AuthState>[],
    );
  });

  group('signOut', () {
    blocTest<AuthCubit, AuthState>(
      'emits signingOut then unauthenticated',
      build: build,
      act: (cubit) => cubit.signOut(),
      expect: () => [
        const AuthState(status: AuthStatus.signingOut),
        const AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'reports a failure but still signs out',
      setUp: () =>
          when(() => logout.call())
              .thenThrow(const CacheFailure(message: 'disk full')),
      build: build,
      act: (cubit) => cubit.signOut(),
      verify: (cubit) {
        expect(cubit.state.status, AuthStatus.unauthenticated);
        expect(cubit.state.failure, isA<CacheFailure>());
      },
    );
  });
}
