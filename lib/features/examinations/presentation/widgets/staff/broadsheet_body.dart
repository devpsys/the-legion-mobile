import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../bloc/staff/exam_office_state.dart';
import 'broadsheet_row_tile.dart';
import 'exam_office_block.dart';
import 'exam_office_empty_card.dart';

/// A course's published scores, student by student, with the course's mean
/// and pass rate on top.
class BroadsheetBody extends StatelessWidget {
  const BroadsheetBody({required this.state, super.key});

  final ExamOfficeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sheet = state.currentBroadsheet;

    if (sheet == null) {
      return ExamOfficeEmptyCard(
        icon: Icons.table_chart_outlined,
        title: l10n.examOfficeBroadsheetEmptyTitle,
        body: l10n.examOfficeBroadsheetEmptyBody,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (final entry in state.broadsheets)
              ChoiceChip(
                label: Text(entry.courseCode),
                selected: entry.courseCode == sheet.courseCode,
                onSelected: (_) => context
                    .read<ExamOfficeCubit>()
                    .selectBroadsheetCourse(entry.courseCode),
              ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        ExamOfficeBlock(
          title: sheet.courseCode,
          children: [
            ExamOfficeMetricRow(
              metrics: [
                ExamOfficeMetric(
                  value: '${sheet.enrolled}',
                  caption: l10n.examOfficeBroadsheetEnrolled,
                ),
                ExamOfficeMetric(
                  value: sheet.mean.toStringAsFixed(1),
                  caption: l10n.examOfficeBroadsheetMean,
                ),
                ExamOfficeMetric(
                  value: l10n.examOfficePercent(
                    sheet.passRate.toStringAsFixed(0),
                  ),
                  caption: l10n.examOfficeBroadsheetPassRate,
                ),
              ],
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        for (final row in sheet.rows) ...[
          BroadsheetRowTile(row: row),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
      ],
    );
  }
}
