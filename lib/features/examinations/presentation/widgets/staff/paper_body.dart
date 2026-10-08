import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../bloc/staff/exam_office_state.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_labels.dart';
import 'paper_running_panel.dart';
import 'paper_seating_panel.dart';

/// One paper: when it is, who has a seat, and running it.
class PaperBody extends StatelessWidget {
  const PaperBody({
    required this.state,
    required this.session,
    required this.paper,
    super.key,
  });

  final ExamOfficeState state;
  final ExamSession session;
  final ExamPaper paper;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.examOfficeCourseLine(paper.courseCode, paper.title),
                style: theme.textTheme.titleMedium,
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                l10n.examOfficePaperWhen(
                  ExamOfficeLabels.time(l10n, paper.endsAt),
                  ExamOfficeLabels.dateTime(l10n, paper.startsAt),
                ),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                l10n.examOfficePaperEnrolled(paper.enrolled),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        PaperSeatingPanel(
          session: session,
          paper: paper,
          overflowRooms: state.overflowRooms,
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        PaperRunningPanel(session: session, paper: paper),
      ],
    );
  }
}
