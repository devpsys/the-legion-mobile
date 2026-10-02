import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../models/hub_models.dart';
import 'hub_card.dart';

/// Account panel: the six shortcuts a student returns to most, plus sign-out.
///
/// The destructive action is deliberately quiet (a tinted bar, not a filled
/// button) so it cannot be hit by accident on the way to Payments.
class AccountServicesPanel extends StatelessWidget {
  const AccountServicesPanel({
    required this.utilities,
    required this.onSignOut,
    this.onUtilityTap,
    super.key,
  });

  final List<AccountUtility> utilities;
  final VoidCallback onSignOut;
  final void Function(AccountUtility utility)? onUtilityTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return HubCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.manage_accounts_outlined,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.homeAccountServices,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                context.l10n.homeQuickActions.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Divider(
            height: AppDimensions.hairline,
            color: theme.colorScheme.outlineVariant,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          _UtilityGrid(utilities: utilities, onUtilityTap: onUtilityTap),
          AppSpacing.verticalGap(AppSpacing.md),
          Divider(
            height: AppDimensions.hairline,
            color: theme.colorScheme.outlineVariant,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onSignOut,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.dangerText(theme.brightness),
              backgroundColor: AppColors.dangerSurface(theme.brightness)
                  .withValues(alpha: 0.5),
              side: const BorderSide(color: Colors.transparent),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.elementRadius,
              ),
            ),
            icon: const Icon(Icons.logout, size: 19),
            label: Text(context.l10n.homeSignOut),
          ),
        ],
      ),
    );
  }
}

/// Two-column grid of utility chips, as in the design.
class _UtilityGrid extends StatelessWidget {
  const _UtilityGrid({required this.utilities, this.onUtilityTap});

  final List<AccountUtility> utilities;
  final void Function(AccountUtility utility)? onUtilityTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Widest layout gets three columns so the shortcuts do not stretch.
        final columns = context.screenSize.isAtLeastExpanded ? 3 : 2;
        const spacing = AppSpacing.sm + 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final utility in utilities)
              SizedBox(
                width:
                    (constraints.maxWidth - spacing * (columns - 1)) / columns,
                child: _UtilityChip(
                  utility: utility,
                  onTap: onUtilityTap == null
                      ? null
                      : () => onUtilityTap!(utility),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// One shortcut chip: 44px tall, icon plus label.
class _UtilityChip extends StatelessWidget {
  const _UtilityChip({required this.utility, this.onTap});

  final AccountUtility utility;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: AppRadii.elementRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.elementRadius,
        child: Container(
          height: AppDimensions.minTapTarget,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadii.elementRadius,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Icon(
                utility.icon,
                size: AppDimensions.iconMedium - 2,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  utility.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
