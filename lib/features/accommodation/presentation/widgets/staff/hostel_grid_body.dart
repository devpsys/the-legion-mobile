import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../bloc/staff/housing_state.dart';
import '../../models/staff/housing_models.dart';
import 'housing_bed_chip.dart';
import 'housing_empty_card.dart';
import 'housing_entry_card.dart';
import 'housing_labels.dart';
import 'housing_section.dart';

/// One hostel's beds, block by block and room by room.
class HostelGridBody extends StatelessWidget {
  const HostelGridBody({
    required this.state,
    required this.hostelId,
    super.key,
  });

  final HousingState state;
  final String hostelId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final hostel = state.hostelById(hostelId);
    if (hostel == null) {
      return HousingEmptyCard(
        icon: Icons.search_off,
        title: l10n.housingHostelMissingTitle,
        body: l10n.housingHostelMissingBody,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: hostel.name,
          description: HousingLabels.gender(l10n, hostel.gender),
          children: [
            HousingMetricRow(
              metrics: [
                HousingMetric(
                  value: '${hostel.totalBeds}',
                  caption: l10n.housingMetricBeds,
                ),
                HousingMetric(
                  value: '${hostel.takenBeds}',
                  caption: l10n.housingMetricTaken,
                ),
                HousingMetric(
                  value: '${hostel.freeBeds}',
                  caption: l10n.housingMetricFree,
                ),
              ],
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        HousingEntryCard(
          icon: Icons.groups_outlined,
          title: l10n.housingOccupantsTitle,
          body: l10n.housingOccupantsEntry(state.occupantsOf(hostel.id).length),
          onOpen: () => context.goNamed(
            Routes.staffOccupantsName,
            pathParameters: {Routes.staffHostelIdParam: hostel.id},
          ),
        ),
        for (final block in hostel.blocks) ...[
          AppSpacing.verticalGap(AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text(block.name, style: theme.textTheme.titleMedium),
              ),
              TextButton.icon(
                onPressed: () => context.goNamed(
                  Routes.staffBlockName,
                  pathParameters: {
                    Routes.staffHostelIdParam: hostel.id,
                    Routes.staffBlockIdParam: block.id,
                  },
                ),
                icon: const Icon(Icons.playlist_add),
                label: Text(l10n.housingBlockAddRooms),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          if (hostel.roomsOf(block.id).isEmpty)
            HousingEmptyCard(
              icon: Icons.meeting_room_outlined,
              title: l10n.housingBlockEmptyTitle,
              body: l10n.housingBlockEmptyBody,
            ),
          for (final room in hostel.roomsOf(block.id)) ...[
            InkWell(
              onTap: () => context.goNamed(
                Routes.staffRoomName,
                pathParameters: {
                  Routes.staffHostelIdParam: hostel.id,
                  Routes.staffRoomIdParam: room.id,
                },
              ),
              child: SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.housingRoomHeading(room.number, room.roomType),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: AppTextStyles.semiBold,
                            ),
                          ),
                        ),
                        StatusTag(
                          label: HousingLabels.roomStatus(l10n, room.status),
                          tone: HousingLabels.roomTone(room.status),
                        ),
                      ],
                    ),
                    AppSpacing.verticalGap(AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        for (final bed in room.beds)
                          HousingBedChip(
                            bed: bed,
                            dimmed: room.status != RoomStatus.open,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
        ],
      ],
    );
  }
}
