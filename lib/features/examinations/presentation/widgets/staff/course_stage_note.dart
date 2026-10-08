import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_labels.dart';

/// What the stage of a batch means for the officer, as a callout: the head of
/// department's note on a batch sent back, who holds a batch that is with the
/// approvers, or when and under what reference it was published.
class CourseStageNote extends StatelessWidget {
  const CourseStageNote({required this.batch, super.key});

  final MarkingBatch batch;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final note = batch.hodNote;

    switch (batch.stage) {
      case ResultsStage.beingMarked:
        return ToneCallout(
          tone: AppTone.info,
          icon: Icons.edit_note,
          body: l10n.examOfficeStageNoteMarking,
        );
      case ResultsStage.sentBack:
        return ToneCallout(
          tone: AppTone.warning,
          icon: Icons.undo,
          title: note == null
              ? l10n.examOfficeStageSentBack
              : l10n.examOfficeHodNoteTitle(
                  note.author,
                  ExamOfficeLabels.date(l10n, note.sentOn),
                ),
          body: note == null
              ? l10n.examOfficeFlaggedCount(batch.flaggedCount)
              : l10n.examOfficeHodNoteBody(batch.flaggedCount, note.note),
        );
      case ResultsStage.withApprovers:
        final due = batch.approvalDue;
        return ToneCallout(
          tone: AppTone.neutral,
          icon: Icons.lock_outline,
          body: l10n.examOfficeLockedApprovers(
            due == null ? '' : ExamOfficeLabels.date(l10n, due),
            batch.approvalDesk ?? '',
          ),
        );
      case ResultsStage.published:
        final on = batch.publishedOn;
        return ToneCallout(
          tone: AppTone.success,
          icon: Icons.verified_outlined,
          body: l10n.examOfficePublishedNote(
            on == null ? '' : ExamOfficeLabels.date(l10n, on),
            batch.gazetteRef ?? '',
          ),
        );
    }
  }
}
