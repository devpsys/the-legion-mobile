import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/responsive.dart';

/// Amber alert strip extracted from
/// `sign_in_rate_limited_locked__sign_in_rate_limited_banner_inspection_layout`.
///
/// Timer chip, headline, live countdown and the security-alert tag.
class RateLimitAlertBanner extends StatelessWidget {
  const RateLimitAlertBanner({required this.remaining, super.key});

  /// Time left before sign-in unlocks.
  final Duration remaining;

  /// Formats the countdown the way the design does (`41s`, `4m 02s`).
  static String formatRemaining(Duration remaining) {
    final seconds = remaining.inSeconds;
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final rest = seconds % 60;
    return '${minutes}m ${rest.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;
    final warningText = AppColors.warningText(theme.brightness);
    final warningSurface = AppColors.warningSurface(theme.brightness);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: warningSurface,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(
            alpha: isDark ? 0.35 : 0.3,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.iconTileSmall,
            height: AppDimensions.iconTileSmall,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.timer_outlined,
              size: AppDimensions.iconSmall + 4,
              color: warningText,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.rateLimitTitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: warningText,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '${context.l10n.rateLimitRetryIn} '),
                      TextSpan(
                        text: formatRemaining(remaining),
                        style: AppTextStyles.codeMedium.copyWith(
                          color: warningText,
                          fontWeight: AppTextStyles.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: warningText.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: warningText,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: warningText,
              borderRadius: AppRadii.elementRadius,
            ),
            child: Text(
              context.l10n.rateLimitTag,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.surface,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin cooldown meter extracted from the same design.
class CooldownProgressMeter extends StatelessWidget {
  const CooldownProgressMeter({required this.progress, super.key});

  /// Fraction of the cooldown still to elapse (0 → empty, 1 → full).
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return ClipRRect(
      borderRadius: AppRadii.chipRadius,
      child: LinearProgressIndicator(
        value: progress,
        minHeight: AppDimensions.meterHeight,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation(
          AppColors.warningText(theme.brightness),
        ),
      ),
    );
  }
}
