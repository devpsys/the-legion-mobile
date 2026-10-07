import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../models/accommodation_models.dart';
import 'accommodation_labels.dart';

/// A swap another student proposed: accept it (and take their bed) or decline.
class SwapProposalCard extends StatelessWidget {
  const SwapProposalCard({
    required this.proposal,
    required this.onAccept,
    required this.onDecline,
    super.key,
  });

  final SwapProposal proposal;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final expires = AppDateFormats.longDateTime(l10n.localeName)
        .format(proposal.expiresOn);

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.swap_horizontal_circle_outlined,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.accommodationSwapIncoming,
                  style: AppTextStyles.codeSmall.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
              ),
              Text(
                l10n.accommodationSwapExpires(expires),
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.accommodationSwapBody(
              AccommodationLabels.bedFull(l10n, proposal.location),
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.handshake_outlined),
                  label: Text(l10n.accommodationSwapAccept),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDecline,
                  icon: const Icon(Icons.close),
                  label: Text(l10n.accommodationSwapDecline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
