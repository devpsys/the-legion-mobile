import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/registration_models.dart';

/// Compact catalogue row for the segmented-deck departmental catalog.
class CatalogueCourseCard extends StatelessWidget {
  const CatalogueCourseCard({
    required this.course,
    required this.onAdd,
    required this.onRequestWaiver,
    this.embedded = true,
    super.key,
  });

  final CatalogueCourse course;
  final VoidCallback onAdd;
  final VoidCallback onRequestWaiver;

  /// Kept for call-site compatibility; rows are always embedded in the shell.
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final block = course.block;
    final isPrereq = block == CatalogueBlock.missingPrerequisite;
    final isBlocked =
        block == CatalogueBlock.full ||
        block == CatalogueBlock.notOpenYet ||
        isPrereq;
    final blockLabel = switch (block) {
      CatalogueBlock.full => l10n.registrationCatalogueFull,
      CatalogueBlock.notOpenYet => l10n.registrationCatalogueNotOpen,
      _ => null,
    };
    final blockTone = block == CatalogueBlock.full
        ? AppTone.danger
        : AppTone.neutral;

    final compactStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(0, AppDimensions.buttonCompact),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.md),
      ),
      visualDensity: VisualDensity.compact,
      backgroundColor: WidgetStatePropertyAll(
        theme.colorScheme.surfaceContainerHigh,
      ),
      foregroundColor: WidgetStatePropertyAll(
        isBlocked
            ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
            : theme.colorScheme.primary,
      ),
      side: WidgetStatePropertyAll(
        BorderSide(color: theme.colorScheme.outlineVariant),
      ),
    );

    final detail = switch (block) {
      CatalogueBlock.outsidePlan => l10n.registrationCatalogueOutsidePlan,
      CatalogueBlock.full => l10n.registrationCatalogueFullDetail(
        course.title,
        course.units,
      ),
      CatalogueBlock.notOpenYet => l10n.registrationNotOpenDetail(course.units),
      CatalogueBlock.missingPrerequisite => course.title,
      _ => l10n.registrationCatalogueTitleSection(course.section, course.title),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          course.codeWithSection,
                          style: AppTextStyles.codeMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      if (blockLabel != null)
                        StatusTag(label: blockLabel, tone: blockTone)
                      else
                        Text(
                          l10n.registrationCourseUnits(course.units),
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    detail,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.sm),
            TextButton(
              onPressed: isBlocked ? null : onAdd,
              style: compactStyle,
              child: Text(l10n.registrationAdd),
            ),
          ],
        ),
        if (isPrereq) ...[
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            children: [
              Text(
                l10n.registrationNeedsPrerequisite(
                  course.prerequisiteCode ?? '',
                ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              InkWell(
                onTap: onRequestWaiver,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.registrationRequestWaiver,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Icon(
                      Icons.open_in_new,
                      size: AppDimensions.iconMicro,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
