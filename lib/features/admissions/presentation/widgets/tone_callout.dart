import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';

/// A short notice in one of the five tones: an icon, an optional title, and
/// the sentence that matters.
///
/// One widget for a warning before an irreversible act and for the answer when
/// a lookup finds nothing, so "amber is a caution, red is a refusal" is
/// decided by the tone and not redrawn by every screen.
class ToneCallout extends StatelessWidget {
  const ToneCallout({
    required this.tone,
    required this.icon,
    required this.body,
    this.title,
    super.key,
  });

  final AppTone tone;
  final IconData icon;

  /// A heading above [body]; most callouts go without.
  final String? title;

  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final brightness = theme.brightness;
    final foreground = tone.foreground(brightness);
    final title = this.title;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: tone.surface(brightness),
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: tone.border(brightness)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconMedium, color: foreground),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: foreground,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                ],
                Text(
                  body,
                  style: theme.textTheme.labelMedium?.copyWith(
                    // A title carries the tone; a lone sentence is the tone.
                    color: title == null
                        ? foreground
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: AppTextStyles.regular,
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
