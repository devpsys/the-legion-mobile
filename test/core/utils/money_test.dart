import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/utils/money.dart';

void main() {
  group('formatNaira', () {
    test('quotes kobo as a two-decimal amount', () {
      expect(formatNaira(750000), '₦7,500.00');
      expect(formatNaira(600000), '₦6,000.00');
      expect(formatNaira(125000), '₦1,250.00');
    });

    test('keeps the kobo rather than rounding it away', () {
      expect(
        formatNaira(750001),
        '₦7,500.01',
        reason: 'a fee a kobo over is a different fee',
      );
      expect(formatNaira(5), '₦0.05');
      expect(formatNaira(50), '₦0.50');
    });

    test('groups thousands', () {
      expect(formatNaira(100000000), '₦1,000,000.00');
      expect(formatNaira(100000000000), '₦1,000,000,000.00');
    });

    test('holds a zero fee at two decimals', () {
      expect(
        formatNaira(0),
        '₦0.00',
        reason: 'a null fee must not render as an empty string',
      );
    });

    test('puts the sign before the symbol', () {
      // A refund or a reversal; the symbol never leads a negative amount.
      expect(formatNaira(-750000), '-₦7,500.00');
    });
  });

  group('formatNairaFigure', () {
    test('is the amount without its symbol, for a decorated field', () {
      expect(formatNairaFigure(6600000), '66,000.00');
      expect(formatNairaFigure(0), '0.00');
    });
  });

  group('parseNaira', () {
    test('reads a typed amount back into kobo', () {
      expect(parseNaira('25000'), 2500000);
      expect(parseNaira('25,000'), 2500000);
      expect(parseNaira('25,000.00'), 2500000);
      expect(parseNaira('₦25,000.50'), 2500050);
      expect(parseNaira(' 25000.5 '), 2500050);
    });

    test('round-trips what formatNairaFigure writes', () {
      for (final kobo in [0, 5, 35000, 6600000, 16500000]) {
        expect(parseNaira(formatNairaFigure(kobo)), kobo);
        expect(parseNaira(formatNaira(kobo)), kobo);
      }
    });

    test('keeps a lone point from meaning anything', () {
      expect(parseNaira('25000.'), 2500000);
      expect(parseNaira('.50'), isNull);
    });

    test('refuses what is not an amount rather than guessing', () {
      expect(parseNaira(''), isNull);
      expect(parseNaira('   '), isNull);
      expect(parseNaira('abc'), isNull);
      expect(parseNaira('-25000'), isNull);
      expect(parseNaira('25000.123'), isNull, reason: 'a third decimal');
      expect(parseNaira('25.000,00'), isNull, reason: 'continental format');
    });
  });
}
