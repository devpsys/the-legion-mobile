import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../bloc/staff/exam_office_state.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_empty_card.dart';
import 'exam_office_entry_card.dart';
import 'exam_office_labels.dart';

/// Incidents reported from the halls, with filters, the count of marks they
/// are holding, and the way into the batch import.
class IncidentsBody extends StatelessWidget {
  const IncidentsBody({required this.state, super.key});

  final ExamOfficeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ExamOfficeCubit>();
    final incidents = state.visibleIncidents;
    final holding = state.holdingIncidentCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (holding > 0) ...[
          ToneCallout(
            tone: AppTone.warning,
            icon: Icons.pause_circle_outline,
            body: l10n.examOfficeIncidentsHolding(holding),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              label: Text(l10n.examOfficeFilterAll),
              selected: state.incidentStatusFilter == null,
              onSelected: (_) => cubit.setIncidentStatusFilter(null),
            ),
            for (final status in IncidentStatus.values)
              ChoiceChip(
                label: Text(ExamOfficeLabels.incidentStatus(l10n, status)),
                selected: state.incidentStatusFilter == status,
                onSelected: (_) => cubit.setIncidentStatusFilter(status),
              ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            ChoiceChip(
              label: Text(l10n.examOfficeFilterAll),
              selected: state.incidentKindFilter == null,
              onSelected: (_) => cubit.setIncidentKindFilter(null),
            ),
            for (final kind in IncidentKind.values)
              ChoiceChip(
                label: Text(ExamOfficeLabels.incidentKind(l10n, kind)),
                selected: state.incidentKindFilter == kind,
                onSelected: (_) => cubit.setIncidentKindFilter(kind),
              ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () => context.goNamed(Routes.examOfficeIncidentImportName),
          icon: const Icon(Icons.upload_file_outlined),
          label: Text(l10n.examOfficeImportAction),
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        if (incidents.isEmpty)
          ExamOfficeEmptyCard(
            icon: Icons.report_gmailerrorred_outlined,
            title: l10n.examOfficeIncidentsEmptyTitle,
            body: l10n.examOfficeIncidentsEmptyBody,
          )
        else
          for (final incident in incidents) ...[
            ExamOfficeEntryCard(
              icon: Icons.report_outlined,
              title: l10n.examOfficeIncidentLine(
                incident.courseCode,
                ExamOfficeLabels.incidentKind(l10n, incident.kind),
              ),
              body: l10n.examOfficeIncidentBody(
                incident.id,
                incident.matric ?? l10n.examOfficeIncidentNoStudent,
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusTag(
                    label: ExamOfficeLabels.incidentStatus(
                      l10n,
                      incident.status,
                    ),
                    tone: ExamOfficeLabels.incidentTone(incident.status),
                  ),
                  if (incident.holdsMark && incident.isOpen) ...[
                    AppSpacing.verticalGap(AppSpacing.xs),
                    StatusTag(
                      label: l10n.examOfficeIncidentHoldsMark,
                      tone: AppTone.warning,
                    ),
                  ],
                ],
              ),
              onOpen: () => context.goNamed(
                Routes.examOfficeIncidentName,
                pathParameters: {Routes.examOfficeIncidentIdParam: incident.id},
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
      ],
    );
  }
}
