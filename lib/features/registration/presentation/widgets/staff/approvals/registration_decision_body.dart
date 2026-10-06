import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/widgets/responsive_content.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../bloc/staff/staff_approvals_cubit.dart';
import '../../../models/staff/approvals_models.dart';
import '../../../widgets/registration_card.dart';
import '../../../widgets/registration_chrome.dart';
import '../staff_chrome.dart';
import '../staff_student_identity_card.dart';
import 'approval_course_tile.dart';

/// Scrollable body of one student's course form under review.
class RegistrationDecisionBody extends StatelessWidget {
  const RegistrationDecisionBody({
    required this.review,
    required this.cubit,
    super.key,
  });

  final StudentRegistrationReview review;
  final StaffApprovalsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final selectable = !review.directDepartment;

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
                  review.name,
                ],
                title: l10n.staffApprovalsDecisionTitle,
                subtitle: l10n.staffApprovalsDecisionSubtitle(
                  review.sessionLabel,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              StaffStudentIdentityCard(
                name: review.name,
                matricNumber: review.matricNumber,
                level: review.level,
                programme: review.programme,
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              RegistrationCard(
                clip: false,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.registrationUnitsLabel.toUpperCase(),
                            style: AppTextStyles.codeSmall.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: AppTextStyles.trackingCaps,
                            ),
                          ),
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            l10n.registrationUnitsValue(
                              review.registeredUnits,
                              review.maximumUnits,
                            ),
                            style: AppTextStyles.tabular(
                              theme.textTheme.titleMedium!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      l10n.registrationUnitsDegreePlan(review.minimumUnits),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (review.directDepartment) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                ToneCallout(
                  tone: AppTone.info,
                  icon: Icons.apartment_outlined,
                  title: l10n.staffApprovalsDirectTitle,
                  body: l10n.staffApprovalsDirectBody,
                ),
              ] else if (review.atMinimum && review.pendingCount > 0) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                ToneCallout(
                  tone: AppTone.warning,
                  icon: Icons.warning_amber_outlined,
                  title: l10n.staffApprovalsAtMinimumTitle,
                  body: l10n.staffApprovalsAtMinimumBody(review.minimumUnits),
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(
                title: l10n.staffApprovalsCoursesTitle,
                countLabel: l10n.staffApprovalsCoursesCount(
                  review.courses.length,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              RegistrationCard(
                child: Column(
                  children: [
                    for (var i = 0; i < review.courses.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ApprovalCourseTile(
                        course: review.courses[i],
                        selectable: selectable,
                        onToggle: () => cubit.toggleCourseSelected(
                          review.courses[i].id,
                        ),
                      ),
                    ],
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
