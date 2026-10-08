import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../bloc/staff/exam_office_state.dart';
import 'exam_office_empty_card.dart';
import 'exam_office_entry_card.dart';
import 'exam_office_labels.dart';
import 'open_session_sheet.dart';

/// The semester's examination sessions, or the empty state whose action is to
/// open the first one.
class SessionsBody extends StatelessWidget {
  const SessionsBody({required this.state, super.key});

  final ExamOfficeState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sessions = state.sessionsForTerm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (final term in state.termLabels)
              ChoiceChip(
                label: Text(term),
                selected: term == state.selectedTerm,
                onSelected: (_) =>
                    context.read<ExamOfficeCubit>().selectTerm(term),
              ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        if (sessions.isEmpty) ...[
          ExamOfficeEmptyCard(
            icon: Icons.event_busy_outlined,
            title: l10n.examOfficeSessionsEmptyTitle(state.selectedTerm),
            body: l10n.examOfficeSessionsEmptyBody,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          SizedBox(
            height: AppDimensions.primaryActionHeight,
            child: FilledButton(
              onPressed: () => OpenSessionSheet.show(context),
              child: Text(l10n.examOfficeOpenSession),
            ),
          ),
        ] else ...[
          for (final session in sessions) ...[
            ExamOfficeEntryCard(
              icon: Icons.event_note_outlined,
              title: session.name,
              body: l10n.examOfficeSessionBody(
                session.papers.length,
                ExamOfficeLabels.date(l10n, session.endsOn),
                ExamOfficeLabels.date(l10n, session.startsOn),
              ),
              trailing: StatusTag(
                label: ExamOfficeLabels.sessionStatus(l10n, session.status),
                tone: ExamOfficeLabels.sessionTone(session.status),
              ),
              onOpen: () => context.goNamed(
                Routes.examOfficeSessionName,
                pathParameters: {Routes.examOfficeSessionIdParam: session.id},
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
          AppSpacing.verticalGap(AppSpacing.sm),
          OutlinedButton(
            onPressed: () => OpenSessionSheet.show(context),
            child: Text(l10n.examOfficeOpenSession),
          ),
        ],
      ],
    );
  }
}
