import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/password_recovery/domain/entities/password_policy.dart';

void main() {
  const policy = PasswordPolicy();

  group('PasswordPolicy', () {
    test('rejects an empty password on every rule', () {
      final result = policy.evaluate('');

      expect(result.length, 4);
      expect(result.where((requirement) => requirement.isMet), isEmpty);
      expect(policy.isCompliant(''), isFalse);
      expect(policy.strengthOf(''), 0);
    });

    test('reports the rules that are satisfied', () {
      // 9 chars, uppercase, no number, no special character.
      final result = policy.evaluate('Abcdefghi');

      expect(result[0].isMet, isTrue, reason: 'length');
      expect(result[1].isMet, isTrue, reason: 'uppercase');
      expect(result[2].isMet, isFalse, reason: 'number');
      expect(result[3].isMet, isFalse, reason: 'special');
      expect(policy.isCompliant('Abcdefghi'), isFalse);
    });

    test('accepts a password satisfying every rule', () {
      const password = 'Legion2024!';

      expect(policy.isCompliant(password), isTrue);
      expect(policy.evaluate(password).every((r) => r.isMet), isTrue);
      expect(policy.strengthOf(password), 1.0);
    });

    test('enforces the minimum length', () {
      // Meets every rule except length.
      expect(policy.isCompliant('Ab1!'), isFalse);
      expect(policy.isCompliant('Abcde1!'), isFalse, reason: '7 characters');
      expect(policy.isCompliant('Abcde12!'), isTrue, reason: '8 characters');
    });

    test('requires an uppercase letter', () {
      expect(policy.isCompliant('legion2024!'), isFalse);
      expect(policy.isCompliant('Legion2024!'), isTrue);
    });

    test('requires a digit', () {
      expect(policy.isCompliant('Legion!!!!!'), isFalse);
      expect(policy.isCompliant('Legion2024!'), isTrue);
    });

    test('requires one of the accepted special characters', () {
      for (final character in r'!@#$%^&*'.split('')) {
        expect(
          policy.isCompliant('Legion2024$character'),
          isTrue,
          reason: '$character should satisfy the rule',
        );
      }
      // A hyphen is deliberately not in the accepted set.
      expect(policy.isCompliant('Legion2024-'), isFalse);
    });

    test('strength rises with the number of satisfied rules', () {
      // Each case satisfies exactly one more rule than the previous one.
      expect(policy.strengthOf('aaaaaaaaaa'), closeTo(0.25, 0.001));
      expect(policy.strengthOf('Aaaaaaaaa'), closeTo(0.5, 0.001));
      expect(policy.strengthOf('Aaaaaaaa1'), closeTo(0.75, 0.001));
      expect(policy.strengthOf('Aaaaaaa1!'), closeTo(1.0, 0.001));
    });

    test('honours a relaxed policy', () {
      const relaxed = PasswordPolicy(
        minLength: 4,
        requiresUppercase: false,
        requiresNumber: false,
        requiresSpecialCharacter: false,
      );

      expect(relaxed.isCompliant('pass'), isTrue);
      expect(relaxed.isCompliant('abc'), isFalse);
    });
  });
}
