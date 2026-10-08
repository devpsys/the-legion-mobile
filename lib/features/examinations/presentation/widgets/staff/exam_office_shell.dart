import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/route_names.dart';

/// Where back leads from an examinations office screen: a route name and the
/// path parameters it needs.
class ExamOfficeBackTarget {
  const ExamOfficeBackTarget(this.name, [this.pathParameters = const {}]);

  final String name;
  final Map<String, String> pathParameters;
}

/// Back handling for the examinations office screens.
///
/// These routes are authenticated but not linked from the student hub or the
/// student examination screens, and are reached by `goNamed`, which replaces
/// the stack: back is a destination. A list leaves for the hub; a detail
/// unwinds to the list it was opened from.
class ExamOfficeShell extends StatelessWidget {
  const ExamOfficeShell({
    required this.location,
    required this.child,
    super.key,
  });

  /// The office's current matched location.
  final String location;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        goBackFromExamOffice(context, location);
      },
      child: child,
    );
  }
}

final RegExp _paperLocation = RegExp(
  r'^/examinations/staff/sessions/([^/]+)/papers/[^/]+$',
);
final RegExp _sessionLocation = RegExp(r'^/examinations/staff/sessions/[^/]+$');
final RegExp _courseLocation = RegExp(r'^/examinations/staff/results/[^/]+$');
final RegExp _scaleLocation = RegExp(r'^/examinations/staff/grading/[^/]+$');
final RegExp _incidentLocation = RegExp(
  r'^/examinations/staff/incidents/[^/]+$',
);
final RegExp _dossierLocation = RegExp(
  r'^/examinations/staff/broadsheets/students/[^/]+$',
);

/// Where back leads from an examinations office [location].
///
/// A pure function so the unwind rules can be tested without a widget tree.
ExamOfficeBackTarget examOfficeBackTarget(String location) {
  final paper = _paperLocation.firstMatch(location);
  if (paper != null) {
    return ExamOfficeBackTarget(Routes.examOfficeSessionName, {
      Routes.examOfficeSessionIdParam: paper.group(1)!,
    });
  }
  if (_courseLocation.hasMatch(location)) {
    return const ExamOfficeBackTarget(Routes.examOfficeResultsName);
  }
  if (_sessionLocation.hasMatch(location)) {
    return const ExamOfficeBackTarget(Routes.examOfficeSessionsName);
  }
  if (_scaleLocation.hasMatch(location)) {
    return const ExamOfficeBackTarget(Routes.examOfficeGradingName);
  }
  if (location == Routes.examOfficeIncidentImport ||
      _incidentLocation.hasMatch(location)) {
    return const ExamOfficeBackTarget(Routes.examOfficeIncidentsName);
  }
  if (location == Routes.examOfficeResitsOpen) {
    return const ExamOfficeBackTarget(Routes.examOfficeResitsName);
  }
  if (_dossierLocation.hasMatch(location)) {
    return const ExamOfficeBackTarget(Routes.examOfficeBroadsheetsName);
  }
  return const ExamOfficeBackTarget(Routes.homeName);
}

/// Leaves the examinations office screen at [location] the way the system
/// back gesture does.
void goBackFromExamOffice(BuildContext context, String location) {
  final target = examOfficeBackTarget(location);
  context.goNamed(target.name, pathParameters: target.pathParameters);
}
