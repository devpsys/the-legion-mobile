import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/incident_import_body.dart';

/// Imports a batch of incidents, with a dry run first.
class ExamOfficeIncidentImportPage extends StatelessWidget {
  const ExamOfficeIncidentImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeImportTitle,
      subtitle: l10n.examOfficeImportSubtitle,
      breadcrumb: [l10n.examOfficeIncidentsTitle],
      builder: (context, state) => IncidentImportBody(state: state),
    );
  }
}
