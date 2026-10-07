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
enum AccommodationDestination { accommodation, history }

/// Tab bar of the student Accommodation portal: the hub and the history.
///
/// The active tab carries an underline as well as the accent colour. The
/// terms and room screens are tasks with their own back chevron, so they do
/// not show this bar.
class AccommodationTabBar extends StatelessWidget {
  const AccommodationTabBar({
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
                index < AccommodationDestination.values.length;
                index++
              )
                Expanded(
                  child: AccommodationTab(
                    destination: AccommodationDestination.values[index],
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

/// One destination of [AccommodationTabBar].
class AccommodationTab extends StatelessWidget {
  const AccommodationTab({
    required this.destination,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final AccommodationDestination destination;
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
    AccommodationDestination.accommodation =>
      isSelected ? Icons.apartment : Icons.apartment_outlined,
    AccommodationDestination.history =>
      isSelected ? Icons.history_edu : Icons.history_edu_outlined,
  };

  String _label(AppLocalizations l10n) => switch (destination) {
    AccommodationDestination.accommodation => l10n.navAccommodation,
    AccommodationDestination.history => l10n.navAccommodationHistory,
  };
}

/// Navigates the portal's tabs with `goNamed` so siblings replace rather than
/// stack.
void selectAccommodationTab(BuildContext context, int index) {
  switch (AccommodationDestination.values[index]) {
    case AccommodationDestination.accommodation:
      context.goNamed(Routes.accommodationName);
    case AccommodationDestination.history:
      context.goNamed(Routes.accommodationHistoryName);
  }
}
