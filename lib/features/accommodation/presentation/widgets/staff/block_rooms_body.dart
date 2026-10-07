import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_empty_card.dart';
import 'housing_field.dart';
import 'housing_section.dart';

/// Adds a run of rooms to a block in one go.
class BlockRoomsBody extends StatefulWidget {
  const BlockRoomsBody({
    required this.state,
    required this.hostelId,
    required this.blockId,
    super.key,
  });

  final HousingState state;
  final String hostelId;
  final String blockId;

  @override
  BlockRoomsBodyState createState() => BlockRoomsBodyState();
}

/// State of [BlockRoomsBody]: the range and type being drafted.
class BlockRoomsBodyState extends State<BlockRoomsBody> {
  final TextEditingController _from = TextEditingController();
  final TextEditingController _to = TextEditingController();
  String? _roomType;
  int _beds = 4;

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final hostel = widget.state.hostelById(widget.hostelId);
    final block = hostel?.blockById(widget.blockId);
    if (hostel == null || block == null) {
      return HousingEmptyCard(
        icon: Icons.search_off,
        title: l10n.housingHostelMissingTitle,
        body: l10n.housingHostelMissingBody,
      );
    }
    final from = int.tryParse(_from.text.trim());
    final to = int.tryParse(_to.text.trim());
    final isRange = from != null && to != null && to >= from;
    final hasInput = _from.text.isNotEmpty || _to.text.isNotEmpty;
    final types = [for (final price in widget.state.prices) price.roomType];
    final roomType = _roomType ?? (types.isEmpty ? '' : types.first);
    final count = isRange ? to - from + 1 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: block.name,
          description: l10n.housingBlockCurrent(
            hostel.name,
            hostel.roomsOf(block.id).length,
          ),
          children: [
            HousingField(
              label: l10n.housingBlockFrom,
              controller: _from,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            HousingField(
              label: l10n.housingBlockTo,
              controller: _to,
              keyboardType: TextInputType.number,
              errorText: hasInput && !isRange
                  ? l10n.housingBlockRangeError
                  : null,
              onChanged: (_) => setState(() {}),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            HousingStepper(
              label: l10n.housingBlockBeds,
              value: _beds,
              min: 1,
              max: 8,
              onChanged: (value) => setState(() => _beds = value),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              l10n.housingRoomTypeTitle,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
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
            if (isRange) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.housingBlockPreview(count, count * _beds),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        FilledButton(
          onPressed: isRange && roomType.isNotEmpty
              ? () {
                  context.read<HousingCubit>().addRooms(
                    hostelId: hostel.id,
                    blockId: block.id,
                    from: from,
                    to: to,
                    roomType: roomType,
                    bedsPerRoom: _beds,
                  );
                  _from.clear();
                  _to.clear();
                  setState(() {});
                }
              : null,
          child: Text(l10n.housingBlockAdd),
        ),
      ],
    );
  }
}
