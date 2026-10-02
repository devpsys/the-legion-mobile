import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../utils/responsive.dart';

/// Ergonomic access to ambient app data from a [BuildContext].
extension BuildContextX on BuildContext {
  /// Localized strings for the active locale.
  AppLocalizations get l10n => AppLocalizations.of(this);

  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textStyles => Theme.of(this).textTheme;

  Size get viewport => MediaQuery.sizeOf(this);

  /// Responsive bucket of the current viewport.
  ScreenSize get screenSize => resolveScreenSize(viewport.width);

  /// `true` on phone-sized layouts.
  bool get isCompact => screenSize.isCompact;

  /// `true` when the layout should use an extended (tablet/desktop) chrome.
  bool get useExtendedLayout => screenSize.isAtLeastExpanded;

  /// `true` while the software keyboard occupies part of the viewport.
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  /// Device pixel ratio, useful for platform specific assets only.
  double get pixelRatio => MediaQuery.devicePixelRatioOf(this);
}
