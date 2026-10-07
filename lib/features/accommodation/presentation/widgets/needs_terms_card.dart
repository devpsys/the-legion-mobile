import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';

/// The gate before booking: the accommodation terms have to be accepted first.
class NeedsTermsCard extends StatelessWidget {
  const NeedsTermsCard({
    required this.termLabel,
    required this.version,
    required this.onOpenTerms,
    super.key,
  });

  final String termLabel;
  final String version;
  final VoidCallback onOpenTerms;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.gavel_outlined,
                size: AppDimensions.iconHero,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.accommodationNeedsTermsTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.accommodationNeedsTermsBody(termLabel, version),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          FilledButton.icon(
            onPressed: onOpenTerms,
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.accommodationNeedsTermsAction),
          ),
        ],
      ),
    );
  }
}
