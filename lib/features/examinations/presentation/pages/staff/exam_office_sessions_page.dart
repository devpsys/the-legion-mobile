import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/exam_office_section_bar.dart';
import '../../widgets/staff/sessions_body.dart';

/// The semester's examination sessions.
class ExamOfficeSessionsPage extends StatelessWidget {
  const ExamOfficeSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeSessionsTitle,
      subtitle: l10n.examOfficeSessionsSubtitle,
      section: ExamOfficeSection.sessions,
      builder: (context, state) => SessionsBody(state: state),
    );
  }
}
