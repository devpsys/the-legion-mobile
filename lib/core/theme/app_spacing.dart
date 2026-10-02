/// Spacing scale used by every layout in the application.
///
/// Use the named steps instead of raw numbers so rhythm stays consistent and
/// a design change only has to happen in one place.
library;

import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Padding for cards and panels.
  static const EdgeInsets card = EdgeInsets.all(md);

  static Widget verticalGap(double value) => SizedBox(height: value);

  static Widget horizontalGap(double value) => SizedBox(width: value);
}
