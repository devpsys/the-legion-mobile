import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/broadsheet_body.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/exam_office_section_bar.dart';

/// The broadsheet: a course's scores, student by student.
class ExamOfficeBroadsheetsPage extends StatelessWidget {
  const ExamOfficeBroadsheetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeBroadsheetsTitle,
      subtitle: l10n.examOfficeBroadsheetsSubtitle,
      section: ExamOfficeSection.broadsheets,
      builder: (context, state) => BroadsheetBody(state: state),
    );
  }
}
