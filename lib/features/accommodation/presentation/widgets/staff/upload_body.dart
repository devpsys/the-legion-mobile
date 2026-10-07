import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/labelled_value_row.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import '../../models/staff/housing_models.dart';
import 'housing_labels.dart';
import 'housing_section.dart';

/// Allocates beds from a spreadsheet: the form, then one of three outcomes — a
/// header problem, a list of row problems, or the batch that was created.
class UploadBody extends StatelessWidget {
  const UploadBody({required this.state, super.key});

  final HousingState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<HousingCubit>();
    final upload = state.upload;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: l10n.housingUploadFormTitle,
          description: l10n.housingUploadFormBody,
          children: [
            LabelledValueRow(
              label: l10n.housingUploadColumns,
              value: l10n.housingUploadColumnList,
              isCode: true,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            for (final sample in UploadSample.values) ...[
              OutlinedButton.icon(
                onPressed: () => cubit.uploadSample(sample),
                icon: const Icon(Icons.description_outlined),
                label: Text(switch (sample) {
                  UploadSample.valid => l10n.housingUploadSampleValid,
                  UploadSample.badHeader => l10n.housingUploadSampleHeader,
                  UploadSample.badRows => l10n.housingUploadSampleRows,
                }),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
            ],
          ],
        ),
        if (upload.status != UploadStatus.none) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          switch (upload.status) {
            UploadStatus.headerError => UploadHeaderError(upload: upload),
            UploadStatus.rowErrors => UploadRowErrors(upload: upload),
            UploadStatus.success => UploadSuccess(upload: upload),
            UploadStatus.none => const SizedBox.shrink(),
          },
          AppSpacing.verticalGap(AppSpacing.md),
          TextButton(
            onPressed: cubit.resetUpload,
            child: Text(l10n.housingUploadAnother),
          ),
        ],
      ],
    );
  }
}

/// The sheet is missing a required column, so nothing was read.
class UploadHeaderError extends StatelessWidget {
  const UploadHeaderError({required this.upload, super.key});

  final UploadOutcome upload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ToneCallout(
      tone: AppTone.danger,
      icon: Icons.error_outline,
      title: l10n.housingUploadHeaderTitle(upload.fileName),
      body: l10n.housingUploadHeaderBody(upload.missingColumn),
    );
  }
}

/// Rows the sheet got wrong; none of the sheet was applied.
class UploadRowErrors extends StatelessWidget {
  const UploadRowErrors({required this.upload, super.key});

  final UploadOutcome upload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ToneCallout(
          tone: AppTone.warning,
          icon: Icons.rule,
          title: l10n.housingUploadRowsTitle(
            upload.issues.length,
            upload.rowCount,
          ),
          body: l10n.housingUploadRowsBody,
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        for (final issue in upload.issues) ...[
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.housingUploadRow(issue.row),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  HousingLabels.uploadIssue(l10n, issue.kind),
                  style: theme.textTheme.bodyMedium,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  issue.value,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
      ],
    );
  }
}

/// Every row was applied as one batch.
class UploadSuccess extends StatelessWidget {
  const UploadSuccess({required this.upload, super.key});

  final UploadOutcome upload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingSection(
      title: l10n.housingUploadSuccessTitle,
      children: [
        ToneCallout(
          tone: AppTone.success,
          icon: Icons.check_circle_outline,
          body: l10n.housingUploadSuccessBody(upload.rowCount),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        LabelledValueRow(
          label: l10n.housingUploadBatch,
          value: upload.batchReference,
          isCode: true,
        ),
        LabelledValueRow(
          label: l10n.housingUploadFile,
          value: upload.fileName,
          isCode: true,
        ),
      ],
    );
  }
}
