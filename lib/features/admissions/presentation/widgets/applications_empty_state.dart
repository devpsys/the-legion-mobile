import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Shown when the candidate has not applied anywhere yet.
///
/// Names the number of open cycles, because "nothing here" is only reassuring
/// when the reason is obvious.
class ApplicationsEmptyState extends StatelessWidget {
  const ApplicationsEmptyState({
    required this.openCycleCount,
    required this.onBrowse,
    super.key,
  });

  /// How many cycles are accepting applications right now.
  final int openCycleCount;

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.rowRadius,
        // Dashed: this is an absence, not a section.
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.statusMark - AppSpacing.md,
            height: AppDimensions.statusMark - AppSpacing.md,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.description_outlined,
              size: AppDimensions.iconHero,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Text(
            l10n.admissionsNoApplicationsTitle,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.copyMeasure,
            ),
            child: Text(
              l10n.admissionsNoApplicationsBody(openCycleCount),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          OutlinedButton.icon(
            onPressed: onBrowse,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              minimumSize: const Size(0, AppDimensions.buttonHeight),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.elementRadius,
              ),
            ),
            icon: const Icon(
              Icons.school_outlined,
              size: AppDimensions.iconDense,
            ),
            label: Text(l10n.admissionsBrowseProgrammes),
          ),
        ],
      ),
    );
  }
}
