import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Semantic tone of a status, a state or a callout.
///
/// The design system has exactly five: amber, red, blue, green and neutral. A
/// widget picks a tone and never a colour, which is what keeps "blocked is red"
/// from being decided separately by each screen.
///
/// Promoted to core because more than one feature needs it — the student hub and
/// the candidate portal both render status, and a second definition would let
/// the two drift apart.
enum AppTone { warning, danger, info, success, neutral }

/// Resolves an [AppTone] to the colour pair of the current brightness.
///
/// Each tone has a container and a foreground, already checked for contrast in
/// both light and dark mode (see `app_theme_test.dart`).
extension AppToneColors on AppTone {
  /// Container colour: status pills, icon tiles and node markers.
  Color surface(Brightness brightness) => switch (this) {
    AppTone.warning => AppColors.warningSurface(brightness),
    AppTone.danger => AppColors.dangerSurface(brightness),
    AppTone.info => AppColors.infoSurface(brightness),
    AppTone.success => AppColors.successSurface(brightness),
    AppTone.neutral => AppColors.subtle(brightness),
  };

  /// Foreground colour for text and icons on [surface].
  Color foreground(Brightness brightness) => switch (this) {
    AppTone.warning => AppColors.warningText(brightness),
    AppTone.danger => AppColors.dangerText(brightness),
    AppTone.info => AppColors.infoText(brightness),
    AppTone.success => AppColors.successText(brightness),
    AppTone.neutral => AppColors.textMuted(brightness),
  };

  /// Accent stroke for the left edge of a card.
  Color accent(Brightness brightness) => foreground(brightness);

  /// Hairline around a callout filled with [surface].
  Color border(Brightness brightness) => switch (this) {
    AppTone.warning => AppColors.warningBorder(brightness),
    AppTone.danger => AppColors.dangerBorder(brightness),
    AppTone.info => AppColors.infoBorder(brightness),
    AppTone.success => AppColors.successBorder(brightness),
    AppTone.neutral => AppColors.stroke(brightness),
  };
}
