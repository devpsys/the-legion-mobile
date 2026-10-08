import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/exam_office_section_bar.dart';
import '../../widgets/staff/incidents_body.dart';

/// Incidents reported from the halls.
class ExamOfficeIncidentsPage extends StatelessWidget {
  const ExamOfficeIncidentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeIncidentsTitle,
      subtitle: l10n.examOfficeIncidentsSubtitle,
      section: ExamOfficeSection.incidents,
      builder: (context, state) => IncidentsBody(state: state),
    );
  }
}
