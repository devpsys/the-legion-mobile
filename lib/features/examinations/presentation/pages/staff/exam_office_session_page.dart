import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_empty_card.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/session_detail_body.dart';

/// One examination session: papers, clashes and issued cards.
class ExamOfficeSessionPage extends StatelessWidget {
  const ExamOfficeSessionPage({required this.sessionId, super.key});

  final String sessionId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeSessionDetailTitle,
      subtitle: l10n.examOfficeSessionDetailSubtitle,
      breadcrumb: [l10n.examOfficeSessionsTitle],
      builder: (context, state) {
        final session = state.sessionById(sessionId);
        if (session == null) {
          return ExamOfficeEmptyCard(
            icon: Icons.search_off,
            title: l10n.examOfficeSessionDetailTitle,
            body: l10n.examOfficeSessionNotFound,
          );
        }
        return SessionDetailBody(session: session);
      },
    );
  }
}
