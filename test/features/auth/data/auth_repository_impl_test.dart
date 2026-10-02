import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_legion_mobile/core/error/exceptions.dart';
import 'package:the_legion_mobile/core/error/failures.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/models/auth_tokens_model.dart';
import 'package:the_legion_mobile/features/auth/data/models/login_response_model.dart';
import 'package:the_legion_mobile/features/auth/data/models/user_model.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockLocal extends Mock implements AuthLocalDataSource {}

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late AuthRepositoryImpl repository;

  const user = UserModel(id: '1', email: 'ada@example.com', displayName: 'Ada');
  final tokens = AuthTokensModel(
    accessToken: 'access',
    refreshToken: 'refresh',
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
  );

  setUpAll(() {
    registerFallbackValue(user);
    registerFallbackValue(tokens);
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = AuthRepositoryImpl(remote: remote, local: local);

    when(() => local.saveTokens(any())).thenAnswer((_) async {});
    when(() => local.cacheUser(any())).thenAnswer((_) async {});
    when(() => local.clear()).thenAnswer((_) async {});
  });

  group('login', () {
    test('persists the session and returns the user', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => LoginResponseModel(user: user, tokens: tokens));

      final result = await repository.login(
        email: 'ada@example.com',
        password: 'password123',
      );

      expect(result, user);
      verify(() => local.saveTokens(tokens)).called(1);
      verify(() => local.cacheUser(user)).called(1);
    });

    test('converts remote exceptions into failures', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const UnauthorizedException('bad credentials'));

      await expectLater(
        () =>
            repository.login(email: 'ada@example.com', password: 'password123'),
        throwsA(isA<AuthFailure>()),
      );
      verifyNever(() => local.saveTokens(any()));
    });

    test('converts unexpected errors into failures', () async {
      when(
        () => remote.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(StateError('boom'));

      await expectLater(
        () =>
            repository.login(email: 'ada@example.com', password: 'password123'),
        throwsA(isA<UnexpectedFailure>()),
      );
    });
  });

  group('restoreSession', () {
    test('returns the cached user when the token is valid', () async {
      when(local.readTokens).thenAnswer((_) async => tokens);
      when(local.readCachedUser).thenAnswer((_) async => user);

      expect(await repository.restoreSession(), user);
      verifyNever(() => local.clear());
    });

    test('clears the session when there are no tokens', () async {
      when(local.readTokens).thenAnswer((_) async => null);

      expect(await repository.restoreSession(), isNull);
      verify(() => local.clear()).called(1);
    });

    test('clears the session when the token expired', () async {
      final expired = AuthTokensModel(
        accessToken: 'access',
        refreshToken: 'refresh',
        expiresAt: DateTime.now().subtract(const Duration(minutes: 1)),
      );
      when(local.readTokens).thenAnswer((_) async => expired);

      expect(await repository.restoreSession(), isNull);
      verify(() => local.clear()).called(1);
    });
  });

  group('logout', () {
    test('clears local state', () async {
      await repository.logout();

      verify(() => local.clear()).called(1);
    });

    test('surfaces cache errors as failures', () async {
      when(() => local.clear()).thenThrow(const CacheException('disk full'));

      await expectLater(repository.logout, throwsA(isA<CacheFailure>()));
    });
  });
}
