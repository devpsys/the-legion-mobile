import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/emphasised_text.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/registration_state.dart';
import '../models/registration_models.dart';
import 'registration_card.dart';

/// Structured-audit study plan body matching the ledger layout design.
class StudyPlanBody extends StatelessWidget {
  const StudyPlanBody({required this.state, super.key});

  final RegistrationState state;

  @override
  Widget build(BuildContext context) {
    final student = state.student;
    final plan = state.studyPlan;
    final window = state.window;
    if (student == null || plan == null || window == null) {
      return const SizedBox.shrink();
    }

    final l10n = context.l10n;
    final theme = context.theme;
    final dateFormat = AppDateFormats.medium(l10n.localeName);

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            AppSpacing.md,
            0,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StudyPlanPageHeader(student: student),
              AppSpacing.verticalGap(AppSpacing.md),
              _IdentityBanner(student: student, plan: plan),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.studyPlanSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              _MetricsStrip(plan: plan),
              AppSpacing.verticalGap(AppSpacing.sm),
              _MetricCaptions(plan: plan),
              if (plan.warnings.isNotEmpty) ...[
                AppSpacing.verticalGap(AppSpacing.lg),
                _WorthKnowingSection(plan: plan),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              _AdviserCard(
                plan: plan,
                datedLabel: dateFormat.format(plan.adviserNotedOn),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              _TermsSection(
                terms: plan.terms,
                maximumUnits: state.maximumUnits,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              _DegreeAsksSection(rows: plan.auditRows),
              AppSpacing.verticalGap(AppSpacing.lg),
              _PlanCourseForm(plan: plan),
              AppSpacing.verticalGap(AppSpacing.lg),
              _HowThisWorks(plan: plan),
            ],
          ),
        ),
      ),
    );
  }
}

/// Breadcrumb, title, and matric · level line.
class _StudyPlanPageHeader extends StatelessWidget {
  const _StudyPlanPageHeader({required this.student});

