import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/responsive.dart';

/// Institutional lockout callout extracted from the design.
///
/// Explains that the account is locked and routes the user to the registry.
/// The contact details are placeholders — replace them with the real registry
/// contacts (or load them from configuration) before release.
class LockoutNoticeCard extends StatelessWidget {
  const LockoutNoticeCard({
    this.onContactRegistry,
    this.onCallRegistry,
    super.key,
  });

  final VoidCallback? onContactRegistry;
  final VoidCallback? onCallRegistry;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final dangerText = AppColors.dangerText(theme.brightness);
    final dangerSurface = AppColors.dangerSurface(theme.brightness);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: dangerSurface,
                  borderRadius: AppRadii.elementRadius,
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: AppDimensions.iconMedium + 4,
                  color: dangerText,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            context.l10n.rateLimitLockoutTitle,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        AppSpacing.horizontalGap(AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: dangerSurface,
                            borderRadius: AppRadii.chipRadius,
                          ),
                          child: Text(
                            context.l10n.rateLimitLockoutCode,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: dangerText,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      context.l10n.rateLimitLockoutBody,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.subtle(theme.brightness),
              borderRadius: AppRadii.elementRadius,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.xs),
                    Expanded(
                      child: Text(
                        context.l10n.rateLimitAdminRoute,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          letterSpacing: 0.8,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _ContactTile(
                        icon: Icons.mail_outline,
                        label: context.l10n.rateLimitRegistryEmail,
                        onTap: onContactRegistry,
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: _ContactTile(
                        icon: Icons.call_outlined,
                        label: context.l10n.rateLimitRegistryPhone,
                        onTap: onCallRegistry,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.policy_outlined,
                size: 13,
                color: theme.colorScheme.outline,
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Expanded(
                child: Text(
                  context.l10n.rateLimitStatutoryRef,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: AppRadii.elementRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.elementRadius,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadii.elementRadius,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: theme.colorScheme.outline),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.codeSmall.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                      color: theme.colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
