import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';

/// Back handling for Registration staff / registry screens.
///
/// These routes are authenticated but not linked from the student hub. Top
/// level staff lists unwind to the hub; nested screens unwind to their list.
class StaffRegistrationShell extends StatelessWidget {
  const StaffRegistrationShell({
    required this.location,
    required this.child,
    super.key,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.goNamed(staffRegistrationBackTarget(location));
      },
      child: child,
    );
  }
}

/// Route name back leads to from a staff Registration location.
String staffRegistrationBackTarget(String location) {
  if (RegExp(r'^/registration/staff/approvals/[^/]+$').hasMatch(location)) {
    return Routes.staffRegistrationApprovalsName;
  }
  if (location.startsWith('${Routes.staffRegistration}/study-plan/')) {
    return Routes.staffRegistrationApprovalsName;
  }
  if (RegExp(r'^/registration/staff/students/[^/]+$').hasMatch(location)) {
    return Routes.staffStudentsName;
  }
  if (RegExp(r'^/registration/staff/id-cards/.+$').hasMatch(location)) {
    return Routes.staffIdCardsName;
  }
  return Routes.homeName;
}
