import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/utils/dates.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../models/staff/housing_models.dart';
import 'housing_labels.dart';

/// One allocation on the queue; tapping opens its detail.
class AllocationTile extends StatelessWidget {
  const AllocationTile({required this.record, super.key});

  final AllocationRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final muted = AppTextStyles.codeSmall.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return InkWell(
      borderRadius: AppRadii.cardRadius,
      onTap: () => context.goNamed(
        Routes.staffAllocationName,
        pathParameters: {Routes.staffAllocationIdParam: record.id},
      ),
      child: SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    record.studentName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
                StatusTag(
                  label: HousingLabels.allocationState(l10n, record.state),
                  tone: HousingLabels.allocationTone(record.state),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(record.matricNumber, style: muted),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.accommodationBedFull(
                record.bed.hostelBlock,
                record.bed.room,
                record.bed.bed,
              ),
              style: theme.textTheme.bodyMedium,
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${record.termLabel} · '
                    '${AppDateFormats.medium(l10n.localeName).format(record.createdOn)}',
                    style: muted,
                  ),
                ),
                Text(
                  record.feeMinorUnits == 0
                      ? l10n.accommodationPriceFree
                      : formatNaira(record.feeMinorUnits),
                  style: AppTextStyles.tabular(muted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
