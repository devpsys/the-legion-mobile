import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';

/// Password strength meter from the `set_new_password` design.
///
/// The fill colour tracks the success scale from the design system, and the
/// label reports how many policy rules are satisfied.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({
    required this.strength,
    required this.metCount,
    required this.totalCount,
    super.key,
  });

  /// Fraction of satisfied rules, 0 → 1.
  final double strength;

  final int metCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final brightness = theme.brightness;
    final color = switch (strength) {
      0 => theme.colorScheme.outlineVariant,
      < 0.5 => AppColors.warningText(brightness),
      < 1 => AppColors.infoText(brightness),
      _ => AppColors.successText(brightness),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          strength >= 1
              ? context.l10n.recoveryStrengthCompliant
              : context.l10n.recoveryStrengthProgress(metCount, totalCount),
          style: theme.textTheme.labelSmall?.copyWith(color: color),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        ClipRRect(
          borderRadius: AppRadii.chipRadius,
          child: LinearProgressIndicator(
            value: strength,
            minHeight: 4,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
