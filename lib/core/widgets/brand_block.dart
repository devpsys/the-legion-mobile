import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'brand_crest_tile.dart';

/// The university's name over a public page, where there is no app bar to
/// carry it: the crest, the name, and what the page is for.
///
/// Two arrangements, one widget, so every door into the app wears the same
/// mark: in a row for a page that reads top-down from a form (verification),
/// stacked and centred for a page that opens with the institution before
/// asking anything (account creation).
class BrandBlock extends StatelessWidget {
  const BrandBlock({required this.caption, this.isCentered = false, super.key});

  /// What this page does, under the name — e.g. "Admissions verification".
  final String caption;

  /// Stacks the crest over the name and centres the block.
  final bool isCentered;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final title = Text(
      context.l10n.admissionsLetterUniversity,
      textAlign: isCentered ? TextAlign.center : null,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: AppTextStyles.bold,
      ),
    );
    final subtitle = Text(
      caption,
      textAlign: isCentered ? TextAlign.center : null,
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );

    if (isCentered) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BrandCrestTile(),
          AppSpacing.verticalGap(AppSpacing.md),
          title,
          AppSpacing.verticalGap(AppSpacing.xs),
          subtitle,
        ],
      );
    }

    return Row(
      children: [
        const BrandCrestTile(),
        AppSpacing.horizontalGap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, AppSpacing.verticalGap(AppSpacing.xs), subtitle],
          ),
        ),
      ],
    );
  }
}
