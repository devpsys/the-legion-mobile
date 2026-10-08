import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/responsive.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_date_field.dart';
import 'exam_office_field.dart';

/// The open-a-session form, in a bottom sheet.
///
/// Opens a session in the semester the sessions list is showing. The cubit
/// checks the form; the sheet only closes when nothing is wrong.
class OpenSessionSheet extends StatefulWidget {
  const OpenSessionSheet({required this.termLabel, super.key});

  final String termLabel;

  /// Shows the sheet for the semester the list is on.
  static Future<void> show(BuildContext context) {
    final cubit = context.read<ExamOfficeCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider<ExamOfficeCubit>.value(
        value: cubit,
        child: OpenSessionSheet(termLabel: cubit.state.selectedTerm),
      ),
    );
  }

  @override
  OpenSessionSheetState createState() => OpenSessionSheetState();
}

/// State of [OpenSessionSheet].
class OpenSessionSheetState extends State<OpenSessionSheet> {
  final TextEditingController _name = TextEditingController();
  DateTime? _starts;
  DateTime? _ends;
  DateTime? _cardsOpen;
  Set<SessionDraftError> _errors = const {};

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final errors = context.read<ExamOfficeCubit>().openSession(
      SessionDraft(
        name: _name.text,
        termLabel: widget.termLabel,
        startsOn: _starts,
        endsOn: _ends,
        cardsOpenOn: _cardsOpen,
      ),
    );
    if (errors.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _errors = errors);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final datesMissing = _errors.contains(SessionDraftError.datesRequired);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          top: AppSpacing.xl,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.examOfficeOpenSessionTitle(widget.termLabel),
              style: context.theme.textTheme.titleLarge,
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            ExamOfficeField(
              label: l10n.examOfficeSessionNameLabel,
              controller: _name,
              errorText: _errors.contains(SessionDraftError.nameRequired)
                  ? l10n.examOfficeSessionNameRequired
                  : null,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ExamOfficeDateField(
              label: l10n.examOfficeSessionStarts,
              value: _starts,
              errorText: datesMissing && _starts == null
                  ? l10n.examOfficeDateRequired
                  : null,
              onChanged: (value) => setState(() => _starts = value),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ExamOfficeDateField(
              label: l10n.examOfficeSessionEnds,
              value: _ends,
              errorText: _errors.contains(SessionDraftError.endBeforeStart)
                  ? l10n.examOfficeSessionEndBeforeStart
                  : datesMissing && _ends == null
                  ? l10n.examOfficeDateRequired
                  : null,
              onChanged: (value) => setState(() => _ends = value),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ExamOfficeDateField(
              label: l10n.examOfficeSessionCardsOpen,
              value: _cardsOpen,
              errorText: _errors.contains(SessionDraftError.cardsAfterStart)
                  ? l10n.examOfficeSessionCardsAfterStart
                  : datesMissing && _cardsOpen == null
                  ? l10n.examOfficeDateRequired
                  : null,
              onChanged: (value) => setState(() => _cardsOpen = value),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            SizedBox(
              height: AppDimensions.sheetActionHeight,
              child: FilledButton(
                onPressed: _submit,
                child: Text(l10n.examOfficeOpenSession),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
