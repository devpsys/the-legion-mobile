import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../models/examinations_models.dart';
import 'classification_scale.dart';
import 'examinations_labels.dart';

/// "Where you stand": the CGPA against the scale, the senate's thresholds and,
/// when it matters, what to do about it.
class StandingCard extends StatelessWidget {
  const StandingCard({required this.record, super.key});

  final ResultsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tone = ExaminationsLabels.standingTone(record.standing);
    final classification = record.classification;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.examStandingTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              StatusTag(
                label: ExaminationsLabels.standing(l10n, record.standing),
                tone: tone,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                record.cgpa.toStringAsFixed(2),
                style: AppTextStyles.tabular(
                  theme.textTheme.headlineLarge!.copyWith(
                    color: tone.foreground(theme.brightness),
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Text(
                l10n.examStandingOutOf(
                  ResultsRecord.maxCgpa.toStringAsFixed(2),
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          StandingGauge(cgpa: record.cgpa, tone: tone),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.examStandingThresholds(
              ResultsRecord.probationCgpa.toStringAsFixed(2),
              ResultsRecord.withdrawalCgpa.toStringAsFixed(2),
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.examStandingUnits(record.unitsPassed, record.unitsTaken),
            style: theme.textTheme.bodyMedium,
          ),
          if (classification != null) ...[
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              l10n.examStandingOnCourse(classification.name),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ],
          if (record.standing != StandingKind.good) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            StandingAdvisory(record: record),
          ],
          AppSpacing.verticalGap(AppSpacing.lg),
          ClassificationScale(record: record),
        ],
      ),
    );
  }
}

/// A track from 0 to the top of the scale, filled to the CGPA, with the two
/// senate thresholds ticked on it.
class StandingGauge extends StatelessWidget {
  const StandingGauge({required this.cgpa, required this.tone, super.key});

  final double cgpa;
  final AppTone tone;

  static double _along(double value) =>
      (value / ResultsRecord.maxCgpa).clamp(0, 1).toDouble();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: AppDimensions.trackHeight,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: AppRadii.chipRadius,
          ),
        ),
        FractionallySizedBox(
          widthFactor: _along(cgpa),
          child: Container(
            height: AppDimensions.trackHeight,
            decoration: BoxDecoration(
              color: tone.foreground(theme.brightness),
              borderRadius: AppRadii.chipRadius,
            ),
          ),
        ),
        for (final threshold in [
          ResultsRecord.withdrawalCgpa,
          ResultsRecord.probationCgpa,
        ])
          Positioned.fill(
            child: Align(
              alignment: Alignment(_along(threshold) * 2 - 1, 0),
              child: Container(
                width: AppDimensions.focusRingWidth,
                height: AppDimensions.trackHeight,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
      ],
    );
  }
}

/// What a probation or withdrawal standing asks of the student, and who to
/// speak to.
class StandingAdvisory extends StatelessWidget {
  const StandingAdvisory({required this.record, this.student, super.key});

  final ResultsRecord record;
  final ExamStudent? student;

  @override
  Widget build(BuildContext context) {
    if (record.standing == StandingKind.probation) {
      return ProbationAdvisory(record: record, student: student);
    }

    final l10n = context.l10n;
    final adviser = record.adviser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ToneCallout(
          tone: AppTone.danger,
          icon: Icons.error_outline,
          title: l10n.examAdvisoryWithdrawalTitle,
          body: l10n.examAdvisoryWithdrawalBody,
        ),
        if (adviser != null) ...[
          AppSpacing.verticalGap(AppSpacing.sm),
          AdviserStrip(adviser: adviser, student: student),
        ],
      ],
    );
  }
}

/// The probation notice: the statute, what it means, and who to see.
class ProbationAdvisory extends StatelessWidget {
  const ProbationAdvisory({required this.record, this.student, super.key});

  final ResultsRecord record;
  final ExamStudent? student;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final warning = AppTone.warning.foreground(theme.brightness);
    final adviser = record.adviser;

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppTone.warning.surface(theme.brightness),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppTone.warning.border(theme.brightness)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppDimensions.iconLarge,
                height: AppDimensions.iconLarge,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: warning.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.priority_high,
                  size: AppDimensions.iconMedium,
                  color: warning,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.examAdvisoryProbationTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: warning,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.examAdvisoryStatute,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: warning,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.iconLarge + AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final point in [
                  l10n.examAdvisoryProbationContinue,
                  l10n.examAdvisoryProbationSemester,
                  l10n.examAdvisoryProbationFinal,
                ]) ...[
                  AdvisoryPoint(text: point, color: warning),
                  AppSpacing.verticalGap(AppSpacing.sm),
                ],
              ],
            ),
          ),
          if (adviser != null) AdviserStrip(adviser: adviser, student: student),
          AppSpacing.verticalGap(AppSpacing.sm),
          FilledButton.icon(
            onPressed: () => context.showMessage(l10n.commonComingSoon),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(
                AppDimensions.primaryActionHeight,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.blockRadius,
              ),
            ),
            icon: const Icon(Icons.edit_calendar_outlined),
            label: Text(l10n.examAdvisoryBook),
          ),
        ],
      ),
    );
  }
}

/// One sentence of the probation notice, marked with a dot.
class AdvisoryPoint extends StatelessWidget {
  const AdvisoryPoint({required this.text, required this.color, super.key});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Container(
            width: AppDimensions.indicator,
            height: AppDimensions.indicator,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: color,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

/// The level adviser named on a standing notice, and where to find them.
class AdviserStrip extends StatelessWidget {
  const AdviserStrip({required this.adviser, this.student, super.key});

  final LevelAdviser adviser;
  final ExamStudent? student;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final programme = student?.programme;
    final role = programme == null
        ? l10n.examAdvisoryAdviser(adviser.office)
        : l10n.examAdvisoryAdviserRole(programme);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.blockRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDimensions.iconLarge,
            height: AppDimensions.iconLarge,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.badge_outlined,
              size: AppDimensions.iconSmall,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adviser.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (programme != null) ...[
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    adviser.office,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTone.warning.foreground(theme.brightness),
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
