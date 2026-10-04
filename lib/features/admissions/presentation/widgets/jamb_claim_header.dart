import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// What the JAMB tab is for, before the form asks for anything.
///
/// Eyebrow, heading, and the one paragraph that says where the result comes
/// from — the candidate is about to type a number they guard, and should know
/// it is being matched against what JAMB sent, not uploaded anywhere.
class JambClaimHeader extends StatelessWidget {
  const JambClaimHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.admissionsJambEyebrow.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: AppTextStyles.semiBold,
            letterSpacing: AppTextStyles.trackingCapsWide,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.admissionsJambHeading,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(
          l10n.admissionsJambIntro,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: AppTextStyles.relaxedLineHeight,
          ),
        ),
      ],
    );
  }
}
