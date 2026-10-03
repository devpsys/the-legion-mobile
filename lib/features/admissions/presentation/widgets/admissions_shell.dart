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
/// beneath it to pop to: back is a destination. Programmes unwinds to the
/// overview rather than the hub — the candidate asked a question there and may
/// have another — and every other section leaves for the hub.
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
        context.goNamed(
          location == Routes.admissions
              ? Routes.homeName
              : Routes.admissionsName,
        );
      },
      child: child,
    );
  }
}
