import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import 'section_surface.dart';

/// The registrar's seal on a decision: who stands behind it, and how a copy can
/// be checked.
///
/// A refusal is only worth contesting if it can be proved genuine, and only
/// worth accepting if it can't have been altered, so the card quotes the digest
/// of the signed notice and says plainly that the decision is closed for the
/// cycle — the same sentence the letter ends with.
class ApplicationAttestationCard extends StatelessWidget {
  const ApplicationAttestationCard({
    required this.verificationHash,
    required this.cycleName,
    super.key,
  });

  /// Digest of the signed decision notice.
  final String verificationHash;

  /// The cycle the decision is final for.
  final String cycleName;

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
              Container(
                width: AppDimensions.statusBadge,
                height: AppDimensions.statusBadge,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.verified_outlined,
                  size: AppDimensions.iconHero,
                  color: theme.colorScheme.primary,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.admissionsAttestationEyebrow.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: AppTextStyles.trackingCaps,
                      ),
                    ),
                    Text(
                      l10n.admissionsAttestationOffice,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      l10n.admissionsAttestationDirectorate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Container(
            padding: AppSpacing.card,
            decoration: BoxDecoration(
              color: AppColors.subtle(theme.brightness),
              borderRadius: AppRadii.blockRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.admissionsAttestationHash.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          letterSpacing: AppTextStyles.trackingCaps,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        verificationHash,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.codeSmall.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Icon(
                  Icons.lock_outline,
                  size: AppDimensions.iconSmall,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.horizontalGap(AppSpacing.xs),
                Text(
                  l10n.admissionsAttestationImmutable,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.admissionsAttestationConclusive(cycleName),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
