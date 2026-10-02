import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

/// Scaffold that adapts its navigation chrome to the viewport.
///
/// Phones get a [NavigationBar], tablets and desktop/web get a
/// [NavigationRail]. A single implementation covers Android phones, tablets,
/// iPhone, iPad and web without duplicating pages.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    required this.body,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.appBar,
    this.floatingActionButton,
    this.railLeading,
    this.showBottomNavigationBar = true,
    super.key,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final List<AdaptiveScaffoldDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget? floatingActionButton;

  /// Optional widget pinned above the rail destinations on wide layouts.
  final Widget? railLeading;

  /// Whether phones get the navigation bar below the body.
  ///
  /// The student hub turns it off: it navigates through its own module
  /// directory, account panel and avatar, so the design's page owns the full
  /// canvas. The rail on tablets and desktop is unaffected, which keeps the
  /// other tabs reachable on wide windows.
  final bool showBottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final isCompact = context.screenSize.isCompact;

    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: isCompact
          ? body
          : Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onDestinationSelected,
                    labelType: NavigationRailLabelType.all,
                    leading: railLeading,
                    destinations: [
                      for (final destination in destinations)
                        NavigationRailDestination(
                          icon: Icon(destination.icon),
                          selectedIcon: Icon(destination.selectedIcon),
                          label: Text(destination.label),
                        ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            ),
      bottomNavigationBar: isCompact && showBottomNavigationBar
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: [
                for (final destination in destinations)
                  NavigationDestination(
                    icon: Icon(destination.icon),
                    selectedIcon: Icon(destination.selectedIcon),
                    label: destination.label,
                  ),
              ],
            )
          : null,
    );
  }
}

/// Navigation item consumed by [AdaptiveScaffold].
@immutable
class AdaptiveScaffoldDestination {
  const AdaptiveScaffoldDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
