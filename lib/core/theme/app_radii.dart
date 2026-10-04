import 'package:flutter/widgets.dart';

/// Corner radius scale of the design system.
///
/// Source: `DESIGN.md` (`rounded`) and the Tailwind `borderRadius` tokens in the
/// exported designs: `card: 20px`, `row: 16px`, `elem: 10px`.
///
/// * Cards and dialogs use [card].
/// * Inputs, buttons and select triggers use [element].
/// * Badges, status pills and portal indicators use [pill].
abstract final class AppRadii {
  static const double xs = 4;
  static const double element = 10;

  /// Recessed block inside a card — a deadline notice, a determination, a
  /// criterion row (`rounded-xl` in the exported designs).
  static const double block = 12;
  static const double row = 16;
  static const double card = 20;

  /// Fully rounded geometry for pills and indicators.
  static const double pill = 9999;

  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius rowRadius = BorderRadius.all(Radius.circular(row));
  static const BorderRadius blockRadius = BorderRadius.all(
    Radius.circular(block),
  );

  /// Barely rounded tag — the square-ish chip the designs use for a cycle
  /// or a reference, as opposed to a status pill.
  static const BorderRadius tagRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius elementRadius = BorderRadius.all(
    Radius.circular(element),
  );
  static const BorderRadius chipRadius = BorderRadius.all(
    Radius.circular(pill),
  );
  static const BorderRadius checkboxRadius = BorderRadius.all(
    Radius.circular(xs),
  );

  /// 3px accent stripe on the left edge of a card (matriculation header).
  static const BorderRadius accentStripeLeft = BorderRadius.only(
    topLeft: Radius.circular(card),
    bottomLeft: Radius.circular(card),
  );

  static const BorderRadius topSheet = BorderRadius.vertical(
    top: Radius.circular(card),
  );
}
