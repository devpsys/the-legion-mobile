import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';

/// Booking for this term has not been scheduled yet.
class NotScheduledCard extends StatelessWidget {
  const NotScheduledCard({required this.termLabel, super.key});

  final String termLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.schedule,
                size: AppDimensions.iconLarge,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.accommodationNotScheduledTitle(termLabel),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              Text(
                l10n.accommodationNotScheduledBody,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        SurfaceCard(
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: AppDimensions.iconDense,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.accommodationCalendarTitle(termLabel),
                      style: theme.textTheme.titleSmall,
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.accommodationCalendarBody,
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
        ),
      ],
    );
  }
}
