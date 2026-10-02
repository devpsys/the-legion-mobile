import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/hub_models.dart';

/// Resolves a [HubTone] to the colour pair of the current brightness.
///
/// The hub leans on the semantic scale the design system already defines
/// (amber for actionable, red for blocked, blue for waiting, green for done),
/// so widgets pick a tone and never a raw colour.
extension HubToneColors on HubTone {
  /// Container colour: status pills, icon tiles and node markers.
  Color surface(Brightness brightness) => switch (this) {
    HubTone.warning => AppColors.warningSurface(brightness),
    HubTone.danger => AppColors.dangerSurface(brightness),
    HubTone.info => AppColors.infoSurface(brightness),
    HubTone.success => AppColors.successSurface(brightness),
    HubTone.neutral => AppColors.subtle(brightness),
  };

  /// Foreground colour for text and icons on [surface].
  Color foreground(Brightness brightness) => switch (this) {
    HubTone.warning => AppColors.warningText(brightness),
    HubTone.danger => AppColors.dangerText(brightness),
    HubTone.info => AppColors.infoText(brightness),
    HubTone.success => AppColors.successText(brightness),
    HubTone.neutral => AppColors.textMuted(brightness),
  };

  /// Tinted accent stroke for the left edge of a card.
  Color accent(Brightness brightness) => foreground(brightness);
}
