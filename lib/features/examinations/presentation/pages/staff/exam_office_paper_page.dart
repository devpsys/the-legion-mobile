import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_empty_card.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/paper_body.dart';

/// One paper: seating and running it.
class ExamOfficePaperPage extends StatelessWidget {
  const ExamOfficePaperPage({
    required this.sessionId,
    required this.paperId,
    super.key,
  });

  final String sessionId;
  final String paperId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficePaperTitle,
      subtitle: l10n.examOfficePaperSubtitle,
      breadcrumb: [
        l10n.examOfficeSessionsTitle,
        l10n.examOfficeSessionDetailTitle,
      ],
      builder: (context, state) {
        final session = state.sessionById(sessionId);
        final paper = session?.paperById(paperId);
        if (session == null || paper == null) {
          return ExamOfficeEmptyCard(
            icon: Icons.search_off,
            title: l10n.examOfficePaperTitle,
            body: l10n.examOfficePaperNotFound,
          );
        }
        return PaperBody(state: state, session: session, paper: paper);
      },
    );
  }
}
