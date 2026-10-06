import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Tab bar of the Registration & Records portal.
///
/// Four siblings — Registration, Study plan, Form, Requests — replacing the
/// student hub's chrome while the student is here. The active tab carries an
/// underline as well as the accent colour. The ID card screen keeps Requests
/// selected; Discipline (and case detail) keep Registration selected.
class RegistrationTabBar extends StatelessWidget {
  const RegistrationTabBar({
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
                index < RegistrationDestination.values.length;
                index++
              )
                Expanded(
                  child: RegistrationTab(
                    destination: RegistrationDestination.values[index],
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

/// Which portal section a tab leads to.
enum RegistrationDestination { registration, studyPlan, form, requests }

/// One destination of [RegistrationTabBar].
class RegistrationTab extends StatelessWidget {
  const RegistrationTab({
    required this.destination,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final RegistrationDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
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
              _label(l10n),
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
                borderRadius: BorderRadius.circular(AppDimensions.tabIndicator),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon => switch (destination) {
    RegistrationDestination.registration =>
      isSelected ? Icons.menu_book : Icons.menu_book_outlined,
    RegistrationDestination.studyPlan =>
      isSelected ? Icons.account_tree : Icons.account_tree_outlined,
    RegistrationDestination.form =>
      isSelected ? Icons.description : Icons.description_outlined,
    RegistrationDestination.requests =>
      isSelected ? Icons.assignment : Icons.assignment_outlined,
  };

  String _label(AppLocalizations l10n) => switch (destination) {
    RegistrationDestination.registration => l10n.navRegistration,
    RegistrationDestination.studyPlan => l10n.navStudyPlan,
    RegistrationDestination.form => l10n.navCourseForm,
    RegistrationDestination.requests => l10n.navRequests,
  };
}

/// Navigates the portal's tabs with `goNamed` so siblings replace rather than
/// stack.
void selectRegistrationTab(BuildContext context, int index) {
  switch (RegistrationDestination.values[index]) {
    case RegistrationDestination.registration:
      context.goNamed(Routes.registrationName);
    case RegistrationDestination.studyPlan:
      context.goNamed(Routes.registrationStudyPlanName);
    case RegistrationDestination.form:
      context.goNamed(Routes.registrationFormName);
    case RegistrationDestination.requests:
      context.goNamed(Routes.registrationRequestsName);
  }
}
