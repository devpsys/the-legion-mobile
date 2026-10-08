import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../bloc/staff/exam_office_state.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_block.dart';
import 'import_row_tile.dart';

/// Importing a batch of incidents: the file, a dry run that says what would
/// happen to each row without writing anything, and then the import itself.
class IncidentImportBody extends StatelessWidget {
  const IncidentImportBody({required this.state, super.key});

  final ExamOfficeState state;

  int _count(ImportAction action) =>
      state.importReport.where((report) => report.action == action).length;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ExamOfficeCubit>();
    final status = state.importStatus;
    final reports = state.importReport;
    final importable =
        _count(ImportAction.importIt) + _count(ImportAction.importUnattached);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        switch (status) {
          ImportStatus.idle => ToneCallout(
            tone: AppTone.info,
            icon: Icons.upload_file_outlined,
            body: l10n.examOfficeImportIdle(state.importRows.length),
          ),
          ImportStatus.dryRun => ToneCallout(
            tone: AppTone.warning,
            icon: Icons.fact_check_outlined,
            title: l10n.examOfficeImportDryRunTitle,
            body: l10n.examOfficeImportDryRunBody,
          ),
          ImportStatus.imported => ToneCallout(
            tone: AppTone.success,
            icon: Icons.check_circle_outline,
            body: l10n.examOfficeImportDone(importable),
          ),
        },
        if (status == ImportStatus.dryRun) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          ExamOfficeMetricRow(
            metrics: [
              ExamOfficeMetric(
                value: '${_count(ImportAction.importIt)}',
                caption: l10n.examOfficeImportActionImport,
              ),
              ExamOfficeMetric(
                value: '${_count(ImportAction.importUnattached)}',
                caption: l10n.examOfficeImportActionUnattached,
              ),
              ExamOfficeMetric(
                value: '${_count(ImportAction.leave)}',
                caption: l10n.examOfficeImportActionLeave,
              ),
            ],
          ),
        ],
        AppSpacing.verticalGap(AppSpacing.lg),
        for (var i = 0; i < state.importRows.length; i++) ...[
          ImportRowTile(
            row: state.importRows[i],
            report: reports.length == state.importRows.length
                ? reports[i]
                : null,
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
        AppSpacing.verticalGap(AppSpacing.md),
        if (status == ImportStatus.idle)
          SizedBox(
            height: AppDimensions.primaryActionHeight,
            child: FilledButton(
              onPressed: cubit.runImportDryRun,
              child: Text(l10n.examOfficeImportRunDry),
            ),
          ),
        if (status == ImportStatus.dryRun) ...[
          SizedBox(
            height: AppDimensions.primaryActionHeight,
            child: FilledButton(
              onPressed: importable == 0 ? null : cubit.commitImport,
              child: Text(l10n.examOfficeImportCommit(importable)),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          TextButton(
            onPressed: cubit.resetImport,
            child: Text(l10n.examOfficeImportStartOver),
          ),
        ],
        if (status == ImportStatus.imported)
          OutlinedButton(
            onPressed: () => context.goNamed(Routes.examOfficeIncidentsName),
            child: Text(l10n.examOfficeImportBackToIncidents),
          ),
      ],
    );
  }
}
