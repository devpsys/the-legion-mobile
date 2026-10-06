import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/dates.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/widgets/labelled_value_row.dart';
import '../../../../../../core/widgets/responsive_content.dart';
import '../../../../../../core/widgets/status_tag.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../models/registration_models.dart';
import '../../../models/staff/registry_models.dart';
import '../../../widgets/registration_card.dart';
import '../../../widgets/registration_chrome.dart';
import '../../../widgets/registration_labels.dart';
import '../staff_chrome.dart';
import '../staff_labels.dart';
import '../staff_student_identity_card.dart';

/// Scrollable body of one student's registry record.
class StudentRecordBody extends StatelessWidget {
  const StudentRecordBody({required this.record, super.key});

  final RegistryStudentRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final dateFormat = AppDateFormats.long(l10n.localeName);

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
                  l10n.staffRegistryBreadcrumbRoot,
                  l10n.staffRegistryStudentsBreadcrumb,
                  record.name,
                ],
                title: l10n.staffRegistryRecordTitle,
                subtitle: l10n.staffRegistryRecordSubtitle,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              StaffStudentIdentityCard(
                name: record.name,
                matricNumber: record.matricNumber,
                level: record.level,
                programme: record.programme,
                trailing: StatusTag(
                  label: RegistrationLabels.studentStanding(
                    l10n,
                    record.standing,
                  ),
                  tone: StaffRegistrationLabels.standingTone(record.standing),
                ),
              ),
              if (!record.hasDegreePlan) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                ToneCallout(
                  tone: AppTone.warning,
                  icon: Icons.account_tree_outlined,
                  title: l10n.staffRegistryNoDegreePlanTitle,
                  body: l10n.staffRegistryNoDegreePlanBody,
                ),
              ],
              if (record.idReplacementFeeOwing) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                ToneCallout(
                  tone: AppTone.warning,
                  icon: Icons.payments_outlined,
                  title: l10n.staffRegistryFeeOwingTitle,
                  body: l10n.staffRegistryFeeOwingBody,
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(title: l10n.staffRegistryRecordDetails),
              AppSpacing.verticalGap(AppSpacing.md),
              RegistrationCard(
                clip: false,
                padding: AppSpacing.card,
                child: Column(
                  children: [
                    LabelledValueRow(
                      label: l10n.staffRegistryFieldEmail,
                      value: record.email,
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    LabelledValueRow(
                      label: l10n.staffRegistryFieldDepartment,
                      value: record.department,
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    LabelledValueRow(
                      label: l10n.staffRegistryFieldDegreePlan,
                      value: record.hasDegreePlan
                          ? record.degreePlanLabel
                          : l10n.staffRegistryFieldDegreePlanNone,
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    LabelledValueRow(
                      label: l10n.staffRegistryFieldEntry,
                      value: record.entryLabel,
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    LabelledValueRow(
                      label: l10n.staffRegistryFieldJamb,
                      value: record.jambNumber,
                      isCode: true,
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    LabelledValueRow(
                      label: l10n.staffRegistryFieldMatriculated,
                      value: dateFormat.format(record.matriculatedOn),
                      isCode: true,
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.staffRegistryFieldPhoto,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        StatusTag(
                          label: record.photoVerified
                              ? l10n.staffRegistryPhotoVerified
                              : l10n.staffRegistryPhotoMissing,
                          tone: record.photoVerified
                              ? AppTone.success
                              : AppTone.warning,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () => context.goNamed(
                  Routes.staffStudyPlanAdvisingName,
                  pathParameters: {
                    Routes.staffRegistrationStudentIdParam: record.id,
                  },
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(
                    AppDimensions.primaryActionHeight,
                  ),
                ),
                icon: const Icon(
                  Icons.route_outlined,
                  size: AppDimensions.iconDense,
                ),
                label: Text(l10n.staffRegistryOpenStudyPlan),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(
                title: l10n.staffRegistryTermsTitle,
                countLabel: l10n.staffRegistryTermsCount(
                  record.registrationTerms.length,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (record.registrationTerms.isEmpty)
                ToneCallout(
                  tone: AppTone.info,
                  icon: Icons.inbox_outlined,
                  title: l10n.staffRegistryTermsEmptyTitle,
                  body: l10n.staffRegistryTermsEmptyBody,
                )
              else
                for (final term in record.registrationTerms) ...[
                  RegistryTermCard(term: term),
                  AppSpacing.verticalGap(AppSpacing.md),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

/// One registered term on the student record, with its course lines.
class RegistryTermCard extends StatelessWidget {
  const RegistryTermCard({required this.term, super.key});

  final RegistryRegistrationTerm term;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return RegistrationCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
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
                      label: term.confirmed
                          ? l10n.staffRegistryTermConfirmed
                          : l10n.staffRegistryTermNotConfirmed,
                      tone: term.confirmed ? AppTone.success : AppTone.warning,
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.staffRegistryTermMeta(
                    l10n.registrationLevel(term.level),
                    term.totalUnits,
                  ),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (term.note.isNotEmpty) ...[
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Text(
                    term.note,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: AppTextStyles.relaxedLineHeight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          for (final course in term.courses) ...[
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.staffRegistryCourseLine(
                            course.code,
                            course.section,
                            course.units,
                          ),
                          style: AppTextStyles.codeSmall.copyWith(
                            fontWeight: AppTextStyles.semiBold,
                          ),
                        ),
                        AppSpacing.verticalGap(AppSpacing.xs),
                        Text(course.title, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  StatusTag(
                    label: RegistrationLabels.courseStatus(l10n, course.status),
                    tone: course.status.tone,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
