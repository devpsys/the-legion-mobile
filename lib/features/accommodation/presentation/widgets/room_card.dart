import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/accommodation_models.dart';
import 'accommodation_labels.dart';

/// One room on the bookable list: where it is, how many beds are free, what a
/// bed costs, and either a Book action or the reason it cannot be booked.
class RoomCard extends StatelessWidget {
  const RoomCard({required this.room, required this.onBook, super.key});

  final BookableRoom room;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final isBookable = room.isBookable;
    final isClosed = room.availability == RoomAvailability.maintenance;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.hostel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      l10n.accommodationBlockRoom(room.block, room.room),
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.accommodationFreeBeds(room.freeBeds),
                    style: AppTextStyles.codeMedium.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    l10n.accommodationOfBeds(room.totalBeds),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          Row(
            children: [
              Text(
                formatNaira(room.priceMinorUnits),
                style: AppTextStyles.tabular(
                  AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Text(
                l10n.accommodationPerTerm,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.stairs_outlined,
                size: AppDimensions.iconSmall,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Text(
                room.floor,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          if (isBookable) ...[
            if (room.availability == RoomAvailability.singleSlot)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      size: AppDimensions.iconSmall,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.accommodationSingleSlotNote,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            FilledButton.icon(
              onPressed: onBook,
              icon: const Icon(Icons.arrow_forward),
              label: Text(l10n.accommodationBookRoom),
            ),
          ] else
            Row(
              children: [
                Icon(
                  isClosed ? Icons.handyman_outlined : Icons.info_outline,
                  size: AppDimensions.iconSmall,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    room.reason,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                StatusTag(
                  label: AccommodationLabels.roomAvailability(
                    l10n,
                    room.availability,
                  ),
                  tone: isClosed ? AppTone.warning : AppTone.neutral,
                  icon: isClosed ? Icons.build_circle_outlined : Icons.lock,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
