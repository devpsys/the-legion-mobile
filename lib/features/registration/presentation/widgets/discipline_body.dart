import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/registration_cubit.dart';
import '../bloc/registration_state.dart';
import '../models/registration_models.dart';
import 'discipline_case_card.dart';
import 'discipline_sanction_tile.dart';
import 'registration_card.dart';
import 'registration_chrome.dart';
import 'registration_labels.dart';

/// Scrollable body of the Disciplinary matters tab.
class DisciplineBody extends StatelessWidget {
  const DisciplineBody({
    required this.state,
    required this.cubit,
    super.key,
  });

  final RegistrationState state;
  final RegistrationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final student = state.student;
    final record = state.discipline;
    if (student == null || record == null) {
      return const SizedBox.shrink();
    }

    final theme = context.theme;
    final l10n = context.l10n;
    final cases = record.cases;
    final sanctions = record.sanctions;

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
              const DisciplinePageHeader(),
              AppSpacing.verticalGap(AppSpacing.md),
              DisciplineIdentityBanner(
                student: student,
                standing: record.standing,
              ),
              if (!record.standing.isInGoodStanding) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                ToneCallout(
                  tone: AppTone.danger,
                  icon: Icons.lock_outline,
                  title: RegistrationLabels.studentStanding(
                    l10n,
                    record.standing,
                  ),
                  body: l10n.disciplineSuspendedBanner,
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.disciplineSubtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(
                title: l10n.disciplineCasesTitle,
                countLabel: l10n.disciplineCasesCount(cases.length),
                trailing: Text(
                  l10n.disciplineCasesSortedNewest,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (cases.isEmpty)
                ToneCallout(
                  tone: AppTone.success,
                  icon: Icons.verified_user_outlined,
                  title: l10n.disciplineEmptyTitle,
                  body: l10n.disciplineEmptyBody,
                )
              else
                RegistrationCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < cases.length; i++) ...[
                        if (i > 0)
                          Divider(
                            height: 1,
                            color: theme.colorScheme.outlineVariant,
                          ),
                        DisciplineCaseCard(
                          item: cases[i],
                          onOpen: () => context.goNamed(
                            Routes.registrationDisciplineCaseName,
                            pathParameters: {
                              Routes.registrationDisciplineCaseIdParam:
                                  cases[i].id,
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              if (sanctions.isNotEmpty) ...[
                AppSpacing.verticalGap(AppSpacing.lg),
                RegistrationSectionHeader(
                  title: l10n.disciplineSanctionsTitle,
                  countLabel: l10n.disciplineSanctionsCount(sanctions.length),
                  trailing: Text(
                    l10n.disciplineSanctionsActiveCount(
                      record.activeSanctionCount,
                    ),
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                RegistrationCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < sanctions.length; i++) ...[
                        if (i > 0)
                          Divider(
                            height: 1,
                            color: theme.colorScheme.outlineVariant,
                          ),
                        DisciplineSanctionTile(
                          sanction: sanctions[i],
                          caseReference: record
                                  .caseById(sanctions[i].caseId)
                                  ?.reference ??
                              sanctions[i].caseId,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationAboutCard(
                title: l10n.disciplineAboutTitle,
                body: l10n.disciplineAboutBody,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Breadcrumb and title for the Discipline tab.
class DisciplinePageHeader extends StatelessWidget {
  const DisciplinePageHeader({super.key});

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
            Text(
              l10n.disciplineBreadcrumbRecord,
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
                l10n.disciplineBreadcrumb,
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
        Text(l10n.disciplineTitle, style: theme.textTheme.headlineMedium),
      ],
    );
  }
}

/// Banded student identity strip for the Discipline tab.
class DisciplineIdentityBanner extends StatelessWidget {
  const DisciplineIdentityBanner({
    required this.student,
    required this.standing,
    super.key,
  });

  final RegistrationStudent student;
  final StudentStanding standing;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh.withValues(
                alpha: 0.3,
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    student.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
                StatusTag(
                  label: RegistrationLabels.studentStanding(l10n, standing),
                  tone: standing.tone,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              l10n.registrationMatricLevel(
                l10n.registrationLevel(student.level),
                student.matricNumber,
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Text(
              student.programme,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
