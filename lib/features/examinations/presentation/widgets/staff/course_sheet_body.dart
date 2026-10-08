import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../bloc/staff/exam_office_state.dart';
import '../../models/staff/exam_office_models.dart';
import 'course_stage_note.dart';
import 'exam_office_block.dart';
import 'exam_office_confirm_dialog.dart';
import 'exam_office_labels.dart';
import 'mark_entry_row.dart';

/// One course's marking sheet: where the marks are in the approval chain, the
/// students' marks, and the button that sends them on.
class CourseSheetBody extends StatefulWidget {
  const CourseSheetBody({required this.state, required this.batch, super.key});

  final ExamOfficeState state;
  final MarkingBatch batch;

  @override
  CourseSheetBodyState createState() => CourseSheetBodyState();
}

/// State of [CourseSheetBody].
class CourseSheetBodyState extends State<CourseSheetBody> {
  /// Who is listed. Fixed when the filter changes, so a row does not vanish
  /// from under the officer's fingers the moment its last mark is typed.
  late Set<String> _shown = _compute();

  Set<String> _compute() => {
    for (final entry in widget.batch.visible(widget.state.markFilter))
      entry.matric,
  };

  @override
  void didUpdateWidget(CourseSheetBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.markFilter != widget.state.markFilter ||
        oldWidget.batch.id != widget.batch.id) {
      _shown = _compute();
    }
  }

  Future<void> _send() async {
    final l10n = context.l10n;
    final cubit = context.read<ExamOfficeCubit>();
    FocusScope.of(context).unfocus();
    final confirmed = await confirmExamOfficeAction(
      context,
      title: l10n.examOfficeSendConfirmTitle(widget.batch.courseCode),
      body: l10n.examOfficeSendConfirmBody,
      confirmLabel: l10n.examOfficeSendConfirmAction,
    );
    if (!confirmed) return;
    cubit.sendForApproval(widget.batch.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final batch = widget.batch;
    final state = widget.state;
    final blocked = state.blockedSendBatchId == batch.id;
    final rows = [
      for (final entry in batch.entries)
        if (_shown.contains(entry.matric)) entry,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.examOfficeCourseLine(batch.courseCode, batch.title),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  StatusTag(
                    label: ExamOfficeLabels.stage(l10n, batch.stage),
                    tone: ExamOfficeLabels.stageTone(batch.stage),
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              ExamOfficeMetricRow(
                metrics: [
                  ExamOfficeMetric(
                    value: '${batch.markedCount}',
                    caption: l10n.examOfficeFilterMarked,
                  ),
                  ExamOfficeMetric(
                    value: '${batch.unmarkedCount}',
                    caption: l10n.examOfficeFilterUnmarked,
                  ),
                  ExamOfficeMetric(
                    value: '${batch.heldCount}',
                    caption: l10n.examOfficeFilterHeld,
                  ),
                ],
              ),
            ],
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        CourseStageNote(batch: batch),
        if (blocked) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          ToneCallout(
            tone: AppTone.danger,
            icon: Icons.block,
            title: l10n.examOfficeSendBlockedTitle(batch.unmarkedCount),
            body: l10n.examOfficeSendBlockedBody(
              batch.unmarkedEntries
                  .map((entry) => '${entry.name} (${entry.matric})')
                  .join(', '),
            ),
          ),
        ],
        AppSpacing.verticalGap(AppSpacing.lg),
        if (batch.isEditable) ...[
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final filter in MarkFilter.values)
                ChoiceChip(
                  label: Text(ExamOfficeLabels.markFilter(l10n, filter)),
                  selected: state.markFilter == filter,
                  onSelected: (_) =>
                      context.read<ExamOfficeCubit>().setMarkFilter(filter),
                ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
        ],
        if (rows.isEmpty)
          SurfaceCard(child: Text(l10n.examOfficeMarkEmpty))
        else
          for (final entry in rows) ...[
            SurfaceCard(
              child: MarkEntryRow(
                key: ValueKey('${batch.id}/${entry.matric}'),
                batch: batch,
                entry: entry,
                grade: state.gradeFor(entry.total),
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
        if (batch.isEditable) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          SizedBox(
            height: AppDimensions.primaryActionHeight,
            child: FilledButton(
              onPressed: _send,
              child: Text(l10n.examOfficeSendButton),
            ),
          ),
        ],
      ],
    );
  }
}
