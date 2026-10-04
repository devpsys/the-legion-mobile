import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/application_detail_models.dart';
import 'section_surface.dart';

/// The committee's written finding, and the reason it gave.
///
/// Formal on purpose: a gavel and a heading rather than an apology, because this
/// is a decision of record. The reason sits in its own recessed block under the
/// boilerplate so the one sentence a candidate came here to read is never lost
/// in the paragraph above it.
class ApplicationRejectionNoticeCard extends StatelessWidget {
  const ApplicationRejectionNoticeCard({
    required this.cycleName,
    required this.notice,
    super.key,
  });

  /// The cycle the decision belongs to, quoted in the finding.
  final String cycleName;

  final RejectionNotice notice;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.gavel_outlined,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.admissionsDecisionFindingTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.admissionsDecisionFindingBody(cycleName),
            style: theme.textTheme.bodyMedium?.copyWith(
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Container(
            padding: AppSpacing.card,
            decoration: BoxDecoration(
              color: AppColors.subtle(theme.brightness),
              borderRadius: AppRadii.blockRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.admissionsDecisionDeterminationLabel.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  notice.determination,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: AppTextStyles.medium,
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
