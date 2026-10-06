import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/widgets/responsive_content.dart';
import '../../../../../../core/widgets/status_tag.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../models/staff/approvals_models.dart';
import '../../../widgets/registration_card.dart';
import '../../../widgets/registration_chrome.dart';
import '../staff_chrome.dart';
import '../staff_reason_field.dart';
import '../staff_student_identity_card.dart';

/// Scrollable body of the study-plan advising screen.
class StudyPlanAdvisingBody extends StatelessWidget {
  const StudyPlanAdvisingBody({
    required this.advice,
    required this.onAdviceChanged,
    required this.onSave,
    super.key,
  });

  final StudyPlanAdvice advice;
  final ValueChanged<String> onAdviceChanged;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final progress = advice.awardThreshold == 0
        ? 0.0
        : (advice.unitsPassed / advice.awardThreshold).clamp(0.0, 1.0);

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
              StaffPageHeader(
                breadcrumb: [
                  l10n.staffApprovalsBreadcrumbRoot,
                  l10n.staffApprovalsBreadcrumb,
                  advice.name,
                ],
                title: l10n.staffApprovalsAdvisingTitle,
                subtitle: l10n.staffApprovalsAdvisingSubtitle,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              StaffStudentIdentityCard(
                name: advice.name,
                matricNumber: advice.matricNumber,
                programme: advice.programme,
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              RegistrationCard(
                clip: false,
                padding: AppSpacing.card,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.staffApprovalsAdvisingProgressTitle.toUpperCase(),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: AppTextStyles.trackingCaps,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.sm),
                    Text(
                      l10n.staffApprovalsAdvisingProgressValue(
                        advice.unitsPassed,
                        advice.awardThreshold,
                      ),
                      style: AppTextStyles.tabular(
                        theme.textTheme.titleMedium!,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.sm),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: AppDimensions.trackHeight,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.trackHeight,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    Text(
                      l10n.staffApprovalsAdvisingPlanned(
                        advice.unitsPlanned,
                        advice.coursesStillToPass,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
              if (advice.warnings.isNotEmpty) ...[
                AppSpacing.verticalGap(AppSpacing.lg),
                RegistrationSectionHeader(
                  title: l10n.staffApprovalsAdvisingWarningsTitle,
                  countLabel: l10n.staffApprovalsAdvisingWarningsCount(
                    advice.warnings.length,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                for (final warning in advice.warnings) ...[
                  ToneCallout(
                    tone: AppTone.warning,
                    icon: Icons.warning_amber_outlined,
                    body: warning,
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                ],
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(
                title: l10n.staffApprovalsAdvisingTermsTitle,
                countLabel: l10n.staffApprovalsAdvisingTermsCount(
                  advice.terms.length,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              RegistrationCard(
                child: Column(
                  children: [
                    for (var i = 0; i < advice.terms.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          color: theme.colorScheme.outlineVariant,
                        ),
                      StudyPlanTermAdviceTile(term: advice.terms[i]),
                    ],
                  ],
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationCard(
                clip: false,
                padding: AppSpacing.card,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StaffReasonField(
                      label: l10n.staffApprovalsAdviceLabel,
                      hint: l10n.staffApprovalsAdviceHint,
                      initialValue: advice.adviceDraft,
                      onChanged: onAdviceChanged,
                      minLines: 3,
                      maxLines: 6,
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    FilledButton.icon(
                      onPressed: onSave,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                          AppDimensions.primaryActionHeight,
                        ),
                      ),
                      icon: const Icon(
                        Icons.send_outlined,
                        size: AppDimensions.iconDense,
                      ),
                      label: Text(l10n.staffApprovalsAdviceSave),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One planned term on the advising screen, flagged when over the ceiling.
class StudyPlanTermAdviceTile extends StatelessWidget {
  const StudyPlanTermAdviceTile({required this.term, super.key});

  final StudyPlanTermAdvice term;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  term.label,
                  style: AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              StatusTag(
                label: l10n.staffApprovalsAdvisingTermUnits(
                  term.plannedUnits,
                  term.maximumUnits,
                ),
                tone: term.overCeiling ? AppTone.danger : AppTone.neutral,
                icon: term.overCeiling ? Icons.error_outline : null,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              for (final code in term.courseCodes)
                StatusTag(label: code, tone: AppTone.info),
            ],
          ),
          if (term.overCeiling) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.staffApprovalsAdvisingOverCeiling(term.maximumUnits),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTone.danger.foreground(theme.brightness),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
