import 'package:intl/intl.dart';

/// Symbol the university quotes every fee in.
const String nairaSymbol = '₦';

/// Grouped digits, shared by every amount the app renders.
///
/// `en` is bundled with `intl`, so this needs no locale initialisation — and a
/// fixed locale keeps a tabular column aligned whatever the app language is.
final NumberFormat _grouped = NumberFormat.decimalPattern('en');

/// Formats an amount held in minor units (kobo) as a naira price.
///
/// Minor units, not a double: money in a `double` drifts, and a form fee that
/// prints as `₦7,499.99` on one device and `₦7,500.00` on another is the kind
/// of bug that ends up in a support queue. Kobo also matches what the payment
/// APIs expect.
String formatNaira(int minorUnits) {
  final isNegative = minorUnits < 0;
  final absolute = minorUnits.abs();

  // Remainder first: 750_001 is ₦7,500.01, not ₦7,501.
  final kobo = (absolute % 100).toString().padLeft(2, '0');
  final naira = _grouped.format(absolute ~/ 100);

  return '${isNegative ? '-' : ''}$nairaSymbol$naira.$kobo';
}

/// [formatNaira] without the symbol — `66,000.00` — for a field whose
/// decoration already shows the `₦`, so the figure is not written twice.
String formatNairaFigure(int minorUnits) =>
    formatNaira(minorUnits).replaceFirst(nairaSymbol, '');

/// The shape of an amount a person types: digits, optional thousands commas,
/// and at most two decimals.
final RegExp _typedAmount = RegExp(r'^\d+(?:\.\d{0,2})?$');

/// Reads a typed naira amount back into minor units (kobo), or `null` when
/// the text is not an amount.
///
/// The inverse of [formatNaira] for a payment field: `₦25,000.00`, `25000`,
/// `25,000.5` and ` 25000.50 ` all read as `2500050`. Anything with a third
/// decimal, a sign, or letters is refused rather than guessed at — a payment
/// screen must never charge a figure the student did not type.
int? parseNaira(String raw) {
  final text = raw.replaceAll(nairaSymbol, '').replaceAll(',', '').trim();
  if (text.isEmpty || !_typedAmount.hasMatch(text)) return null;

  final parts = text.split('.');
  final naira = int.parse(parts.first);
  final kobo = parts.length == 1 ? 0 : int.parse(parts[1].padRight(2, '0'));
  return naira * 100 + kobo;
}
