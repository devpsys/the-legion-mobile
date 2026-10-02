import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/extensions/string_extensions.dart';

void main() {
  group('isBlank', () {
    test('detects whitespace-only strings', () {
      expect('   '.isBlank, isTrue);
      expect(''.isBlank, isTrue);
      expect('a'.isBlank, isFalse);
    });
  });

  group('isValidEmail', () {
    test('accepts well formed addresses', () {
      expect('user@example.com'.isValidEmail, isTrue);
      expect('first.last+tag@sub.example.co.uk'.isValidEmail, isTrue);
      expect('  spaced@example.com  '.isValidEmail, isTrue);
    });

    test('rejects malformed addresses', () {
      expect('user'.isValidEmail, isFalse);
      expect('user@'.isValidEmail, isFalse);
      expect('user@example'.isValidEmail, isFalse);
      expect('@example.com'.isValidEmail, isFalse);
      expect(''.isValidEmail, isFalse);
    });
  });
}
