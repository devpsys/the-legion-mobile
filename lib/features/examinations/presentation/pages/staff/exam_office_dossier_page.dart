import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/dossier_body.dart';
import '../../widgets/staff/exam_office_empty_card.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';

/// One student's semester dossier.
class ExamOfficeDossierPage extends StatelessWidget {
  const ExamOfficeDossierPage({required this.matric, super.key});

  final String matric;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeDossierTitle,
      subtitle: l10n.examOfficeDossierSubtitle,
      breadcrumb: [l10n.examOfficeBroadsheetsTitle],
      builder: (context, state) {
        final dossier = state.dossierFor(matric);
        if (dossier == null) {
          return ExamOfficeEmptyCard(
            icon: Icons.search_off,
            title: l10n.examOfficeDossierTitle,
            body: l10n.examOfficeDossierNotFound,
          );
        }
        return DossierBody(dossier: dossier);
      },
    );
  }
}
