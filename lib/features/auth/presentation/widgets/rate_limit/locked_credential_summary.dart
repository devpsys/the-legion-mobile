import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/responsive.dart';

/// Read-only summary of the credentials that triggered the lockout.
///
/// Extracted from the design's "Compact Locked Summary Credentials Box": the
/// email stays readable, the passphrase is always masked, and every row is
/// tagged as locked. Values are never editable while the lockout is active.
class LockedCredentialSummary extends StatelessWidget {
  const LockedCredentialSummary({required this.email, super.key});

  final String email;

  /// Fixed-width mask — the length of the passphrase must not leak.
  static const String maskedPassphrase = '••••••••••••••••';

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final subtle = AppColors.subtle(theme.brightness);

    return Container(
      decoration: BoxDecoration(
        color: subtle,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _LockedRow(
            icon: Icons.badge_outlined,
            label: context.l10n.loginEmailLabel,
            value: email,
            valueStyle: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          _LockedRow(
            icon: Icons.key_outlined,
            label: context.l10n.loginPasswordLabel,
            value: maskedPassphrase,
            valueStyle: AppTextStyles.codeMedium.copyWith(
              fontWeight: AppTextStyles.bold,
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedRow extends StatelessWidget {
  const _LockedRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueStyle,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppDimensions.iconSmall,
            color: theme.colorScheme.outline,
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  value,
                  style: valueStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          _FieldLockedPill(),
        ],
      ),
    );
  }
}

/// "Field Locked" tag from the design.
class _FieldLockedPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.chipRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline, size: 12, color: theme.colorScheme.outline),
          AppSpacing.horizontalGap(AppSpacing.xs),
          Text(
            context.l10n.rateLimitFieldLocked,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
