import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_block.dart';
import 'exam_office_labels.dart';
import 'exam_office_reason_dialog.dart';

/// Running the paper: start it, close it once sat, or cancel it.
///
/// A paper that has been sat cannot be cancelled, and the screen says so
/// rather than hiding the button.
class PaperRunningPanel extends StatelessWidget {
  const PaperRunningPanel({
    required this.session,
    required this.paper,
    super.key,
  });

  final ExamSession session;
  final ExamPaper paper;

  Future<void> _cancel(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<ExamOfficeCubit>();
    final reason = await ExamOfficeReasonDialog.show(
      context,
      title: l10n.examOfficeCancelTitle(paper.courseCode),
      body: l10n.examOfficeCancelBody,
      confirmLabel: l10n.examOfficeCancelConfirm,
    );
    if (reason == null) return;
    cubit.setPaperStatus(
      session.id,
      paper.id,
      PaperStatus.cancelled,
      reason: reason,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ExamOfficeCubit>();
    final reason = paper.cancelReason;

    return ExamOfficeBlock(
      title: l10n.examOfficeRunningHeading,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.examOfficeRunningStatus)),
            StatusTag(
              label: ExamOfficeLabels.paperStatus(l10n, paper.status),
              tone: ExamOfficeLabels.paperTone(paper.status),
            ),
          ],
        ),
        if (paper.status == PaperStatus.scheduled) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          SizedBox(
            height: AppDimensions.sheetActionHeight,
            child: FilledButton(
              onPressed: () => cubit.setPaperStatus(
                session.id,
                paper.id,
                PaperStatus.inProgress,
              ),
              child: Text(l10n.examOfficeStartPaper),
            ),
          ),
        ],
        if (paper.status == PaperStatus.inProgress) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          SizedBox(
            height: AppDimensions.sheetActionHeight,
            child: FilledButton(
              onPressed: () =>
                  cubit.setPaperStatus(session.id, paper.id, PaperStatus.sat),
              child: Text(l10n.examOfficeMarkSat),
            ),
          ),
        ],
        AppSpacing.verticalGap(AppSpacing.md),
        if (paper.status == PaperStatus.cancelled)
          ToneCallout(
            tone: AppTone.danger,
            icon: Icons.cancel_outlined,
            title: l10n.examOfficePaperCancelled,
            body: reason ?? '',
          )
        else ...[
          if (!paper.isCancellable) ...[
            ToneCallout(
              tone: AppTone.neutral,
              icon: Icons.lock_outline,
              body: l10n.examOfficeCancelLockedNote,
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
          OutlinedButton(
            // A sat paper cannot be called off: the button is there, but
            // does nothing, so the officer sees why.
            onPressed: paper.isCancellable ? () => _cancel(context) : null,
            child: Text(l10n.examOfficeCancelPaper),
          ),
        ],
      ],
    );
  }
}
