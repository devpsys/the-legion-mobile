import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';

/// Back handling for the student Examinations & Results portal.
///
/// Sits in the root navigator as the portal's shell. The portal is reached by
/// `goNamed`, which replaces the stack, so nothing is beneath it to pop to:
/// back is a destination. The results hub leaves for the student hub; the
/// other tabs (resits, card) unwind to results.
class ExaminationsShell extends StatelessWidget {
  const ExaminationsShell({
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
        context.goNamed(examinationsBackTarget(location));
      },
      child: child,
    );
  }
}

/// The route name back leads to from a student examinations [location].
///
/// Extracted as a pure function so the unwind rules can be tested without a
/// widget tree.
String examinationsBackTarget(String location) {
  if (location == Routes.examinations) return Routes.homeName;
  return Routes.examinationsName;
}
