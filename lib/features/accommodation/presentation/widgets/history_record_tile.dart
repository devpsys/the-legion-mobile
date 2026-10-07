import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/accommodation_models.dart';
import 'accommodation_labels.dart';

/// One past bed record on the history ledger.
class HistoryRecordTile extends StatelessWidget {
  const HistoryRecordTile({required this.record, super.key});

  final HistoryRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tone = AccommodationLabels.historyTone(record.outcome);

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.accommodationHistoryBed(
                    record.location.hostelBlock,
                    record.location.room,
                    record.location.bed,
                  ),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              StatusTag(
                label: AccommodationLabels.historyOutcome(l10n, record.outcome),
                tone: tone,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.accommodationHistorySession(record.sessionLabel),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                AccommodationLabels.historyIcon(record.outcome),
                size: AppDimensions.iconSmall,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: Text(
                  record.note,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
