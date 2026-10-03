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
