import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/labelled_value_row.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../bloc/staff/exam_office_state.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_confirm_dialog.dart';
import 'exam_office_labels.dart';

/// One incident: what was reported, whether it is holding a mark, and the two
/// ways to settle it.
class IncidentDetailBody extends StatelessWidget {
  const IncidentDetailBody({
    required this.state,
    required this.incident,
    super.key,
  });

  final ExamOfficeState state;
  final ExamIncident incident;

  Future<void> _close(BuildContext context) async {
    final l10n = context.l10n;
    final cubit = context.read<ExamOfficeCubit>();
    final confirmed = await confirmExamOfficeAction(
      context,
      title: l10n.examOfficeCloseTitle(incident.id),
      body: incident.holdsMark
          ? l10n.examOfficeCloseBodyHolding
          : l10n.examOfficeCloseBody,
      confirmLabel: l10n.examOfficeCloseConfirm,
    );
    if (!confirmed) return;
    cubit.closeIncident(incident.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final cubit = context.read<ExamOfficeCubit>();
    final locked =
        incident.holdsMark &&
        incident.isOpen &&
        state.isResultLocked(incident.courseCode);
    final hearing = incident.hearingOn;
    final ref = incident.disciplineRef;

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
                      ExamOfficeLabels.incidentKind(l10n, incident.kind),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  StatusTag(
                    label: ExamOfficeLabels.incidentStatus(
                      l10n,
                      incident.status,
                    ),
                    tone: ExamOfficeLabels.incidentTone(incident.status),
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              LabelledValueRow(
                label: l10n.examOfficeIncidentFieldReference,
                value: incident.id,
              ),
              LabelledValueRow(
                label: l10n.examOfficeIncidentFieldStudent,
                value: incident.matric ?? l10n.examOfficeIncidentNoStudent,
              ),
              LabelledValueRow(
                label: l10n.examOfficeIncidentFieldCourse,
                value: incident.courseCode,
              ),
              LabelledValueRow(
                label: l10n.examOfficeIncidentFieldSitting,
                value: ExamOfficeLabels.dateTime(l10n, incident.sittingAt),
              ),
              LabelledValueRow(
                label: l10n.examOfficeIncidentFieldHall,
                value: incident.hall,
              ),
              if (ref != null)
                LabelledValueRow(
                  label: l10n.examOfficeIncidentFieldDiscipline,
                  value: ref,
                ),
              if (hearing != null)
                LabelledValueRow(
                  label: l10n.examOfficeIncidentFieldHearing,
                  value: ExamOfficeLabels.date(l10n, hearing),
                ),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                incident.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
            ],
          ),
        ),
        if (incident.holdsMark && incident.isOpen) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          ToneCallout(
            tone: AppTone.warning,
            icon: Icons.pause_circle_outline,
            title: l10n.examOfficeHoldingTitle,
            body: l10n.examOfficeHoldingBody(incident.courseCode),
          ),
        ],
        if (locked) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          ToneCallout(
            tone: AppTone.neutral,
            icon: Icons.lock_outline,
            body: l10n.examOfficeNoticeReleaseLocked,
          ),
        ],
        if (incident.isOpen) ...[
          AppSpacing.verticalGap(AppSpacing.lg),
          if (incident.status != IncidentStatus.referred) ...[
            OutlinedButton(
              onPressed: () => cubit.referIncident(incident.id),
              child: Text(l10n.examOfficeIncidentRefer),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
          FilledButton(
            onPressed: () => _close(context),
            child: Text(l10n.examOfficeIncidentClose),
          ),
        ],
      ],
    );
  }
}
