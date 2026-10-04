import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'brand_crest_tile.dart';

/// The university's name over a public page, where there is no app bar to
/// carry it: the crest, the name, and what the page is for.
class PublicBrandBlock extends StatelessWidget {
  const PublicBrandBlock({required this.caption, super.key});

  /// What this page does, under the name — e.g. "Admissions verification".
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        const BrandCrestTile(),
        AppSpacing.horizontalGap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.admissionsLetterUniversity,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                caption,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
