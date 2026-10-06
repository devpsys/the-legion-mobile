import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';

/// Back handling for the Registration & Records portal.
///
/// Sits in the root navigator as the portal's shell. The portal is reached by
/// `goNamed`, which replaces the stack, so nothing is beneath it to pop to:
/// back is a destination. A section other than Registration unwinds to that
/// tab; Registration itself leaves for the hub. The ID card screen unwinds to
/// Requests; a disciplinary case unwinds to the Discipline list; Discipline
/// itself unwinds to Registration.
class RegistrationShell extends StatelessWidget {
  const RegistrationShell({
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
        context.goNamed(registrationBackTarget(location));
      },
      child: child,
    );
  }
}

/// The route name back leads to from [location].
///
/// Extracted as a pure function so the unwind rules can be tested without a
/// widget tree.
String registrationBackTarget(String location) {
  if (location == Routes.registration) return Routes.homeName;
  if (location == Routes.registrationIdCard) {
    return Routes.registrationRequestsName;
  }
  if (location.startsWith('${Routes.registrationDiscipline}/')) {
    return Routes.registrationDisciplineName;
  }
  return Routes.registrationName;
}
