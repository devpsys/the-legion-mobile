import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/surface_card.dart';

/// A titled card that holds one form or one block of figures.
class HousingSection extends StatelessWidget {
  const HousingSection({
    required this.title,
    required this.children,
    this.description,
    super.key,
  });

  final String title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final description = this.description;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          if (description != null) ...[
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
          AppSpacing.verticalGap(AppSpacing.md),
          ...children,
        ],
      ),
    );
  }
}

/// A figure with a caption beneath it, for the counts at the top of a tool.
class HousingMetric extends StatelessWidget {
  const HousingMetric({required this.value, required this.caption, super.key});

  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.tabular(
            theme.textTheme.titleLarge!.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          caption,
          style: AppTextStyles.codeSmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// [HousingMetric]s side by side, sharing the row equally.
class HousingMetricRow extends StatelessWidget {
  const HousingMetricRow({required this.metrics, super.key});

  final List<HousingMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [for (final metric in metrics) Expanded(child: metric)],
    );
  }
}
