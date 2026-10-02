/// Spacing scale of the design system.
///
/// Source: `DESIGN.md` — a strict 4px/8px base with `space-xs` 4px,
/// `space-sm` 8px, `space-md` 12px, `space-lg` 16px, `space-xl` 24px.
/// The outer canvas gutter is 16px (24px on tablet).
library;

import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;

  /// Section break / large rhythm step.
  static const double xxl = 32;

  /// Hero rhythm step.
  static const double huge = 48;

  /// Outer canvas margin (16px mobile, 24px tablet).
  static const double canvasGutter = lg;

  /// Card interior padding: 16px on mobile, 24px on desktop.
  static const EdgeInsets card = EdgeInsets.all(lg);

  /// Content padding for dialogs and action sheets.
  static const EdgeInsets sheet = EdgeInsets.all(xl);

  static Widget verticalGap(double value) => SizedBox(height: value);

  static Widget horizontalGap(double value) => SizedBox(width: value);
}
