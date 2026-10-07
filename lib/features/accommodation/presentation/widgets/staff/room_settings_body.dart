import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/labelled_value_row.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import '../../models/staff/housing_models.dart';
import 'housing_bed_chip.dart';
import 'housing_empty_card.dart';
import 'housing_labels.dart';
import 'housing_section.dart';

/// Settings of one room: whether it is bookable and what type it is.
class RoomSettingsBody extends StatefulWidget {
  const RoomSettingsBody({
    required this.state,
    required this.hostelId,
    required this.roomId,
    super.key,
  });

  final HousingState state;
  final String hostelId;
  final String roomId;

  @override
  RoomSettingsBodyState createState() => RoomSettingsBodyState();
}

/// State of [RoomSettingsBody]: the draft the officer edits before saving.
class RoomSettingsBodyState extends State<RoomSettingsBody> {
  RoomStatus? _status;
  String? _roomType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final hostel = widget.state.hostelById(widget.hostelId);
    final room = hostel?.roomById(widget.roomId);
    if (hostel == null || room == null) {
      return HousingEmptyCard(
        icon: Icons.search_off,
        title: l10n.housingRoomMissingTitle,
        body: l10n.housingRoomMissingBody,
      );
    }
    final status = _status ?? room.status;
    final roomType = _roomType ?? room.roomType;
    final types = {
      for (final price in widget.state.prices) price.roomType,
      room.roomType,
    }.toList();
    final changed = status != room.status || roomType != room.roomType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: l10n.housingRoomHeading(room.number, room.roomType),
          description: hostel.name,
          children: [
            LabelledValueRow(
              label: l10n.housingDetailRoom,
              value: l10n.accommodationBlockRoom(
                hostel.blockById(room.blockId)?.name ?? '',
                room.number,
              ),
            ),
            if (room.floor.isNotEmpty)
              LabelledValueRow(label: l10n.housingRoomFloor, value: room.floor),
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
        AppSpacing.verticalGap(AppSpacing.md),
        HousingSection(
          title: l10n.housingRoomStatusTitle,
          description: l10n.housingRoomStatusBody,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final value in RoomStatus.values)
                  ChoiceChip(
                    label: Text(HousingLabels.roomStatus(l10n, value)),
                    selected: status == value,
                    onSelected: (_) => setState(() => _status = value),
                  ),
              ],
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        HousingSection(
          title: l10n.housingRoomTypeTitle,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final value in types)
                  ChoiceChip(
                    label: Text(value),
                    selected: roomType == value,
                    onSelected: (_) => setState(() => _roomType = value),
                  ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.housingRoomTypeNote,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        FilledButton(
          onPressed: changed
              ? () => context.read<HousingCubit>().updateRoom(
                  hostelId: hostel.id,
                  roomId: room.id,
                  status: status,
                  roomType: roomType,
                )
              : null,
          child: Text(l10n.housingSave),
        ),
      ],
    );
  }
}
