import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import 'section_surface.dart';

/// The ending: the candidate is a student, and here is the number that says so.
///
/// The only celebratory state in the portal, and still not a loud one — green
/// for the glyph and the sentence, the matric number set larger than anything
/// else on the card, and two plain actions. The number is the point: it is what
/// the candidate is told to quote in every letter to the university, so it
/// sits in its own box where it can be read aloud or copied from.
class ApplicationMatriculatedCard extends StatelessWidget {
  const ApplicationMatriculatedCard({
    required this.matricNumber,
    required this.onOpenPortal,
    required this.onDownloadLetter,
    super.key,
  });

  /// The number the registry issued, e.g. `25/ACC/0087`.
  final String matricNumber;

  /// Leaves the portal for the student portal.
  final VoidCallback onOpenPortal;

  final VoidCallback onDownloadLetter;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    const tone = AppTone.success;

    return HubSectionSurface(
      padding: AppSpacing.sheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.statusBadge,
            height: AppDimensions.statusBadge,
            decoration: BoxDecoration(
              color: tone.surface(theme.brightness),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.school_outlined,
              size: AppDimensions.iconDisplay,
              color: tone.foreground(theme.brightness),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Text(
            l10n.admissionsMatriculatedTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.subtle(theme.brightness),
              borderRadius: AppRadii.elementRadius,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Text(
              matricNumber,
              style: AppTextStyles.codeDisplay.copyWith(
                color: theme.colorScheme.primary,
                fontSize: AppTextStyles.headlineLargeSize,
                fontWeight: AppTextStyles.bold,
                letterSpacing: AppTextStyles.trackingCaps,
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.admissionsMatriculatedUse,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: AppSpacing.card,
            decoration: BoxDecoration(
              color: tone.surface(theme.brightness),
              borderRadius: AppRadii.blockRadius,
              border: Border.all(
                color: AppColors.successBorder(theme.brightness),
              ),
            ),
            child: Text(
              l10n.admissionsMatriculatedComplete,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: tone.foreground(theme.brightness),
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onOpenPortal,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, AppDimensions.primaryActionHeight),
              ),
              icon: const Icon(Icons.login, size: AppDimensions.iconMedium),
              label: Text(l10n.admissionsOpenStudentPortal),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onDownloadLetter,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, AppDimensions.buttonHeight),
              ),
              icon: const Icon(Icons.download, size: AppDimensions.iconDense),
              label: Text(l10n.admissionsMatriculatedDownloadLetter),
            ),
          ),
        ],
      ),
    );
  }
}
