import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/greeting_period.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';

/// Who is applying: name, address, and the crest.
///
/// Deliberately a plain card rather than the hub's celebratory navy hero. The
/// applicant has achieved nothing yet; the design says so by not celebrating.
class ApplicantStrip extends StatelessWidget {
  const ApplicantStrip({required this.candidate, required this.now, super.key});

  final CandidateProfile candidate;

  /// Injected so the greeting is deterministic in tests.
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.admissionsApplicantLabel.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: AppTextStyles.trackingCaps,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.admissionsGreeting(
                    GreetingPeriod.forTime(now).localize(l10n),
                    candidate.firstName,
                  ),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  candidate.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          const CandidateCrest(),
        ],
      ),
    );
  }
}

/// The registry insignia shown opposite the applicant's name.
class CandidateCrest extends StatelessWidget {
  const CandidateCrest({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: AppDimensions.monogramSize,
      height: AppDimensions.monogramSize,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.shield_outlined,
        size: AppDimensions.iconDense,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
