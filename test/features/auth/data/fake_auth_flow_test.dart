import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/error/failures.dart';
import 'package:the_legion_mobile/core/error/validation.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/register.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_state.dart';

/// End-to-end check of the "no API yet" path:
/// cubit → use cases → repository → in-memory datasources.
void main() {
  late InMemoryAuthLocalDataSource local;
  late AuthCubit cubit;

  setUp(() {
    local = InMemoryAuthLocalDataSource();
    final repository = AuthRepositoryImpl(
      remote: FakeAuthRemoteDataSource(latency: Duration.zero),
      local: local,
    );
    cubit = AuthCubit(
      login: LoginUseCase(repository),
      logout: LogoutUseCase(repository),
      register: RegisterUseCase(repository),
      restoreSession: RestoreSessionUseCase(repository),
    );
  });

  tearDown(() => cubit.close());

  const email = 'ada@the-legion.dev';
  const password = FakeAuthRemoteDataSource.defaultPassword;

  test(
    'signs in with the fake backend and exposes the session to the router',
    () async {
      await cubit.signIn(email: email, password: password);

      expect(cubit.state.isAuthenticated, isTrue);
      expect(cubit.state.user?.email, email);
      // What `core/router` reads for authentication-aware redirects.
      expect(cubit.isSessionResolved, isTrue);
      expect(cubit.isAuthenticated, isTrue);
      expect(local.cachedUser, isNotNull);
    },
  );

  test('restores the in-memory session on a warm start', () async {
    await cubit.signIn(email: email, password: password);
    expect(cubit.state.isAuthenticated, isTrue);

    // A second cubit over the same in-memory store models a warm start.
    final repository = AuthRepositoryImpl(
      remote: FakeAuthRemoteDataSource(latency: Duration.zero),
      local: local,
    );
    final restarted = AuthCubit(
      login: LoginUseCase(repository),
      logout: LogoutUseCase(repository),
      register: RegisterUseCase(repository),
      restoreSession: RestoreSessionUseCase(repository),
    );
    addTearDown(restarted.close);

    await restarted.bootstrap();

    expect(restarted.state.isAuthenticated, isTrue);
    expect(restarted.state.user?.email, email);
  });

  test('sign out clears the in-memory session', () async {
    await cubit.signIn(email: email, password: password);
    expect(cubit.state.isAuthenticated, isTrue);

    await cubit.signOut();

    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(local.cachedUser, isNull);
    expect(await local.readTokens(), isNull);
  });

  test('a wrong password surfaces an auth failure', () async {
    await cubit.signIn(email: email, password: 'not-the-password');

    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.failure, isNotNull);
  });

  group('registration', () {
    Future<void> register({String email = 'seun@example.com'}) =>
        cubit.register(
          firstName: 'Oluwaseun',
          surname: 'Adeyemi',
          email: email,
          phone: '+234 803 123 4567',
          password: 'legion123',
          confirmPassword: 'legion123',
        );

    test('opens an account and signs the applicant straight in', () async {
      await register();

      expect(cubit.state.isAuthenticated, isTrue);
      expect(cubit.state.user?.email, 'seun@example.com');
      expect(cubit.state.user?.displayName, 'Oluwaseun Adeyemi');
      expect(
        cubit.state.user?.avatarUrl,
        isNull,
        reason: 'a new applicant has no portrait; the avatar shows initials',
      );
      expect(cubit.state.user?.initials, 'OA');
      // The session is persisted like a sign-in, so a warm start restores it.
      expect(local.cachedUser?.email, 'seun@example.com');
      expect(await local.readTokens(), isNotNull);
    });

    test('rejects an address that already has an account', () async {
      // The demo student's own address is on the register.
      await register(email: email);

      expect(cubit.state.status, AuthStatus.unauthenticated);
      expect(
        cubit.state.failure,
        isA<ValidationFailure>()
            .having((f) => f.field, 'field', ValidationField.email)
            .having(
              (f) => f.validationCode,
              'code',
              ValidationCode.emailAlreadyRegistered,
            ),
      );
      expect(local.cachedUser, isNull);
    });

    test('remembers the accounts it has opened', () async {
      await register();
      await cubit.signOut();

      await register(email: 'SEUN@example.com');

      expect(
        cubit.state.failure,
        isA<ValidationFailure>().having(
          (f) => f.validationCode,
          'code',
          ValidationCode.emailAlreadyRegistered,
        ),
        reason: 'the register is case-insensitive, like email itself',
      );
    });

    test('a rejected form leaves the sign-in allowance untouched', () async {
      await cubit.signIn(email: email, password: 'not-the-password');
      expect(cubit.state.attempts.failedAttempts, 1);

      await register(email: email);

      expect(cubit.state.attempts.failedAttempts, 1);
    });
  });
}
