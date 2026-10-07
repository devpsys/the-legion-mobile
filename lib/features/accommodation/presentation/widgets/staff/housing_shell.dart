import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';

/// Back handling for the Housing Directorate screens.
///
/// These routes are authenticated but not linked from the student hub, and
/// are reached by `goNamed`, which replaces the stack: back is a destination.
/// The allocations queue leaves for the student hub; the tools unwind to the
/// queue; the screens nested in the hostels directory unwind to it.
class HousingShell extends StatelessWidget {
  const HousingShell({required this.location, required this.child, super.key});

  /// The portal's current matched location.
  final String location;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.goNamed(housingBackTarget(location));
      },
      child: child,
    );
  }
}

/// The route name back leads to from a housing [location].
///
/// A pure function so the unwind rules can be tested without a widget tree.
String housingBackTarget(String location) {
  if (location == Routes.staffAllocations) return Routes.homeName;
  if (RegExp(r'^/accommodation/staff/allocations/[^/]+$').hasMatch(location)) {
    return Routes.staffAllocationsName;
  }
  if (RegExp(r'^/accommodation/staff/hostels/[^/]+/.+$').hasMatch(location) ||
      RegExp(r'^/accommodation/staff/hostels/[^/]+$').hasMatch(location)) {
    return Routes.staffHostelsName;
  }
  if (location == Routes.staffRefunds) return Routes.staffOpeningsName;
  return Routes.staffAllocationsName;
}

/// Leaves the current housing screen the way the system back gesture does.
void goBackFromHousing(BuildContext context) {
  context.goNamed(housingBackTarget(GoRouterState.of(context).matchedLocation));
}
