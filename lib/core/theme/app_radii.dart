import 'package:flutter/widgets.dart';

/// Corner radius scale.
///
/// Any new radius must be added here instead of inlining
/// `BorderRadius.circular(...)` in a widget.
abstract final class AppRadii {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;

  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius field = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(pill));

  static const BorderRadius topSheet = BorderRadius.vertical(
    top: Radius.circular(xl),
  );
}
