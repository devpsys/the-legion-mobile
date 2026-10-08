import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/exam_office_section_bar.dart';
import '../../widgets/staff/resit_windows_body.dart';

/// The resit windows, open and closed.
class ExamOfficeResitsPage extends StatelessWidget {
  const ExamOfficeResitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeResitsTitle,
      subtitle: l10n.examOfficeResitsSubtitle,
      section: ExamOfficeSection.resits,
      builder: (context, state) => ResitWindowsBody(state: state),
    );
  }
}
