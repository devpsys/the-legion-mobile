import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';

/// The bursary's standing notice: only a receipt with the university's QR
/// mark counts, and nobody on staff takes cash.
///
/// Fixed copy rather than a bulletin from the record, because it is policy
/// and not news — it reads the same under every ledger.
class BursaryNoticeCard extends StatelessWidget {
  const BursaryNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: AppDimensions.iconHero,
            color: theme.colorScheme.primary,
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.feesBursaryNoticeTitle,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.feesBursaryNoticeBody,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
