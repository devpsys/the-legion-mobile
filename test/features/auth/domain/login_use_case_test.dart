import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_legion_mobile/core/error/failures.dart';
import 'package:the_legion_mobile/core/error/validation.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/user.dart';
import 'package:the_legion_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late LoginUseCase login;

  const user = User(
    id: '1',
    email: 'ada@example.com',
    displayName: 'Ada Lovelace',
  );

  setUp(() {
    repository = _MockAuthRepository();
    login = LoginUseCase(repository);
  });

  group('validation', () {
    test('rejects a blank email', () async {
      await expectLater(
        () => login(email: '  ', password: 'password123'),
        throwsA(
          isA<ValidationFailure>()
              .having((f) => f.field, 'field', ValidationField.email)
              .having((f) => f.validationCode, 'code', ValidationCode.required),
        ),
      );
      verifyNever(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    test('rejects a malformed email', () async {
      await expectLater(
        () => login(email: 'not-an-email', password: 'password123'),
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.validationCode,
            'code',
            ValidationCode.invalidEmail,
          ),
        ),
      );
    });

    test('rejects a blank password', () async {
      await expectLater(
        () => login(email: 'ada@example.com', password: ''),
        throwsA(
          isA<ValidationFailure>()
              .having((f) => f.field, 'field', ValidationField.password)
              .having((f) => f.validationCode, 'code', ValidationCode.required),
        ),
      );
    });

    test('rejects a short password', () async {
      await expectLater(
        () => login(email: 'ada@example.com', password: 'short'),
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.validationCode,
            'code',
            ValidationCode.passwordTooShort,
          ),
        ),
      );
    });
  });

  group('happy path', () {
    test('trims the email and delegates to the repository', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => user);

      final result = await login(
        email: ' ada@example.com ',
        password: 'password123',
      );

      expect(result, user);
      verify(
        () =>
            repository.login(email: 'ada@example.com', password: 'password123'),
      ).called(1);
    });

    test('propagates repository failures', () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const AuthFailure(message: 'nope'));

      await expectLater(
        () => login(email: 'ada@example.com', password: 'password123'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });
}
