import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';

/// Tab bar of the candidate portal.
///
/// Replaces the student hub's navigation chrome: a candidate is not a student
/// yet, and these are the four things they came here to do. The active tab
/// carries an underline as well as the accent colour, so the current section
/// does not depend on hue alone.
class AdmissionsTabBar extends StatelessWidget {
  const AdmissionsTabBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.jambBadge = false,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  /// Marks the JAMB tab with a pending claim.
  final bool jambBadge;

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
                index < AdmissionsDestination.values.length;
                index++
              )
                Expanded(
                  child: AdmissionsTab(
                    destination: AdmissionsDestination.values[index],
                    isSelected: index == selectedIndex,
                    hasBadge:
                        jambBadge &&
                        AdmissionsDestination.values[index] ==
                            AdmissionsDestination.jamb,
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
///
/// An enum rather than a list of widgets, so the bar cannot be built with a
/// mismatched index and so each tab knows whether it is the overview.
enum AdmissionsDestination { overview, programmes, applications, jamb }

/// One destination of [AdmissionsTabBar].
class AdmissionsTab extends StatelessWidget {
  const AdmissionsTab({
    required this.destination,
    required this.isSelected,
    required this.hasBadge,
    required this.onTap,
    super.key,
  });

  final AdmissionsDestination destination;
  final bool isSelected;

  /// The unread pip, shown only on JAMB while a claim is pending.
  final bool hasBadge;

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
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(_icon, size: AppDimensions.iconTab, color: accent),
                if (hasBadge)
                  Positioned(
                    right: -AppSpacing.xs,
                    top: -AppSpacing.xs,
                    child: Container(
                      width: AppDimensions.indicator,
                      height: AppDimensions.indicator,
                      decoration: BoxDecoration(
                        color: AppColors.honeyGold,
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.surface),
                      ),
                    ),
                  ),
              ],
            ),
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
    AdmissionsDestination.overview =>
      isSelected ? Icons.dashboard : Icons.dashboard_outlined,
    AdmissionsDestination.programmes =>
      isSelected ? Icons.school : Icons.school_outlined,
    AdmissionsDestination.applications =>
      isSelected ? Icons.assignment : Icons.assignment_outlined,
    AdmissionsDestination.jamb =>
      isSelected ? Icons.verified : Icons.verified_outlined,
  };

  String _label(AppLocalizations l10n) => switch (destination) {
    AdmissionsDestination.overview => l10n.admissionsTabOverview,
    AdmissionsDestination.programmes => l10n.admissionsTabProgrammes,
    AdmissionsDestination.applications => l10n.admissionsTabApplications,
    AdmissionsDestination.jamb => l10n.admissionsTabJamb,
  };
}

/// Navigates the portal's tabs, sending anything not yet built to the
/// "coming soon" message rather than a dead link.
void selectAdmissionsTab(BuildContext context, int index) {
  if (AdmissionsDestination.values[index] == AdmissionsDestination.overview) {
    context.goNamed(Routes.admissionsName);
    return;
  }
  context.showMessage(context.l10n.commonComingSoon);
}
