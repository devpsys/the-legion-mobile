import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/error/exceptions.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/models/auth_tokens_model.dart';

void main() {
  // `latency: Duration.zero` — these tests exercise behaviour, not timing.
  FakeAuthRemoteDataSource buildRemote({
    Set<String> rejectedEmails = const {},
    String acceptedPassword = FakeAuthRemoteDataSource.defaultPassword,
  }) {
    return FakeAuthRemoteDataSource(
      latency: Duration.zero,
      rejectedEmails: rejectedEmails,
      acceptedPassword: acceptedPassword,
    );
  }

  Future<({dynamic user, AuthTokensModel tokens})> signIn(
    FakeAuthRemoteDataSource remote, {
    String email = 'ada@the-legion.dev',
  }) async {
    final response = await remote.login(
      email: email,
      password: FakeAuthRemoteDataSource.defaultPassword,
    );
    return (user: response.user, tokens: response.tokens);
  }

  group('FakeAuthRemoteDataSource', () {
    test('returns a user and fresh tokens for the demo password', () async {
      final response = await buildRemote().login(
        email: 'ada@the-legion.dev',
        password: FakeAuthRemoteDataSource.defaultPassword,
      );

      expect(response.user.email, 'ada@the-legion.dev');
      expect(
        response.user.displayName,
        FakeAuthRemoteDataSource.defaultDisplayName,
      );
      expect(response.tokens.accessToken, isNotEmpty);
      expect(response.tokens.isExpired, isFalse);
    });

    test('issues tokens that outlive the session lifetime', () async {
      final response = await buildRemote().login(
        email: 'ada@the-legion.dev',
        password: FakeAuthRemoteDataSource.defaultPassword,
      );

      expect(
        response.tokens.expiresAt.isAfter(
          DateTime.now().add(
            FakeAuthRemoteDataSource.sessionLifetime -
                const Duration(minutes: 1),
          ),
        ),
        isTrue,
      );
    });

    test('rejects a wrong password with an unauthorized exception', () async {
      await expectLater(
        () => buildRemote().login(
          email: 'ada@the-legion.dev',
          password: 'wrong-password',
        ),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test(
      'rejects addresses listed in rejectedEmails, case-insensitively',
      () async {
        final remote = buildRemote(
          rejectedEmails: const {'blocked@the-legion.dev'},
        );

        await expectLater(
          () => remote.login(
            email: 'Blocked@The-Legion.dev',
            password: FakeAuthRemoteDataSource.defaultPassword,
          ),
          throwsA(isA<UnauthorizedException>()),
        );
      },
    );
  });

  group('InMemoryAuthLocalDataSource', () {
    late InMemoryAuthLocalDataSource local;

    setUp(() => local = InMemoryAuthLocalDataSource());

    test('starts empty', () async {
      expect(await local.readCachedUser(), isNull);
      expect(await local.readTokens(), isNull);
      expect(await local.accessToken(), isNull);
    });

    test('stores the session and exposes the access token', () async {
      final session = await signIn(buildRemote());

      await local.cacheUser(session.user);
      await local.saveTokens(session.tokens);

      expect(await local.readCachedUser(), session.user);
      expect(await local.accessToken(), session.tokens.accessToken);
      expect(local.cachedUser, session.user);
    });

    test('clear() removes the session', () async {
      final session = await signIn(buildRemote());
      await local.cacheUser(session.user);
      await local.saveTokens(session.tokens);

      await local.clear();

      expect(local.cachedUser, isNull);
      expect(await local.readTokens(), isNull);
      expect(await local.accessToken(), isNull);
    });

    test('ignores an expired token', () async {
      await local.saveTokens(
        AuthTokensModel(
          accessToken: 'stale',
          refreshToken: 'stale',
          expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
      );

      expect(await local.accessToken(), isNull);
    });

    test('onUnauthorized() clears the session like a 401 would', () async {
      final session = await signIn(buildRemote());
      await local.cacheUser(session.user);
      await local.saveTokens(session.tokens);

      await local.onUnauthorized();

      expect(local.cachedUser, isNull);
      expect(await local.readTokens(), isNull);
    });
  });
}
