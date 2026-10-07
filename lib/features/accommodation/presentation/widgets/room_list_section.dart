import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/accommodation_cubit.dart';
import '../models/accommodation_models.dart';
import 'confirm_room_hold_sheet.dart';
import 'room_card.dart';

/// The rooms a student can book for [term]: a search field, the rooms, and the
/// note about the hostels filtered out.
///
/// Used inline by the hub when booking is open and as the body of the rooms
/// screen. Booking asks for confirmation first, then hands the room to the
/// cubit.
class RoomListSection extends StatefulWidget {
  const RoomListSection({required this.term, required this.cubit, super.key});

  final TermAccommodation term;
  final AccommodationCubit cubit;

  @override
  RoomListSectionState createState() => RoomListSectionState();
}

/// State of [RoomListSection].
class RoomListSectionState extends State<RoomListSection> {
  String _query = '';

  List<BookableRoom> get _visible {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return widget.term.rooms;
    return widget.term.rooms
        .where(
          (room) =>
              room.hostel.toLowerCase().contains(query) ||
              room.block.toLowerCase().contains(query) ||
              room.room.toLowerCase().contains(query),
        )
        .toList(growable: false);
  }

  Future<void> _book(BookableRoom room) async {
    final confirmed = await ConfirmRoomHoldSheet.show(
      context,
      room: room,
      termLabel: widget.term.label,
      holdWindow: AccommodationCubit.holdWindow,
    );
    if (!confirmed) return;
    widget.cubit.bookRoom(room.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final rooms = _visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.accommodationRoomsTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
            ),
            Text(
              l10n.accommodationRoomsVisible(rooms.length),
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          l10n.accommodationRoomsIntro,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: AppTextStyles.relaxedLineHeight,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: l10n.accommodationRoomsSearchHint,
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        if (rooms.isEmpty)
          ToneCallout(
            tone: AppTone.info,
            icon: Icons.bed_outlined,
            title: l10n.accommodationRoomsEmptyTitle,
            body: l10n.accommodationRoomsEmptyBody,
          )
        else
          for (final room in rooms) ...[
            RoomCard(room: room, onBook: () => _book(room)),
            AppSpacing.verticalGap(AppSpacing.md),
          ],
        ToneCallout(
          tone: AppTone.neutral,
          icon: Icons.filter_list,
          title: l10n.accommodationRoomsFilterTitle,
          body: l10n.accommodationRoomsFilterBody,
        ),
      ],
    );
  }
}
