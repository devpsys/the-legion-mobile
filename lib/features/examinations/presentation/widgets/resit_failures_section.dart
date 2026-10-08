import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';
import 'resit_failure_tile.dart';

/// The courses the student failed and has not since passed.
///
/// Open: each can be registered. Closed: each is listed as not open, with
/// what the lot would cost.
class ResitFailuresSection extends StatelessWidget {
  const ResitFailuresSection({required this.record, super.key});

  final ResitsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final failures = record.failures;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.examResitFailuresTitle,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Text(
              l10n.examResitFailuresCount(failures.length),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.examResitFailuresNote,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        if (failures.isEmpty)
          SurfaceCard(
            child: Text(
              l10n.examResitFailuresEmpty,
              style: theme.textTheme.bodyMedium,
            ),
          )
        else
          for (final failure in failures) ...[
            ResitFailureTile(record: record, failure: failure),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
        if (!record.isOpen && failures.isNotEmpty)
          SurfaceCard(
            child: Column(
              children: [
                LabelledValueRow(
                  label: l10n.examResitObligation,
                  value: formatNaira(record.estimatedObligationMinorUnits),
                  isCode: true,
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  l10n.examResitClosedHelp,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
