import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/accommodation_models.dart';
import 'accommodation_labels.dart';

/// Breadcrumb, title and the student's docket line that open the hub.
class AccommodationHeader extends StatelessWidget {
  const AccommodationHeader({
    required this.student,
    required this.termLabel,
    this.phase,
    super.key,
  });

  final AccommodationStudent student;

  /// The selected term, e.g. `2026/2027-1`.
  final String termLabel;

  /// The selected term's phase, shown as a status tag on the docket.
  final AllocationPhase? phase;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final phase = this.phase;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              l10n.accommodationBreadcrumbStudent,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              size: AppDimensions.iconMicro,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Text(
              l10n.accommodationTitle,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(l10n.accommodationTitle, style: theme.textTheme.headlineSmall),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.accommodationSubtitle(termLabel),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        SurfaceCard(
          child: Row(
            children: [
              Icon(
                Icons.badge_outlined,
                size: AppDimensions.iconMedium,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.accommodationMatricLevel(
                        student.matricNumber,
                        student.level,
                      ),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (phase != null) ...[
                AppSpacing.horizontalGap(AppSpacing.sm),
                StatusTag(
                  label: AccommodationLabels.phaseStatus(l10n, phase),
                  tone: AccommodationLabels.phaseTone(phase),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
