import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/surface_card.dart';

/// An empty list inside a housing screen: an icon, a title and a sentence on
/// what would fill it.
class HousingEmptyCard extends StatelessWidget {
  const HousingEmptyCard({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SurfaceCard(
      child: Column(
        children: [
          Icon(
            icon,
            size: AppDimensions.iconLarge,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(title, style: theme.textTheme.titleMedium),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
