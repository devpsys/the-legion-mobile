import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/exam_office_section_bar.dart';
import '../../widgets/staff/grading_body.dart';

/// The grading scales and the standing rules.
class ExamOfficeGradingPage extends StatelessWidget {
  const ExamOfficeGradingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeGradingTitle,
      subtitle: l10n.examOfficeGradingSubtitle,
      section: ExamOfficeSection.grading,
      builder: (context, state) => GradingBody(state: state),
    );
  }
}
