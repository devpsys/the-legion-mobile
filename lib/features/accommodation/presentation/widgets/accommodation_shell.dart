import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';

/// Back handling for the student Accommodation portal.
///
/// Sits in the root navigator as the portal's shell. The portal is reached by
/// `goNamed`, which replaces the stack, so nothing is beneath it to pop to:
/// back is a destination. The hub leaves for the student hub; every other
/// screen (history, terms, rooms) unwinds to the accommodation hub.
class AccommodationShell extends StatelessWidget {
  const AccommodationShell({
    required this.location,
    required this.child,
    super.key,
  });

  /// The portal's current matched location.
  final String location;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.goNamed(accommodationBackTarget(location));
      },
      child: child,
    );
  }
}

/// The route name back leads to from a student accommodation [location].
///
/// Extracted as a pure function so the unwind rules can be tested without a
/// widget tree.
String accommodationBackTarget(String location) {
  if (location == Routes.accommodation) return Routes.homeName;
  return Routes.accommodationName;
}
