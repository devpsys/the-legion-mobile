import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_block.dart';
import 'exam_office_labels.dart';

/// Who has a seat for a paper, and how to find seats for those who do not.
///
/// A paper seated in part is a recovery: the officer adds a room and the
/// remaining candidates are seated there. Nobody already seated moves.
class PaperSeatingPanel extends StatelessWidget {
  const PaperSeatingPanel({
    required this.session,
    required this.paper,
    required this.overflowRooms,
    super.key,
  });

  final ExamSession session;
  final ExamPaper paper;
  final List<OverflowRoom> overflowRooms;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final open = paper.status == PaperStatus.scheduled;
    final spare = [
      for (final room in overflowRooms)
        if (!paper.rooms.any((used) => used.name == room.name)) room,
    ];
    final progress = paper.enrolled == 0 ? 0.0 : paper.seated / paper.enrolled;

    return ExamOfficeBlock(
      title: l10n.examOfficeSeatingHeading,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.examOfficeSeatingCount(paper.enrolled, paper.seated),
                style: theme.textTheme.bodyMedium,
              ),
            ),
            StatusTag(
              label: ExamOfficeLabels.seating(l10n, paper.seating),
              tone: ExamOfficeLabels.seatingTone(paper.seating),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadii.chipRadius,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: AppDimensions.trackHeight,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        for (final room in paper.rooms)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(child: Text(room.name)),
                Text(
                  l10n.examOfficeRoomSeated(room.seated),
                  style: AppTextStyles.tabular(theme.textTheme.bodySmall!),
                ),
              ],
            ),
          ),
        if (paper.unseated > 0) ...[
          AppSpacing.verticalGap(AppSpacing.sm),
          ToneCallout(
            tone: paper.seating == SeatingStatus.partial
                ? AppTone.warning
                : AppTone.danger,
            icon: Icons.event_seat_outlined,
            title: l10n.examOfficeUnseatedTitle(paper.unseated),
            body: l10n.examOfficeUnseatedBody,
          ),
          if (open)
            for (final room in spare) ...[
              AppSpacing.verticalGap(AppSpacing.sm),
              OutlinedButton(
                onPressed: () => context.read<ExamOfficeCubit>().addRoom(
                  session.id,
                  paper.id,
                  room.name,
                ),
                child: Text(l10n.examOfficeAddRoom(room.capacity, room.name)),
              ),
            ],
        ],
      ],
    );
  }
}
