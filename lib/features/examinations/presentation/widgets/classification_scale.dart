import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/examinations_models.dart';

/// The degree classification scale with the student's current tier marked.
class ClassificationScale extends StatelessWidget {
  const ClassificationScale({required this.record, super.key});

  final ResultsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final current = record.classification;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.examScaleTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        for (final band in record.scale)
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: band == current
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerLow,
              borderRadius: AppRadii.blockRadius,
            ),
            child: Row(
              children: [
                if (band == current) ...[
                  Icon(
                    Icons.check_circle,
                    size: AppDimensions.iconSmall,
                    color: theme.colorScheme.primary,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                ],
                Expanded(
                  child: Text(
                    band.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: band == current
                          ? AppTextStyles.bold
                          : AppTextStyles.regular,
                    ),
                  ),
                ),
                Text(
                  l10n.examScaleRange(
                    band.from.toStringAsFixed(2),
                    band.to.toStringAsFixed(2),
                  ),
                  style: AppTextStyles.codeSmall,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
