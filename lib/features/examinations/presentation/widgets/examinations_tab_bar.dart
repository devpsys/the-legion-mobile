import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Which portal section a tab leads to.
enum ExaminationsDestination { results, resits, card }

/// Tab bar of the student Examinations & Results portal: results, resits and
/// the examination card.
///
/// The active tab carries an underline as well as the accent colour.
class ExaminationsTabBar extends StatelessWidget {
  const ExaminationsTabBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppDimensions.admissionsBarHeight,
          child: Row(
            children: [
              for (
                var index = 0;
                index < ExaminationsDestination.values.length;
                index++
              )
                Expanded(
                  child: ExaminationsTab(
                    destination: ExaminationsDestination.values[index],
                    isSelected: index == selectedIndex,
                    onTap: () => onDestinationSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One destination of [ExaminationsTabBar].
class ExaminationsTab extends StatelessWidget {
  const ExaminationsTab({
    required this.destination,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final ExaminationsDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final accent = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, size: AppDimensions.iconTab, color: accent),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              _label(context.l10n),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: accent,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Container(
              width: isSelected ? AppDimensions.tabIndicator : 0,
              height: AppDimensions.tabIndicatorHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: AppRadii.chipRadius,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon => switch (destination) {
    ExaminationsDestination.results =>
      isSelected ? Icons.workspace_premium : Icons.workspace_premium_outlined,
    ExaminationsDestination.resits =>
      isSelected
          ? Icons.replay_circle_filled
          : Icons.replay_circle_filled_outlined,
    ExaminationsDestination.card =>
      isSelected ? Icons.badge : Icons.badge_outlined,
  };

  String _label(AppLocalizations l10n) => switch (destination) {
    ExaminationsDestination.results => l10n.navExamResults,
    ExaminationsDestination.resits => l10n.navExamResits,
    ExaminationsDestination.card => l10n.navExamCard,
  };
}

/// Navigates the portal's tabs with `goNamed` so siblings replace rather than
/// stack.
void selectExaminationsTab(BuildContext context, int index) {
  switch (ExaminationsDestination.values[index]) {
    case ExaminationsDestination.results:
      context.goNamed(Routes.examinationsName);
    case ExaminationsDestination.resits:
      context.goNamed(Routes.examinationsResitsName);
    case ExaminationsDestination.card:
      context.goNamed(Routes.examinationsCardName);
  }
}
