import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../bloc/staff/exam_office_state.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_block.dart';
import 'exam_office_empty_card.dart';
import 'exam_office_entry_card.dart';
import 'exam_office_labels.dart';

/// The queue of courses and where each one's marks are.
class ResultsQueueBody extends StatelessWidget {
  const ResultsQueueBody({required this.state, super.key});

  final ExamOfficeState state;

  int _count(ResultsStage stage) =>
      state.batches.where((batch) => batch.stage == stage).length;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExamOfficeMetricRow(
          metrics: [
            ExamOfficeMetric(
              value: '${_count(ResultsStage.beingMarked)}',
              caption: l10n.examOfficeStageBeingMarked,
            ),
            ExamOfficeMetric(
              value: '${_count(ResultsStage.sentBack)}',
              caption: l10n.examOfficeStageSentBack,
            ),
            ExamOfficeMetric(
              value: '${_count(ResultsStage.withApprovers)}',
              caption: l10n.examOfficeStageWithApprovers,
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        if (state.batches.isEmpty)
          ExamOfficeEmptyCard(
            icon: Icons.fact_check_outlined,
            title: l10n.examOfficeResultsEmptyTitle,
            body: l10n.examOfficeResultsEmptyBody,
          )
        else
          for (final batch in state.batches) ...[
            ExamOfficeEntryCard(
              icon: Icons.fact_check_outlined,
              title: l10n.examOfficeCourseLine(batch.courseCode, batch.title),
              body: l10n.examOfficeResultsBatchBody(
                batch.enrolled,
                batch.markedCount,
                batch.units,
              ),
              trailing: StatusTag(
                label: ExamOfficeLabels.stage(l10n, batch.stage),
                tone: ExamOfficeLabels.stageTone(batch.stage),
              ),
              onOpen: () => context.goNamed(
                Routes.examOfficeResultsCourseName,
                pathParameters: {Routes.examOfficeBatchIdParam: batch.id},
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
      ],
    );
  }
}
