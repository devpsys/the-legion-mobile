import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';

/// Whether the resit window is open, and the date that matters.
class ResitWindowBanner extends StatelessWidget {
  const ResitWindowBanner({required this.record, super.key});

  final ResitsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final date = AppDateFormats.long(l10n.localeName).format(record.windowDate);

    return SurfaceCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.isOpen
                      ? l10n.examResitWindowOpen(record.windowLabel)
                      : l10n.examResitWindowClosed(record.windowLabel),
                  style: theme.textTheme.titleMedium,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  record.isOpen
                      ? l10n.examResitWindowCloses(date)
                      : l10n.examResitWindowClosedOn(date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          StatusTag(
            label: record.isOpen
                ? l10n.examResitTagOpen
                : l10n.examResitTagClosed,
            tone: record.isOpen ? AppTone.success : AppTone.neutral,
          ),
        ],
      ),
    );
  }
}
