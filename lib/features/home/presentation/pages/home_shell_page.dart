import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/adaptive_scaffold.dart';
import '../../../../core/widgets/app_mark.dart';
import '../../../../core/widgets/confirm_exit.dart';

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

    final isOverview = navigationShell.currentIndex == HomeTab.overview.index;

    // Back is guarded here, on the shell, and not inside a branch's page. The
    // shell is a page of the root navigator, and that navigator is the one that
    // reports to Android whether the app handles back. A guard inside a branch
    // reports through the nested navigator instead, and the root navigator
    // overwrites it with "nothing to handle" whenever its own history changes
    // (a sheet closing, a route settling) — leaving the system to close the app.
    final scaffold = AdaptiveScaffold(
      selectedIndex: navigationShell.currentIndex,
      // The hub owns the full canvas on phones: it navigates through its own
      // module directory, account panel and avatar rather than a tab bar.
      showBottomNavigationBar: !isOverview,
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
        child: AppMark(size: AppDimensions.iconLarge),
      ),
      body: navigationShell,
    );

    // The hub is the root of the authenticated stack, so back there asks to
    // exit; any other tab returns to the hub first.
    if (isOverview) return ConfirmExit(child: scaffold);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        navigationShell.goBranch(HomeTab.overview.index);
      },
      child: scaffold,
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
