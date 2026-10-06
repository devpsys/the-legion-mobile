import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/dates.dart';
import '../../../../../../core/widgets/status_tag.dart';
import '../../../models/registration_models.dart';
import '../../../models/staff/approvals_models.dart';
import '../../../widgets/registration_labels.dart';

/// One course line on a form under HoD review.
///
/// Pending lines carry a checkbox unless the department registers courses
/// directly ([selectable] false).
class ApprovalCourseTile extends StatelessWidget {
  const ApprovalCourseTile({
    required this.course,
    required this.selectable,
    required this.onToggle,
    super.key,
  });

  final ApprovalCourseLine course;
  final bool selectable;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final dateFormat = AppDateFormats.medium(l10n.localeName);
    final showCheckbox = selectable && course.isPending;
    final decidedOn = course.decidedOn;

    return InkWell(
      onTap: showCheckbox ? onToggle : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCheckbox)
              Checkbox(
                value: course.selected,
                onChanged: (_) => onToggle(),
              )
            else
              AppSpacing.horizontalGap(AppSpacing.sm),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          course.code,
                          style: AppTextStyles.codeMedium.copyWith(
                            fontWeight: AppTextStyles.semiBold,
                          ),
                        ),
                        AppSpacing.horizontalGap(AppSpacing.sm),
                        Text(
                          l10n.staffApprovalsCourseMeta(
                            course.section,
                            course.units,
                          ),
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(course.title, style: theme.textTheme.bodySmall),
                    if (course.clashAccepted) ...[
                      AppSpacing.verticalGap(AppSpacing.sm),
                      StatusTag(
                        label: l10n.registrationStatusClashAccepted,
                        tone: AppTone.info,
                        icon: Icons.warning_amber_outlined,
                      ),
                    ],
                    if (!course.isPending &&
                        course.decidedBy.isNotEmpty &&
                        decidedOn != null) ...[
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.staffApprovalsDecidedBy(
                          course.decidedBy,
                          dateFormat.format(decidedOn),
                        ),
                        style: AppTextStyles.codeSmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: StatusTag(
                label: RegistrationLabels.courseStatus(l10n, course.status),
                tone: course.status.tone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
