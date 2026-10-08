import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_empty_card.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/incident_detail_body.dart';

/// One incident.
class ExamOfficeIncidentPage extends StatelessWidget {
  const ExamOfficeIncidentPage({required this.incidentId, super.key});

  final String incidentId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeIncidentDetailTitle,
      subtitle: l10n.examOfficeIncidentDetailSubtitle,
      breadcrumb: [l10n.examOfficeIncidentsTitle],
      builder: (context, state) {
        final incident = state.incidentById(incidentId);
        if (incident == null) {
          return ExamOfficeEmptyCard(
            icon: Icons.search_off,
            title: l10n.examOfficeIncidentDetailTitle,
            body: l10n.examOfficeIncidentNotFound,
          );
        }
        return IncidentDetailBody(state: state, incident: incident);
      },
    );
  }
}
