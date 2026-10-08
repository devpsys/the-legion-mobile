import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/course_sheet_body.dart';
import '../../widgets/staff/exam_office_empty_card.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';

/// One course's marking sheet.
class ExamOfficeCoursePage extends StatelessWidget {
  const ExamOfficeCoursePage({required this.batchId, super.key});

  final String batchId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeCourseSheetTitle,
      subtitle: l10n.examOfficeCourseSheetSubtitle,
      breadcrumb: [l10n.examOfficeResultsTitle],
      builder: (context, state) {
        final batch = state.batchById(batchId);
        if (batch == null) {
          return ExamOfficeEmptyCard(
            icon: Icons.search_off,
            title: l10n.examOfficeCourseSheetTitle,
            body: l10n.examOfficeCourseNotFound,
          );
        }
        return CourseSheetBody(state: state, batch: batch);
      },
    );
  }
}
