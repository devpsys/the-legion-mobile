import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_entry_card.dart';
import 'exam_office_labels.dart';

/// One paper in a session: when it is, how many sit it, whether they all have
/// a seat, and a way into it.
class PaperTile extends StatelessWidget {
  const PaperTile({required this.session, required this.paper, super.key});

  final ExamSession session;
  final ExamPaper paper;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExamOfficeEntryCard(
      icon: Icons.description_outlined,
      title: l10n.examOfficeCourseLine(paper.courseCode, paper.title),
      body: l10n.examOfficePaperBody(
        paper.enrolled,
        paper.seated,
        ExamOfficeLabels.dateTime(l10n, paper.startsAt),
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          StatusTag(
            label: ExamOfficeLabels.paperStatus(l10n, paper.status),
            tone: ExamOfficeLabels.paperTone(paper.status),
          ),
          if (paper.seating != SeatingStatus.seated) ...[
            AppSpacing.verticalGap(AppSpacing.xs),
            StatusTag(
              label: ExamOfficeLabels.seating(l10n, paper.seating),
              tone: ExamOfficeLabels.seatingTone(paper.seating),
            ),
          ],
        ],
      ),
      onOpen: () => context.goNamed(
        Routes.examOfficePaperName,
        pathParameters: {
          Routes.examOfficeSessionIdParam: session.id,
          Routes.examOfficePaperIdParam: paper.id,
        },
      ),
    );
  }
}
