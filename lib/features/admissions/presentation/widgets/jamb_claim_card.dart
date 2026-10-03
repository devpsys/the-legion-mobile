import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import 'status_tag.dart';
import 'striped_card.dart';

/// The reason this screen exists: a JAMB result is waiting to be claimed.
///
/// Given its own card rather than a row, because it is the one action that
/// unlocks everything else — the candidate chose the university, and the portal
/// has their score but has not given it to them.
class JambClaimCard extends StatelessWidget {
  const JambClaimCard({required this.onClaim, super.key});

  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    const tone = AppTone.warning;

    return StripedCard(
      tone: tone,
      isRaised: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppDimensions.iconTile,
                height: AppDimensions.iconTile,
                decoration: BoxDecoration(
                  color: tone.surface(theme.brightness),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.auto_awesome_outlined,
                  size: AppDimensions.iconDense,
                  color: tone.foreground(theme.brightness),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatusTag(
                      label: l10n.admissionsJambTag,
                      tone: tone,
                      isUppercase: true,
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.admissionsJambTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.admissionsJambBody,
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
          AppSpacing.verticalGap(AppSpacing.md),
          FilledButton.icon(
            onPressed: onClaim,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.elementRadius,
              ),
            ),
            label: Text(l10n.admissionsClaimResult),
            icon: const Icon(
              Icons.arrow_forward,
              size: AppDimensions.iconDense,
            ),
            // The arrow trails the label: it reads as "continue", not "next
            // screen in a carousel".
            iconAlignment: IconAlignment.end,
          ),
        ],
      ),
    );
  }
}
