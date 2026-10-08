import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';

/// Breadcrumb, matric pill and the student docket that open the results page.
class ResultsIdentityCard extends StatelessWidget {
  const ResultsIdentityCard({required this.student, super.key});

  final ExamStudent student;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final muted = theme.colorScheme.onSurfaceVariant;
    final success = AppTone.success.foreground(theme.brightness);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              l10n.examResultsBreadcrumb,
              style: theme.textTheme.bodySmall?.copyWith(color: muted),
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              size: AppDimensions.iconMicro,
              color: muted,
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Text(
              l10n.examResultsTitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: AppTextStyles.medium,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: AppRadii.chipRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppDimensions.indicator,
                    height: AppDimensions.indicator,
                    decoration: BoxDecoration(
                      color: success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.xs),
                  Text(
                    student.matricNumber,
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        SurfaceCard(
          padding: AppSpacing.card,
          child: Row(
            children: [
              Container(
                width: AppDimensions.monogramSize,
                height: AppDimensions.monogramSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  student.initials,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: theme.textTheme.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      l10n.examStudentLine(student.level, student.programme),
                      style: theme.textTheme.bodySmall?.copyWith(color: muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    student.department,
                    style: AppTextStyles.codeSmall.copyWith(color: muted),
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_outlined,
                        size: AppDimensions.iconMicro,
                        color: success,
                      ),
                      AppSpacing.horizontalGap(AppSpacing.xs),
                      Text(
                        l10n.examResultsMatriculated,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: success,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
