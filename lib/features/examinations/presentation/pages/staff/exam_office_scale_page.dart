import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../widgets/staff/exam_office_empty_card.dart';
import '../../widgets/staff/exam_office_page_scaffold.dart';
import '../../widgets/staff/scale_detail_body.dart';

/// One grading scale.
class ExamOfficeScalePage extends StatelessWidget {
  const ExamOfficeScalePage({required this.scaleId, super.key});

  final String scaleId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficePageScaffold(
      title: l10n.examOfficeScaleDetailTitle,
      subtitle: l10n.examOfficeScaleDetailSubtitle,
      breadcrumb: [l10n.examOfficeGradingTitle],
      builder: (context, state) {
        final scale = state.scaleById(scaleId);
        if (scale == null) {
          return ExamOfficeEmptyCard(
            icon: Icons.search_off,
            title: l10n.examOfficeScaleDetailTitle,
            body: l10n.examOfficeScaleNotFound,
          );
        }
        return ScaleDetailBody(scale: scale);
      },
    );
  }
}
