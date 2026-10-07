import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import '../../models/staff/housing_models.dart';
import '../accommodation_labels.dart';
import 'housing_field.dart';
import 'housing_section.dart';

/// Allocates one student to one bed by hand.
class AllocateBody extends StatefulWidget {
  const AllocateBody({required this.state, super.key});

  final HousingState state;

  @override
  AllocateBodyState createState() => AllocateBodyState();
}

/// State of [AllocateBody]: the matric number and the bed picked so far.
class AllocateBodyState extends State<AllocateBody> {
  final TextEditingController _matric = TextEditingController();
  String? _hostelId;
  String? _roomId;
  int? _bed;

  @override
  void dispose() {
    _matric.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final hostels = widget.state.hostels;
    final hostel = widget.state.hostelById(_hostelId ?? '');
    final rooms = [
      for (final room in hostel?.rooms ?? const <HousingRoom>[])
        if (room.freeBeds > 0) room,
    ];
    final room = hostel?.roomById(_roomId ?? '');
    final freeBeds = [
      for (final bed in room?.beds ?? const <HousingBed>[])
        if (bed.state == BedState.free) bed,
    ];
    final ready =
        _matric.text.trim().isNotEmpty &&
        hostel != null &&
        room != null &&
        _bed != null;
    final outcome = widget.state.handOutcome;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: l10n.housingAllocateStudent,
          children: [
            HousingField(
              label: l10n.housingAllocateMatric,
              controller: _matric,
              hint: l10n.accommodationSwapMatricHint,
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        HousingSection(
          title: l10n.housingAllocateBed,
          children: [
            Text(
              l10n.housingAllocateHostel,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final entry in hostels)
                  ChoiceChip(
                    label: Text(entry.name),
                    selected: _hostelId == entry.id,
                    onSelected: (_) => setState(() {
                      _hostelId = entry.id;
                      _roomId = null;
                      _bed = null;
                    }),
                  ),
              ],
            ),
            if (hostel != null) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.housingAllocateRoom,
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final entry in rooms)
                    ChoiceChip(
                      label: Text(
                        l10n.housingAllocateRoomChoice(
                          hostel.blockById(entry.blockId)?.name ?? '',
                          entry.number,
                        ),
                      ),
                      selected: _roomId == entry.id,
                      onSelected: (_) => setState(() {
                        _roomId = entry.id;
                        _bed = null;
                      }),
                    ),
                ],
              ),
            ],
            if (room != null) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.housingAllocateBedNumber,
                style: AppTextStyles.codeSmall.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final entry in freeBeds)
                    ChoiceChip(
                      label: Text(entry.number.toString()),
                      selected: _bed == entry.number,
                      onSelected: (_) => setState(() => _bed = entry.number),
                    ),
                ],
              ),
            ],
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        FilledButton(
          onPressed: ready
              ? () => context.read<HousingCubit>().allocateByHand(
                  matricNumber: _matric.text,
                  hostelId: hostel.id,
                  roomId: room.id,
                  bedNumber: _bed!,
                )
              : null,
          child: Text(l10n.housingAllocateSubmit),
        ),
        if (outcome.status != HandAllocationStatus.none) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          HandOutcomeCallout(outcome: outcome),
        ],
      ],
    );
  }
}

/// What the last by-hand allocation came to.
class HandOutcomeCallout extends StatelessWidget {
  const HandOutcomeCallout({required this.outcome, super.key});

  final HandAllocationOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bed = outcome.bed;

    return switch (outcome.status) {
      HandAllocationStatus.allocated => ToneCallout(
        tone: AppTone.success,
        icon: Icons.check_circle_outline,
        title: l10n.housingAllocateDoneTitle,
        body: l10n.housingAllocateDoneBody(
          outcome.studentName,
          bed == null ? '' : AccommodationLabels.bedFull(l10n, bed),
        ),
      ),
      HandAllocationStatus.unknownStudent => ToneCallout(
        tone: AppTone.danger,
        icon: Icons.person_off_outlined,
        body: l10n.housingAllocateUnknown,
      ),
      HandAllocationStatus.bedTaken => ToneCallout(
        tone: AppTone.warning,
        icon: Icons.bed_outlined,
        body: l10n.housingAllocateTaken(outcome.studentName),
      ),
      HandAllocationStatus.studentBanned => ToneCallout(
        tone: AppTone.danger,
        icon: Icons.block,
        body: l10n.housingAllocateBanned(outcome.studentName),
      ),
      HandAllocationStatus.none => const SizedBox.shrink(),
    };
  }
}
