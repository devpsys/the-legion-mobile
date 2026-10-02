import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/adaptive_scaffold.dart';
import '../../../../core/widgets/app_mark.dart';

/// Adaptive navigation shell hosting the authenticated area.
///
/// `StatefulShellRoute` gives each branch its own navigator, which preserves
/// every tab's navigation stack — required for Android back gestures and
/// direct links to a tab's sub-route.
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const List<HomeTab> _tabs = [HomeTab.overview, HomeTab.profile];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AdaptiveScaffold(
      selectedIndex: navigationShell.currentIndex,
      destinations: [
        for (final tab in _tabs)
          AdaptiveScaffoldDestination(
            label: switch (tab) {
              HomeTab.overview => l10n.navOverview,
              HomeTab.profile => l10n.navProfile,
            },
            icon: tab.icon,
            selectedIcon: tab.selectedIcon,
          ),
      ],
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        // Tapping the active tab pops it back to its root location.
        initialLocation: index == navigationShell.currentIndex,
      ),
      railLeading: const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: AppMark(size: 40),
      ),
      body: navigationShell,
    );
  }
}

/// Navigation branches of the authenticated area.
enum HomeTab {
  overview(icon: Icons.dashboard_outlined, selectedIcon: Icons.dashboard),
  profile(icon: Icons.person_outline, selectedIcon: Icons.person);

  const HomeTab({required this.icon, required this.selectedIcon});

  final IconData icon;
  final IconData selectedIcon;
}
