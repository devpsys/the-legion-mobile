import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/application_detail_models.dart';
import 'section_surface.dart';
import 'status_tag.dart';

/// The localized name of what a rejection criterion measures.
String rejectionCriterionLabel(
  AppLocalizations l10n,
  RejectionCriterionKind kind,
) => switch (kind) {
  RejectionCriterionKind.utme => l10n.admissionsCriterionUtme,
  RejectionCriterionKind.olevelEnglish => l10n.admissionsCriterionOlevelEnglish,
  RejectionCriterionKind.directEntry => l10n.admissionsCriterionDirectEntry,
};

/// The localized label of how the candidate fared on one criterion.
String rejectionOutcomeLabel(AppLocalizations l10n, RejectionOutcome outcome) =>
    switch (outcome) {
      RejectionOutcome.met => l10n.admissionsOutcomeMet,
      RejectionOutcome.belowCutoff => l10n.admissionsOutcomeBelowCutoff,
      RejectionOutcome.deficit => l10n.admissionsOutcomeDeficit,
      RejectionOutcome.incomplete => l10n.admissionsOutcomeIncomplete,
    };

/// The departmental audit under a refusal: each thing measured, what the
/// candidate put forward, and what the department required.
///
/// The figures are the point. A refusal with no reason reads as a verdict on
/// the candidate; one that shows 242 against 260 reads as a gap, and a gap can
/// be closed in the next cycle.
class ApplicationRejectionAuditCard extends StatelessWidget {
  const ApplicationRejectionAuditCard({required this.criteria, super.key});

  final List<RejectionCriterion> criteria;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.rule,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.admissionsAuditTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              // The caption sits on the title row, trailing, as a caption on
              // a table does: it qualifies the figures below, not the title.
              Text(
                l10n.admissionsAuditCaption,
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          for (final (index, criterion) in criteria.indexed) ...[
            if (index > 0) AppSpacing.verticalGap(AppSpacing.sm),
            RejectionCriterionRow(criterion: criterion),
          ],
        ],
      ),
    );
  }
}

/// One criterion: its name, how it came out, and the evidence.
///
/// A score on a scale gets a bar, because "242 of 400" is easier to feel as a
/// length against the line than as two numbers. A criterion that is not a
/// number quotes the committee's own sentence instead.
class RejectionCriterionRow extends StatelessWidget {
  const RejectionCriterionRow({required this.criterion, super.key});

  final RejectionCriterion criterion;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tone = criterion.outcome.tone;
    final toneColor = tone.foreground(theme.brightness);
    final submitted = criterion.submitted;
    final required = criterion.required;
    final progress = criterion.progress;
    final note = criterion.note;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppColors.subtle(theme.brightness),
        borderRadius: AppRadii.blockRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  rejectionCriterionLabel(l10n, criterion.kind),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              // The portal's one status pill, in sentence case like every
              // other status it draws.
              StatusTag(
                label: rejectionOutcomeLabel(l10n, criterion.outcome),
                tone: tone,
              ),
            ],
          ),
          if (submitted != null || required != null) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xs,
              children: [
                if (submitted != null)
                  RejectionFigure(
                    label: l10n.admissionsAuditSubmitted,
                    value: submitted,
                    color: toneColor,
                  ),
                if (required != null)
                  RejectionFigure(
                    label: l10n.admissionsAuditRequired,
                    value: required,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ],
          if (progress != null) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            LinearProgressIndicator(
              value: progress,
              minHeight: AppDimensions.meterHeight,
              color: toneColor,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              borderRadius: AppRadii.chipRadius,
            ),
          ],
          if (note != null) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              note,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A captioned figure: a muted caption over the value, in the mono face so two
/// of them line up.
class RejectionFigure extends StatelessWidget {
  const RejectionFigure({
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  final String label;
  final String value;

  /// The figure's colour: the outcome's tone for what was submitted, the brand
  /// colour for what was required.
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.codeSmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          value,
          style: AppTextStyles.codeMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.semiBold,
          ),
        ),
      ],
    );
  }
}
