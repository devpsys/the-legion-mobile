import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_legion_mobile/core/error/failures.dart';
import 'package:the_legion_mobile/core/error/validation.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/registration.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/user.dart';
import 'package:the_legion_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/register.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repository;
  late RegisterUseCase useCase;

  const user = User(
    id: 'usr_applicant_1',
    email: 'seun@example.com',
    displayName: 'Oluwaseun Adeyemi',
  );

  setUpAll(() {
    registerFallbackValue(
      const Registration(firstName: '', surname: '', email: '', password: ''),
    );
  });

  setUp(() {
    repository = _MockAuthRepository();
    useCase = RegisterUseCase(repository);
    when(() => repository.register(any())).thenAnswer((_) async => user);
  });

  /// The use case with a complete, valid form, one field overridden.
  Future<User> call({
    String firstName = 'Oluwaseun',
    String surname = 'Adeyemi',
    String otherNames = '',
    String email = 'seun@example.com',
    String phone = '',
    String password = 'legion123',
    String? confirmPassword,
  }) => useCase(
    firstName: firstName,
    surname: surname,
    otherNames: otherNames,
    email: email,
    phone: phone,
    password: password,
    confirmPassword: confirmPassword ?? password,
  );

  /// Asserts the call is rejected on [field] with [code] before reaching the
  /// repository.
  Future<void> expectRejected(
    Future<User> Function() action,
    ValidationField field,
    ValidationCode code,
  ) async {
    await expectLater(
      action,
      throwsA(
        isA<ValidationFailure>()
            .having((f) => f.field, 'field', field)
            .having((f) => f.validationCode, 'code', code),
      ),
    );
    verifyNever(() => repository.register(any()));
  }

  group('RegisterUseCase', () {
    test('hands a trimmed registration to the repository', () async {
      final result = await call(
        firstName: '  Oluwaseun ',
        surname: ' Adeyemi',
        otherNames: ' Michael ',
        email: ' seun@example.com ',
        phone: ' +234 803 123 4567 ',
      );

      expect(result, user);
      final registration =
          verify(() => repository.register(captureAny())).captured.single
              as Registration;
      expect(registration.firstName, 'Oluwaseun');
      expect(registration.surname, 'Adeyemi');
      expect(registration.otherNames, 'Michael');
      expect(registration.email, 'seun@example.com');
      expect(registration.phone, '+234 803 123 4567');
      expect(registration.password, 'legion123');
      expect(registration.displayName, 'Oluwaseun Adeyemi');
    });

    test('sends the optional parts as absent, not as empty strings', () async {
      await call(otherNames: '   ', phone: '');

      final registration =
          verify(() => repository.register(captureAny())).captured.single
              as Registration;
      expect(registration.otherNames, isNull);
      expect(registration.phone, isNull);
    });

    test(
      'requires a first name',
      () => expectRejected(
        () => call(firstName: '  '),
        ValidationField.firstName,
        ValidationCode.required,
      ),
    );

    test(
      'requires a surname',
      () => expectRejected(
        () => call(surname: ''),
        ValidationField.surname,
        ValidationCode.required,
      ),
    );

    test(
      'requires an email address',
      () => expectRejected(
        () => call(email: ''),
        ValidationField.email,
        ValidationCode.required,
      ),
    );

    test(
      'rejects an address with no domain',
      () => expectRejected(
        () => call(email: 'seun@'),
        ValidationField.email,
        ValidationCode.invalidEmail,
      ),
    );

    test('accepts a phone number as people write them', () async {
      for (final phone in [
        '+234 803 123 4567',
        '08031234567',
        '(0803) 123-4567',
      ]) {
        await call(phone: phone);
      }
      verify(() => repository.register(any())).called(3);
    });

    test(
      'rejects a phone number that is not one',
      () => expectRejected(
        () => call(phone: 'call me'),
        ValidationField.phone,
        ValidationCode.invalidPhone,
      ),
    );

    test(
      'rejects a phone number with too few digits',
      () => expectRejected(
        () => call(phone: '0803'),
        ValidationField.phone,
        ValidationCode.invalidPhone,
      ),
    );

    test(
      'requires a password',
      () => expectRejected(
        () => call(password: ''),
        ValidationField.password,
        ValidationCode.required,
      ),
    );

    test(
      'rejects a short password',
      () => expectRejected(
        () => call(password: 'leg12'),
        ValidationField.password,
        ValidationCode.passwordTooShort,
      ),
    );

    test('rejects a password without both letters and numbers', () async {
      await expectRejected(
        () => call(password: 'legionlegion'),
        ValidationField.password,
        ValidationCode.passwordNeedsLettersAndNumbers,
      );
      await expectRejected(
        () => call(password: '12345678'),
        ValidationField.password,
        ValidationCode.passwordNeedsLettersAndNumbers,
      );
    });

    test(
      'requires the password to be confirmed',
      () => expectRejected(
        () => call(confirmPassword: ''),
        ValidationField.confirmPassword,
        ValidationCode.required,
      ),
    );

    test(
      'rejects a confirmation that does not match',
      () => expectRejected(
        () => call(confirmPassword: 'legion124'),
        ValidationField.confirmPassword,
        ValidationCode.passwordMismatch,
      ),
    );

    test('reports the first problem in the order the form shows fields', () {
      // Everything is wrong; the first name is what the applicant sees first.
      return expectRejected(
        () => call(firstName: '', email: 'nope', password: 'x'),
        ValidationField.firstName,
        ValidationCode.required,
      );
    });

    test('lets a repository failure through unchanged', () async {
      when(() => repository.register(any())).thenThrow(
        const ValidationFailure(
          field: ValidationField.email,
          validationCode: ValidationCode.emailAlreadyRegistered,
        ),
      );

      await expectLater(
        call,
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.validationCode,
            'code',
            ValidationCode.emailAlreadyRegistered,
          ),
        ),
      );
    });
  });
}
