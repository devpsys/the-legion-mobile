import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
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
}
