import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/exam_office_section_bar.dart';
import '../../widgets/staff/results_queue_body.dart';

/// The queue of courses and where each one's marks are.
class ExamOfficeResultsPage extends StatelessWidget {
  const ExamOfficeResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeResultsTitle,
      subtitle: l10n.examOfficeResultsSubtitle,
      section: ExamOfficeSection.results,
      builder: (context, state) => ResultsQueueBody(state: state),
    );
  }
}
