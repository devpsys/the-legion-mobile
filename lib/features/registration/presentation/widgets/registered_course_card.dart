import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/registration_models.dart';
import 'registration_labels.dart';

/// One ledger row in the tabbed-ledger "Your Courses" table.
class RegisteredCourseCard extends StatelessWidget {
  const RegisteredCourseCard({
    required this.course,
    required this.onDrop,
    required this.onReadd,
    super.key,
  });

  final RegisteredCourse course;
  final VoidCallback onDrop;
  final VoidCallback onReadd;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final showDrop = course.canDrop && course.status.countsTowardUnits;
    final isRejected = course.status == CourseApprovalStatus.rejected;
    final isDropped = course.status == CourseApprovalStatus.dropped;
    final isClash = course.status == CourseApprovalStatus.clashAccepted;
    final inactive = isDropped;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: isRejected
          ? AppTone.danger.surface(theme.brightness).withValues(alpha: 0.25)
          : isDropped
          ? theme.colorScheme.surfaceContainerLowest.withValues(alpha: 0.5)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 8,
                child: Opacity(
                  opacity: inactive ? 0.5 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            course.codeWithSection,
                            style: AppTextStyles.codeMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: inactive
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurface,
                              decoration: inactive
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          if (isClash) ...[
                            StatusTag(
                              label: l10n.registrationStatusApproved,
                              tone: AppTone.success,
                            ),
                            StatusTag(
                              label: l10n.registrationStatusClashAccepted,
                              tone: AppTone.warning,
                            ),
                          ] else
                            StatusTag(
                              label: RegistrationLabels.courseStatus(
                                l10n,
                                course.status,
                              ),
                              tone: course.status.tone,
                            ),
                        ],
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        course.title,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: inactive
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Opacity(
                  opacity: inactive ? 0.5 : 1,
                  child: Text(
                    '${course.units}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _ActionCell(
                    showDrop: showDrop,
                    isRejected: isRejected,
                    isDropped: isDropped,
                    onDrop: onDrop,
                    onReadd: onReadd,
                  ),
                ),
              ),
            ],
          ),
          if (course.rejectReason case final reason?) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTone.danger
                    .surface(theme.brightness)
                    .withValues(alpha: 0.7),
                borderRadius: AppRadii.elementRadius,
                border: Border.all(
                  color: AppTone.danger
                      .foreground(theme.brightness)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: AppDimensions.iconDense,
                    color: AppTone.danger.foreground(theme.brightness),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      reason,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTone.danger.foreground(theme.brightness),
                        height: AppTextStyles.relaxedLineHeight,
                      ),
                    ),
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

class _ActionCell extends StatelessWidget {
  const _ActionCell({
    required this.showDrop,
    required this.isRejected,
    required this.isDropped,
    required this.onDrop,
    required this.onReadd,
  });

  final bool showDrop;
  final bool isRejected;
  final bool isDropped;
  final VoidCallback onDrop;
  final VoidCallback onReadd;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    if (showDrop) {
      return Material(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
        child: InkWell(
          onTap: onDrop,
          borderRadius: AppRadii.elementRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              l10n.registrationDrop,
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.dangerText(theme.brightness),
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ),
        ),
      );
    }

    if (isRejected) {
      return Text(
        l10n.registrationActionBlocked,
        style: AppTextStyles.codeSmall.copyWith(
          color: AppTone.danger.foreground(theme.brightness),
        ),
      );
    }

    if (isDropped) {
      return Material(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
        child: InkWell(
          onTap: onReadd,
          borderRadius: AppRadii.elementRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              l10n.registrationAdd,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ),
        ),
      );
    }

    return Text(
      l10n.registrationActionNone,
      style: AppTextStyles.codeSmall.copyWith(
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
