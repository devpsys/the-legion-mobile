import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';

/// The results hub before anything is published: what is coming and the
/// three desks a result passes through.
class ResultsEmptyCard extends StatelessWidget {
  const ResultsEmptyCard({required this.sessionLabel, super.key});

  final String sessionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final steps = [
      l10n.examResultsStepLecturer,
      l10n.examResultsStepDepartment,
      l10n.examResultsStepRegistry,
    ];

    return SurfaceCard(
      padding: AppSpacing.sheet,
      child: Column(
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            size: AppDimensions.iconLarge,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.examResultsEmptyTitle,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examResultsEmptyBody(sessionLabel),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppDimensions.marker / 2,
                    backgroundColor: theme.colorScheme.surfaceContainerHigh,
                    child: Text(
                      '${i + 1}',
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.md),
                  Expanded(
                    child: Text(steps[i], style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
