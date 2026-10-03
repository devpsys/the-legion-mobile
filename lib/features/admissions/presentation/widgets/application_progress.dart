import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// Readiness of the checklist: the count, and the bar under it.
///
/// The count and the bar are derived from the same two integers in the caller,
/// so they cannot disagree — the design draws "3 of 9 complete" beside a bar
/// a third of the way along, and a screen that says one thing while drawing
/// another is worse than no bar at all.
class ApplicationProgress extends StatelessWidget {
  const ApplicationProgress({
    required this.completed,
    required this.total,
    super.key,
  });

  final int completed;

  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    // Clamped so a count past the total cannot draw past the track.
    final fraction = total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                l10n.admissionsChecklistProgress,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            Text(
              l10n.admissionsChecklistProgressValue(completed, total),
              style: AppTextStyles.codeSmall.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadii.chipRadius,
          child: LinearProgressIndicator(
            // Always a number: a `null` value makes the bar animate forever,
            // which would hang `pumpAndSettle` in every test that touches it.
            value: fraction,
            minHeight: AppDimensions.trackHeight,
            valueColor: AlwaysStoppedAnimation(
              AppColors.successText(theme.brightness),
            ),
          ),
        ),
      ],
    );
  }
}
