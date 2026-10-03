import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// Reference/status pill used across the recovery designs (`SEC-L4`,
/// `Policy Compliant`, `STATUS: COMMITTED`).
class RecoveryStatusChip extends StatelessWidget {
  const RecoveryStatusChip({
    required this.label,
    this.icon,
    this.color,
    this.isMono = true,
    super.key,
  });

  final String label;
  final IconData? icon;
  final Color? color;

  /// Uses the mono scale — reference codes are meant to be scannable.
  final bool isMono;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final tone = color ?? theme.colorScheme.primary;
    final background = tone.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.chipRadius,
        border: Border.all(color: tone.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppDimensions.iconMicro, color: tone),
            AppSpacing.horizontalGap(AppSpacing.xs),
          ],
          Text(
            label,
            style: isMono
                ? AppTextStyles.codeSmall.copyWith(
                    color: tone,
                    letterSpacing: 0.6,
                  )
                : theme.textTheme.labelSmall?.copyWith(color: tone),
          ),
        ],
      ),
    );
  }
}

/// Advisory callout used for security notes and post-recovery warnings.
class RecoveryNotice extends StatelessWidget {
  const RecoveryNotice({
    required this.title,
    required this.body,
    this.icon = Icons.shield_outlined,
    super.key,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: AppDimensions.iconMedium,
            color: theme.colorScheme.primary,
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
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

/// Compact countdown badge (`Code expires in 09:42`).
class RecoveryCountdownBadge extends StatelessWidget {
  const RecoveryCountdownBadge({
    required this.label,
    required this.remaining,
    this.icon = Icons.timer_outlined,
    this.tone,
    super.key,
  });

  /// Prefix, e.g. "Code expires in".
  final String label;

  final Duration remaining;
  final IconData icon;
  final Color? tone;

  /// `09:42` / `4m 05s`, whichever reads better for the magnitude.
  static String format(Duration duration) {
    if (duration.inMinutes < 1) {
      final seconds = duration.inSeconds.clamp(0, 59);
      return '${seconds.toString().padLeft(2, '0')}s';
    }
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final color = tone ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.chipRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconMicro, color: color),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Text(
            '$label ${format(remaining)}',
            style: AppTextStyles.codeSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