  final RegistrationStudent student;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              l10n.registrationBreadcrumbStudent,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              size: AppDimensions.iconMicro,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Flexible(
              child: Text(
                l10n.studyPlanTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(l10n.studyPlanTitle, style: theme.textTheme.headlineMedium),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.studyPlanMatricLevelShort(student.matricNumber, student.level),
          style: AppTextStyles.codeSmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _IdentityBanner extends StatelessWidget {
  const _IdentityBanner({required this.student, required this.plan});

  final RegistrationStudent student;
  final StudyPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            color: theme.colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.studyPlanUndergraduate.toUpperCase(),
                    style: AppTextStyles.codeSmall.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: theme.colorScheme.primary,
                      letterSpacing: AppTextStyles.trackingCaps,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: AppRadii.chipRadius,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Text(
                    l10n.studyPlanActiveStatus,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  student.programme,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
                if (plan.programmeConclusion.isNotEmpty) ...[
                  AppSpacing.verticalGap(AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLowest,
                      borderRadius: AppRadii.elementRadius,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.studyPlanProgrammeConclusion,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Text(
                          plan.programmeConclusion,
                          style: AppTextStyles.codeSmall.copyWith(
                            fontWeight: AppTextStyles.semiBold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
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

class _MetricsStrip extends StatelessWidget {
  const _MetricsStrip({required this.plan});

  final StudyPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    Widget cell({
      required String label,
      required String value,
      required String hint,
      Color? valueColor,
    }) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Column(
            children: [
              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: AppTextStyles.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              Text(
                value,
                style: AppTextStyles.codeLarge.copyWith(
                  fontWeight: AppTextStyles.bold,
                  color: valueColor ?? theme.colorScheme.primary,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                hint,
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RegistrationCard(
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            cell(
              label: l10n.studyPlanUnitsPassed,
              value: '${plan.unitsPassed}',
              hint: l10n.studyPlanUnitsEarnedHint,
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            cell(
              label: l10n.studyPlanUnitsPlanned,
              value: '${plan.unitsPlanned}',
              hint: l10n.studyPlanUnitsCurrentTermHint,
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            cell(
              label: l10n.studyPlanAwardUnits,
              value: '${plan.awardUnits}',
              hint: l10n.studyPlanUnitsHint,
              valueColor: theme.colorScheme.onSurface,
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant,
            ),
            cell(
              label: l10n.studyPlanStillToPass,
              value: '${plan.coursesStillToPass}',
              hint: l10n.studyPlanCoursesHint,
              valueColor: AppTone.warning.foreground(theme.brightness),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCaptions extends StatelessWidget {
  const _MetricCaptions({required this.plan});

  final StudyPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    Widget caption(String text) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: AppRadii.elementRadius,
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        caption(l10n.studyPlanAwardCaption(plan.awardUnits)),
        AppSpacing.horizontalGap(AppSpacing.sm),
        caption(l10n.studyPlanStillToPassCaption(plan.coursesStillToPass)),
      ],
    );
  }
}

class _WorthKnowingSection extends StatelessWidget {
  const _WorthKnowingSection({required this.plan});

  final StudyPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final brightness = theme.brightness;
    final warnFg = AppTone.warning.foreground(brightness);
    final warnSurface = AppTone.warning.surface(brightness);

    return RegistrationCard(
      borderColor: warnFg.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            color: warnSurface.withValues(alpha: 0.45),
            child: Row(
              children: [
                Icon(
                  Icons.warning,
                  size: AppDimensions.iconDense,
                  color: warnFg,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.studyPlanWorthKnowing.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: AppTextStyles.bold,
                      letterSpacing: AppTextStyles.trackingCaps,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: warnSurface,
                    borderRadius: AppRadii.chipRadius,
                  ),
                  child: Text(
                    l10n.studyPlanAdvisoriesCount(plan.warnings.length),
                    style: AppTextStyles.codeSmall.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (plan.warningsIntro.isNotEmpty) ...[
                  Text(
                    plan.warningsIntro,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: AppTextStyles.relaxedLineHeight,
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.md),
                ],
                for (var i = 0; i < plan.warnings.length; i++) ...[
                  if (i > 0) AppSpacing.verticalGap(AppSpacing.sm),
                  _AdvisoryCard(
                    index: i + 1,
                    warning: plan.warnings[i],
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

class _AdvisoryCard extends StatelessWidget {
  const _AdvisoryCard({required this.index, required this.warning});

  final int index;
  final StudyPlanWarning warning;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final bodyStyle = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onSurface,
      height: AppTextStyles.relaxedLineHeight,
    );

    return RegistrationCard(
      color: theme.colorScheme.surfaceContainerLow,
      borderColor: theme.colorScheme.outlineVariant,
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.xl,
            height: AppSpacing.xl,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: AppTextStyles.codeSmall.copyWith(
                fontWeight: AppTextStyles.bold,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: EmphasisedText(
              warning.detail,
              style: bodyStyle,
              emphasisStyle: bodyStyle.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: AppTextStyles.bold,
              ),
              emphasis: warning.emphasis,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviserCard extends StatelessWidget {
  const _AdviserCard({required this.plan, required this.datedLabel});

  final StudyPlan plan;
  final String datedLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 6, color: theme.colorScheme.secondaryContainer),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: AppDimensions.iconSmall,
                          color: AppTone.warning.foreground(theme.brightness),
                        ),
                        AppSpacing.horizontalGap(AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.studyPlanAdviserSaid.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: AppTextStyles.bold,
                              letterSpacing: AppTextStyles.trackingCaps,
                            ),
                          ),
                        ),
                        Text(
                          datedLabel,
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow.withValues(
                          alpha: 0.6,
                        ),
                        borderRadius: AppRadii.elementRadius,
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Text(
                        '"${plan.adviserNote}"',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          height: AppTextStyles.relaxedLineHeight,
                        ),
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    Row(
                      children: [
                        Container(
                          width: AppDimensions.indicator,
                          height: AppDimensions.indicator,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        AppSpacing.horizontalGap(AppSpacing.sm),
                        Expanded(
                          child: Text(
                            plan.adviserName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: AppTextStyles.semiBold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        if (plan.adviserRole.isNotEmpty)
                          Text(
                            plan.adviserRole,
                            style: AppTextStyles.codeSmall.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.terms, required this.maximumUnits});

  final List<PlannedTerm> terms;
  final int maximumUnits;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: AppDimensions.iconDense,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.studyPlanTermByTerm,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.25,
                    ),
                    borderRadius: AppRadii.chipRadius,
                  ),
                  child: Text(
                    l10n.studyPlanTermsListed(terms.length),
                    style: AppTextStyles.codeSmall.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        for (var i = 0; i < terms.length; i++) ...[
          if (i > 0) AppSpacing.verticalGap(AppSpacing.md),
          _TermCard(term: terms[i], maximumUnits: maximumUnits),
        ],
      ],
    );
  }
}

class _TermCard extends StatelessWidget {
  const _TermCard({required this.term, required this.maximumUnits});

  final PlannedTerm term;
  final int maximumUnits;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final unitsLabel = l10n.studyPlanTermUnits(maximumUnits, term.units);
    final warnFg = AppTone.warning.foreground(theme.brightness);

    if (term.isCurrent && term.courses.isNotEmpty) {
      return RegistrationCard(
        borderColor: theme.colorScheme.primary.withValues(alpha: 0.4),
        borderWidth: 2,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              color: theme.colorScheme.surfaceContainerLow,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: AppRadii.tagRadius,
                    ),
                    child: Text(
                      l10n.studyPlanNowBadge.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      term.label,
                      style: AppTextStyles.codeMedium.copyWith(
                        fontWeight: AppTextStyles.semiBold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: AppRadii.tagRadius,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      unitsLabel,
                      style: AppTextStyles.codeSmall.copyWith(
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _TermCourseTable(courses: term.courses),
          ],
        ),
      );
    }

    if (term.overLimit) {
      return RegistrationCard(
        borderColor: warnFg.withValues(alpha: 0.35),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          term.label,
                          style: AppTextStyles.codeMedium.copyWith(
                            fontWeight: AppTextStyles.semiBold,
                          ),
                        ),
                        if (term.subtitle case final subtitle?) ...[
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppTone.warning.surface(theme.brightness),
                      borderRadius: AppRadii.tagRadius,
                      border: Border.all(color: warnFg.withValues(alpha: 0.35)),
                    ),
                    child: Text(
                      unitsLabel,
                      style: AppTextStyles.codeSmall.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (term.note case final note?)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                color: theme.colorScheme.surfaceContainerLow,
                child: Row(
                  children: [
                    Icon(
                      Icons.priority_high,
                      size: AppDimensions.iconSmall,
                      color: warnFg,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: Text(
                        note,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    return RegistrationCard(
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term.label,
                  style: AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
                if (term.subtitle case final subtitle?) ...[
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: AppRadii.tagRadius,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Text(
              unitsLabel,
              style: AppTextStyles.codeSmall.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermCourseTable extends StatelessWidget {
  const _TermCourseTable({required this.courses});

  final List<RegisteredCourse> courses;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          color: theme.colorScheme.surfaceContainerLowest,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  l10n.studyPlanLedgerCourse.toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  l10n.studyPlanLedgerTitle.toUpperCase(),
                  style: AppTextStyles.codeSmall.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  l10n.studyPlanLedgerUnits.toUpperCase(),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.codeSmall.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        for (var i = 0; i < courses.length; i++) ...[
          if (i > 0)
            Divider(height: 1, color: theme.colorScheme.surfaceContainerHigh),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    courses[i].code,
                    style: AppTextStyles.codeSmall.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    courses[i].title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    l10n.registrationCourseUnits(courses[i].units),
                    textAlign: TextAlign.right,
                    style: AppTextStyles.codeSmall.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _DegreeAsksSection extends StatelessWidget {
  const _DegreeAsksSection({required this.rows});

  final List<DegreeAuditRow> rows;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final completed = rows
        .where((r) => r.kind == DegreeAuditKind.completed)
        .toList();
    final current = rows.where((r) => r.kind == DegreeAuditKind.current);
    final electives = rows.where((r) => r.kind == DegreeAuditKind.electives);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.verified_outlined,
                      size: AppDimensions.iconDense,
                      color: theme.colorScheme.primary,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.studyPlanDegreeAsks,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.studyPlanDegreeAsksSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        if (completed.length >= 2)
          Row(
            children: [
              Expanded(child: _CompletedLevelCard(row: completed[0])),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(child: _CompletedLevelCard(row: completed[1])),
            ],
          )
        else
          for (final row in completed) ...[
            _CompletedLevelCard(row: row),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
        for (final row in current) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          _CurrentLevelCard(row: row),
        ],
        for (final row in electives) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          _ElectivesCard(row: row),
        ],
      ],
    );
  }
}

class _CompletedLevelCard extends StatelessWidget {
  const _CompletedLevelCard({required this.row});

  final DegreeAuditRow row;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  row.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Icon(
                Icons.check_circle,
                size: AppDimensions.iconSmall,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            row.detail,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: theme.colorScheme.surfaceContainerHigh),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: AppRadii.chipRadius,
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check,
                      size: AppDimensions.iconMicro,
                      color: theme.colorScheme.primary,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.xs),
                    Text(
                      l10n.studyPlanPassed,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentLevelCard extends StatelessWidget {
  const _CurrentLevelCard({required this.row});

  final DegreeAuditRow row;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            color: theme.colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: AppRadii.tagRadius,
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Text(
                    l10n.studyPlanCurrentLevel,
                    style: AppTextStyles.codeSmall.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                if (row.takingNow.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.2,
                      ),
                      borderRadius: AppRadii.elementRadius,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.25,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.takingNow.join(', '),
                            style: AppTextStyles.codeSmall.copyWith(
                              fontWeight: AppTextStyles.semiBold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.35),
                            borderRadius: AppRadii.chipRadius,
                          ),
                          child: Text(
                            l10n.studyPlanTakingNow.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                for (final code in row.stillToTake) ...[
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLowest,
                      borderRadius: AppRadii.elementRadius,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            code,
                            style: AppTextStyles.codeSmall.copyWith(
                              fontWeight: AppTextStyles.semiBold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHigh,
                            borderRadius: AppRadii.chipRadius,
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                          child: Text(
                            l10n.studyPlanStillToTake,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
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

class _ElectivesCard extends StatelessWidget {
  const _ElectivesCard({required this.row});

  final DegreeAuditRow row;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return RegistrationCard(
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
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
          if (row.progressLabel case final progress?)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: AppRadii.elementRadius,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Text(
                progress,
                style: AppTextStyles.codeSmall.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PlanCourseForm extends StatefulWidget {
  const _PlanCourseForm({required this.plan});

  final StudyPlan plan;

  @override
  State<_PlanCourseForm> createState() => _PlanCourseFormState();
}

class _PlanCourseFormState extends State<_PlanCourseForm> {
  String? _courseCode;
  String? _term;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final plan = widget.plan;
    final fieldStyle = AppTextStyles.codeSmall.copyWith(
      fontWeight: AppTextStyles.medium,
      color: theme.colorScheme.onSurface,
    );
    final hintStyle = AppTextStyles.codeSmall.copyWith(
      fontWeight: AppTextStyles.regular,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return RegistrationCard(
      clip: false,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: AppDimensions.iconDense,
                        color: theme.colorScheme.primary,
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Text(
                        l10n.studyPlanACourse.toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: AppTextStyles.bold,
                          letterSpacing: AppTextStyles.trackingCaps,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    l10n.studyPlanACourseSubtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.studyPlanCourseLabel,
            style: AppTextStyles.codeSmall.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          DropdownButtonFormField<String>(
            initialValue: _courseCode,
            isExpanded: true,
            isDense: true,
            style: fieldStyle,
            iconSize: AppDimensions.iconSmall,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: AppRadii.elementRadius),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            hint: Text(
              l10n.studyPlanSelectCourse,
              style: hintStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            items: [
              for (final option in plan.planOptions)
                DropdownMenuItem(
                  value: option.code,
                  child: Text(
                    option.label,
                    style: fieldStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            selectedItemBuilder: (context) => [
              for (final option in plan.planOptions)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    option.label,
                    style: fieldStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            onChanged: (value) => setState(() => _courseCode = value),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.studyPlanTargetTermLabel,
            style: AppTextStyles.codeSmall.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          DropdownButtonFormField<String>(
            initialValue: _term,
            isExpanded: true,
            isDense: true,
            style: fieldStyle,
            iconSize: AppDimensions.iconSmall,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: AppRadii.elementRadius),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            hint: Text(
              l10n.studyPlanSelectTerm,
              style: hintStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            items: [
              for (final term in plan.targetTerms)
                DropdownMenuItem(
                  value: term,
                  child: Text(
                    term,
                    style: fieldStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            selectedItemBuilder: (context) => [
              for (final term in plan.targetTerms)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    term,
                    style: fieldStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
            onChanged: (value) => setState(() => _term = value),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          FilledButton.icon(
            onPressed: () =>
                context.showMessage(context.l10n.studyPlanComingSoon),
            icon: const Icon(Icons.add),
            label: Text(l10n.studyPlanAddToPlan),
          ),
        ],
      ),
    );
  }
}

class _HowThisWorks extends StatelessWidget {
  const _HowThisWorks({required this.plan});

  final StudyPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      clip: false,
      color: theme.colorScheme.surfaceContainerHigh,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: AppDimensions.iconDense,
                    color: theme.colorScheme.primary,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Text(
                    l10n.studyPlanHowThisWorks.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: AppTextStyles.bold,
                      letterSpacing: AppTextStyles.trackingCaps,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.studyPlanHowThisWorksBody,
            style: theme.textTheme.bodySmall?.copyWith(
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          if (plan.howThisWorksSecondary.isNotEmpty) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              plan.howThisWorksSecondary,
              style: theme.textTheme.bodySmall?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
