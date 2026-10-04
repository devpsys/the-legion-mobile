import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// The way forward from a refusal: the next cycle is open, and so is the door.
///
/// A navy panel, the one inverted surface the portal allows itself, because the
/// card follows the heaviest news on the screen and is the thing a candidate
/// should do next. Gold for the single action that starts something, glass for
/// the one that only fetches a document — so a thumb moving down the page meets
/// the useful button first.
class ApplicationNextCycleCard extends StatelessWidget {
  const ApplicationNextCycleCard({
    required this.cycleLabel,
    required this.onStartNew,
    required this.onDownloadNotice,
    super.key,
  });

  /// The open cycle, e.g. `2026/2027 Cycle`.
  final String cycleLabel;

  /// Starts a fresh application.
  final VoidCallback onStartNew;

  /// Downloads the signed decision notice.
  final VoidCallback onDownloadNotice;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: AppSpacing.sheet,
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.campaign_outlined,
                size: AppDimensions.iconMedium,
                color: AppColors.honeyGold,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  cycleLabel.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.honeyGold,
                    fontWeight: AppTextStyles.semiBold,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.admissionsNextCycleHeadline,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.onNavy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.admissionsNextCycleBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onNavyMuted,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          FilledButton(
            onPressed: onStartNew,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.honeyGold,
              foregroundColor: AppColors.onGoldLight,
              minimumSize: const Size(0, AppDimensions.buttonHeight),
            ),
            child: Text(l10n.admissionsStartNewApplication),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: onDownloadNotice,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.navyGlass,
              foregroundColor: AppColors.onNavy,
              side: const BorderSide(color: AppColors.navyGlassStroke),
              minimumSize: const Size(0, AppDimensions.buttonHeight),
            ),
            icon: const Icon(Icons.download, size: AppDimensions.iconDense),
            label: Text(l10n.admissionsDownloadDecisionNotice),
          ),
        ],
      ),
    );
  }
}
