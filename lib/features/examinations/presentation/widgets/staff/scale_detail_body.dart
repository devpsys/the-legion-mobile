import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_block.dart';
import 'scale_ruler.dart';

/// One grading scale: its bands on a ruler and in a table, with a callout when
/// the lowest band does not start at 0 and marks near the bottom go ungraded.
class ScaleDetailBody extends StatelessWidget {
  const ScaleDetailBody({required this.scale, super.key});

  final GradingScale scale;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (scale.hasGap) ...[
          ToneCallout(
            tone: AppTone.danger,
            icon: Icons.rule,
            title: l10n.examOfficeScaleGapTitle,
            body: l10n.examOfficeScaleGapBody(
              scale.lowestStart,
              scale.unmappedTop,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
        ],
        ExamOfficeBlock(
          title: scale.name,
          description: l10n.examOfficeScaleAppliesTo(scale.appliesTo),
          children: [
            ScaleRuler(scale: scale),
            AppSpacing.verticalGap(AppSpacing.xs),
            ScaleRulerLabels(scale: scale),
            AppSpacing.verticalGap(AppSpacing.md),
            for (final band in scale.bands)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    SizedBox(
                      width: AppDimensions.iconTile,
                      child: Text(
                        band.letter,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                    ),
                    Expanded(child: Text(l10n.examOfficeBandFrom(band.from))),
                    Text(
                      l10n.examOfficeBandPoints(band.points.toStringAsFixed(1)),
                      style: AppTextStyles.tabular(theme.textTheme.bodySmall!),
                    ),
                    if (!band.isPass) ...[
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      StatusTag(
                        label: l10n.examOfficeBandFail,
                        tone: AppTone.warning,
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
        if (scale.degreeClasses.isNotEmpty) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          ExamOfficeBlock(
            title: l10n.examOfficeDegreeClassesTitle,
            children: [
              for (final band in scale.degreeClasses)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(child: Text(band.name)),
                      Text(
                        l10n.examOfficeDegreeFrom(band.from.toStringAsFixed(2)),
                        style: AppTextStyles.tabular(
                          theme.textTheme.bodySmall!,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
