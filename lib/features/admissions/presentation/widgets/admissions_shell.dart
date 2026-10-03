import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';

/// Back handling for the whole candidate portal.
///
/// Sits in the root navigator, as the portal's shell, and not inside each page.
/// Android only routes the back gesture to Flutter while the framework reports
/// that it handles back, and a guard in a nested navigator has that report
/// overwritten by the root navigator's next history change (a sheet closing, a
/// route settling) — after which the system closes the app instead.
///
/// The portal is reached by `goNamed`, which replaces the stack, so nothing is
/// beneath it to pop to: back is a destination. A section other than the
/// overview unwinds to it rather than to the hub — the candidate asked a
/// question there and may have another — the detail screen unwinds one step
/// further, to the record it was opened from, and the overview itself leaves
/// for the hub.
class AdmissionsShell extends StatelessWidget {
  const AdmissionsShell({
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
        context.goNamed(admissionsBackTarget(location));
      },
      child: child,
    );
  }
}

/// The route name back leads to from [location].
///
/// Extracted from [AdmissionsShell] as a pure function so the unwind rules can
/// be tested without a widget tree, the same way `resolveRedirect` tests the
/// router's own redirects.
String admissionsBackTarget(String location) {
  // The portal's front door: back here leaves it for the hub.
  if (location == Routes.admissions) return Routes.homeName;

  // The detail lives *under* the record's path, so it unwinds to the record.
  // Matching the prefix with its trailing slash keeps `/admissions/applications`
  // — the tab itself — out of this branch.
  if (location.startsWith('${Routes.admissionsApplications}/')) {
    return Routes.admissionsApplicationsName;
  }

  return Routes.admissionsName;
}
