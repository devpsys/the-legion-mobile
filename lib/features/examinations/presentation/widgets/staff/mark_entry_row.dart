import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_reason_dialog.dart';

/// One student's line on the marking sheet.
///
/// Editable while the batch is with the officer: the two parts are typed in,
/// the total and grade follow, and every change goes to the cubit. Once the
/// batch is with the approvers the row is read-only.
class MarkEntryRow extends StatefulWidget {
  const MarkEntryRow({
    required this.batch,
    required this.entry,
    required this.grade,
    super.key,
  });

  final MarkingBatch batch;
  final StudentMark entry;

  /// The letter the total earns, or `null` when there is none.
  final String? grade;

  @override
  MarkEntryRowState createState() => MarkEntryRowState();
}

/// State of [MarkEntryRow].
class MarkEntryRowState extends State<MarkEntryRow> {
  late final TextEditingController _coursework = TextEditingController(
    text: widget.entry.coursework?.toString() ?? '',
  );
  late final TextEditingController _exam = TextEditingController(
    text: widget.entry.exam?.toString() ?? '',
  );
  bool _outOfRange = false;

  @override
  void dispose() {
    _coursework.dispose();
    _exam.dispose();
    super.dispose();
  }

  void _changed() {
    final coursework = int.tryParse(_coursework.text.trim());
    final exam = int.tryParse(_exam.text.trim());
    final cwBad =
        _coursework.text.trim().isNotEmpty &&
        (coursework == null ||
            coursework < 0 ||
            coursework > MarkingBatch.maxCoursework);
    final examBad =
        _exam.text.trim().isNotEmpty &&
        (exam == null || exam < 0 || exam > MarkingBatch.maxExam);
    setState(() => _outOfRange = cwBad || examBad);
    if (cwBad || examBad) return;
    context.read<ExamOfficeCubit>().setMarks(
      widget.batch.id,
      widget.entry.matric,
      coursework: coursework,
      exam: exam,
    );
  }

  Future<void> _hold() async {
    final l10n = context.l10n;
    final cubit = context.read<ExamOfficeCubit>();
    final reason = await ExamOfficeReasonDialog.show(
      context,
      title: l10n.examOfficeHoldDialogTitle,
      body: l10n.examOfficeHoldDialogBody,
      confirmLabel: l10n.examOfficeHoldConfirm,
    );
    if (reason == null) return;
    cubit.holdMark(widget.batch.id, widget.entry.matric, reason);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final entry = widget.entry;
    final editable = widget.batch.isEditable && !entry.isHeld;
    final total = entry.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                  Text(
                    entry.matric,
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (entry.isFlagged)
              StatusTag(
                label: l10n.examOfficeMarkFlagged,
                tone: AppTone.warning,
              ),
            if (entry.isHeld)
              StatusTag(label: l10n.examOfficeFilterHeld, tone: AppTone.danger),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        if (entry.isHeld)
          Text(
            l10n.examOfficeMarkHeldReason(entry.holdReason ?? ''),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _coursework,
                  enabled: editable,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _changed(),
                  decoration: InputDecoration(
                    labelText: l10n.examOfficeMarkCoursework(
                      MarkingBatch.maxCoursework,
                    ),
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _exam,
                  enabled: editable,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _changed(),
                  decoration: InputDecoration(
                    labelText: l10n.examOfficeMarkExam(MarkingBatch.maxExam),
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    total == null ? l10n.examOfficeNoValue : '$total',
                    style: AppTextStyles.tabular(
                      theme.textTheme.titleMedium!.copyWith(
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                  ),
                  Text(
                    widget.grade ?? l10n.examOfficeNoValue,
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        if (_outOfRange) ...[
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examOfficeMarkOutOfRange,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
        if (entry.previousTotal != null) ...[
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examOfficeMarkPreviously(entry.previousTotal!),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (widget.batch.isEditable)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: entry.isHeld
                ? TextButton(
                    onPressed: () => context
                        .read<ExamOfficeCubit>()
                        .releaseHold(widget.batch.id, entry.matric),
                    child: Text(l10n.examOfficeMarkRelease),
                  )
                : TextButton(
                    onPressed: _hold,
                    child: Text(l10n.examOfficeMarkHold),
                  ),
          ),
      ],
    );
  }
}
