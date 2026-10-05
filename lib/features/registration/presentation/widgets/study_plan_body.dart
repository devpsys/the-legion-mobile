import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/registration_state.dart';
import '../models/registration_models.dart';

/// Scrollable study-plan tab once the ledger is ready.
class StudyPlanBody extends StatelessWidget {
  const StudyPlanBody({required this.state, super.key});

  final RegistrationState state;

  @override
  Widget build(BuildContext context) {
    final student = state.student;
    final plan = state.studyPlan;
    if (student == null || plan == null) return const SizedBox.shrink();

    final l10n = context.l10n;
    final theme = context.theme;
    final dateFormat = AppDateFormats.medium(l10n.localeName);

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SurfaceCard(
                borderRadius: AppRadii.blockRadius,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.studyPlanUndergraduate,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: AppTextStyles.trackingCaps,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.sm),
                    Text(student.name, style: theme.textTheme.headlineSmall),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      student.programme,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    StatusTag(
                      label: l10n.studyPlanActiveStatus,
                      tone: AppTone.success,
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    Text(
                      l10n.studyPlanSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              StudyPlanMetricsCard(plan: plan),
              if (plan.warnings.isNotEmpty) ...[
                AppSpacing.verticalGap(AppSpacing.xl),
                SectionHeader(title: l10n.studyPlanWorthKnowing),
                AppSpacing.verticalGap(AppSpacing.md),
                for (var i = 0; i < plan.warnings.length; i++) ...[
                  if (i > 0) AppSpacing.verticalGap(AppSpacing.md),
                  ToneCallout(
                    tone: AppTone.warning,
                    icon: Icons.warning_amber_outlined,
                    title: plan.warnings[i].title,
                    body: plan.warnings[i].detail,
                  ),
                ],
              ],
              AppSpacing.verticalGap(AppSpacing.xl),
              SectionHeader(title: l10n.studyPlanAdviserSaid),
              AppSpacing.verticalGap(AppSpacing.md),
              SurfaceCard(
                borderRadius: AppRadii.blockRadius,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.adviserNote,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    Text(
                      l10n.studyPlanAdviserByline(
                        dateFormat.format(plan.adviserNotedOn),
                        plan.adviserName,
                      ),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              SectionHeader(title: l10n.studyPlanTermByTerm),
              AppSpacing.verticalGap(AppSpacing.md),
              for (var i = 0; i < plan.terms.length; i++) ...[
                if (i > 0) AppSpacing.verticalGap(AppSpacing.md),
                PlannedTermCard(
                  term: plan.terms[i],
                  maximumUnits: state.maximumUnits,
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              OutlinedButton(
                onPressed: () =>
                    context.showMessage(context.l10n.studyPlanComingSoon),
                child: Text(l10n.studyPlanAddToPlan),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              SectionHeader(title: l10n.studyPlanDegreeAsks),
              AppSpacing.verticalGap(AppSpacing.md),
              SurfaceCard(
                borderRadius: AppRadii.blockRadius,
                child: Column(
                  children: [
                    for (var i = 0; i < plan.auditRows.length; i++) ...[
                      if (i > 0) ...[
                        AppSpacing.verticalGap(AppSpacing.sm),
                        const Divider(),
                        AppSpacing.verticalGap(AppSpacing.sm),
                      ],
                      DegreeAuditRowTile(row: plan.auditRows[i]),
                    ],
                  ],
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              ToneCallout(
                tone: AppTone.info,
                icon: Icons.info_outline,
                title: l10n.studyPlanHowThisWorks,
                body: l10n.studyPlanHowThisWorksBody,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Units passed / planned / award / still-to-pass metrics as a 2×2 grid.
class StudyPlanMetricsCard extends StatelessWidget {
  const StudyPlanMetricsCard({required this.plan, super.key});

  final StudyPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tiles = [
      StudyPlanMetricTile(
        label: l10n.studyPlanUnitsPassed,
        value: '${plan.unitsPassed}',
        isCode: true,
      ),
      StudyPlanMetricTile(
        label: l10n.studyPlanUnitsPlanned,
        value: '${plan.unitsPlanned}',
        isCode: true,
      ),
      StudyPlanMetricTile(
        label: l10n.studyPlanAwardUnits,
        value: '${plan.awardUnits}',
        isCode: true,
      ),
      StudyPlanMetricTile(
        label: l10n.studyPlanStillToPass,
        value: l10n.studyPlanStillToPassValue(plan.coursesStillToPass),
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: tiles[0]),
            AppSpacing.horizontalGap(AppSpacing.md),
            Expanded(child: tiles[1]),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        Row(
          children: [
            Expanded(child: tiles[2]),
            AppSpacing.horizontalGap(AppSpacing.md),
            Expanded(child: tiles[3]),
          ],
        ),
      ],
    );
  }
}

/// One compact metric pod on the study plan.
class StudyPlanMetricTile extends StatelessWidget {
  const StudyPlanMetricTile({
    required this.label,
    required this.value,
    this.isCode = false,
    super.key,
  });

  final String label;
  final String value;
  final bool isCode;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final valueStyle = isCode
        ? AppTextStyles.tabular(
            AppTextStyles.codeMedium.copyWith(fontWeight: AppTextStyles.bold),
          )
        : theme.textTheme.titleMedium?.copyWith(fontWeight: AppTextStyles.bold);

    return SurfaceCard(
      borderRadius: AppRadii.blockRadius,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: valueStyle,
          ),
        ],
      ),
    );
  }
}

/// One planned term block.
class PlannedTermCard extends StatelessWidget {
  const PlannedTermCard({
    required this.term,
    required this.maximumUnits,
    super.key,
  });

  final PlannedTerm term;
  final int maximumUnits;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return SurfaceCard(
      borderRadius: AppRadii.blockRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(term.label, style: theme.textTheme.titleMedium),
              ),
              if (term.isCurrent)
                StatusTag(label: term.eyebrow, tone: AppTone.info)
              else
                Text(
                  term.eyebrow,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.studyPlanTermUnits(maximumUnits, term.units),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (term.note case final note?) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              note,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTone.warning.foreground(theme.brightness),
              ),
            ),
          ],
          AppSpacing.verticalGap(AppSpacing.md),
          for (var i = 0; i < term.courses.length; i++) ...[
            if (i > 0) AppSpacing.verticalGap(AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${term.courses[i].code} · ${term.courses[i].title}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  '${term.courses[i].units}',
                  style: AppTextStyles.codeMedium,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// One degree-audit row.
class DegreeAuditRowTile extends StatelessWidget {
  const DegreeAuditRowTile({required this.row, super.key});

  final DegreeAuditRow row;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Container(
          width: AppDimensions.iconTileSmall,
          height: AppDimensions.iconTileSmall,
          decoration: BoxDecoration(
            color: row.isComplete
                ? AppTone.success.surface(theme.brightness)
                : theme.colorScheme.surfaceContainerHigh,
            borderRadius: AppRadii.chipRadius,
          ),
          alignment: Alignment.center,
          child: Icon(
            row.isComplete ? Icons.check : Icons.radio_button_unchecked,
            size: AppDimensions.iconSmall,
            color: row.isComplete
                ? AppTone.success.foreground(theme.brightness)
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(row.label, style: theme.textTheme.titleSmall),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                row.detail,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
