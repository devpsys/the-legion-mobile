import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/responsive.dart';
import '../../models/staff/exam_office_models.dart';

/// A ruler from 0 to 100 with one segment per band, so a gap in a scale shows
/// up as a red stretch with no letter on it.
class ScaleRuler extends StatelessWidget {
  const ScaleRuler({required this.scale, super.key});

  final GradingScale scale;

  /// The top mark of a band: one below the band above it, or 100.
  int _top(int index) => index == 0 ? 100 : scale.bands[index - 1].from - 1;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final brightness = theme.brightness;
    final bands = scale.bands;
    final segments = <Widget>[];

    // Bands run from the highest mark down; the ruler runs from 0 up.
    if (scale.hasGap) {
      segments.add(
        Expanded(
          flex: scale.unmappedCount,
          child: Container(
            height: AppDimensions.trackHeight,
            decoration: BoxDecoration(
              color: AppTone.danger.surface(brightness),
              borderRadius: AppRadii.tagRadius,
            ),
          ),
        ),
      );
    }
    for (var i = bands.length - 1; i >= 0; i--) {
      final width = _top(i) - bands[i].from + 1;
      segments.add(
        Expanded(
          flex: width,
          child: Container(
            height: AppDimensions.trackHeight,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            decoration: BoxDecoration(
              color: bands[i].isPass
                  ? AppTone.success.foreground(brightness)
                  : AppTone.warning.foreground(brightness),
              borderRadius: AppRadii.tagRadius,
            ),
          ),
        ),
      );
    }

    return Row(children: segments);
  }
}

/// The letters under a [ScaleRuler], in the same proportions.
class ScaleRulerLabels extends StatelessWidget {
  const ScaleRulerLabels({required this.scale, super.key});

  final GradingScale scale;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final bands = scale.bands;
    final labels = <Widget>[];

    if (scale.hasGap) {
      labels.add(Spacer(flex: scale.unmappedCount));
    }
    for (var i = bands.length - 1; i >= 0; i--) {
      final top = i == 0 ? 100 : bands[i - 1].from - 1;
      labels.add(
        Expanded(
          flex: top - bands[i].from + 1,
          child: Center(
            child: Text(
              bands[i].letter,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }
    return Row(children: labels);
  }
}
