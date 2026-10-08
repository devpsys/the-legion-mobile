import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/open_resit_window_body.dart';

/// The open-a-resit-window form.
class ExamOfficeOpenResitWindowPage extends StatelessWidget {
  const ExamOfficeOpenResitWindowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeWindowFormTitle,
      subtitle: l10n.examOfficeWindowFormSubtitle,
      breadcrumb: [l10n.examOfficeResitsTitle],
      builder: (context, state) => const OpenResitWindowBody(),
    );
  }
}
