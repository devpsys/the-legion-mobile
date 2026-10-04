import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/admissions_cubit.dart';
import '../bloc/admissions_state.dart';
import '../models/programme_models.dart';
import 'cycle_notice.dart';
import 'cycle_picker_sheet.dart';
import 'faculty_filter_chips.dart';
import 'programme_card.dart';
import 'programme_search_field.dart';
import 'programmes_header.dart';

/// The loaded body of the programme browser.
///
/// Split from the page so the page decides only *which* state to show while this
/// decides what the ready state contains.
class ProgrammesBody extends StatelessWidget {
  const ProgrammesBody({required this.state, required this.now, super.key});

  final AdmissionsState state;

  /// Injected so the countdown and the open/closed reading are deterministic.
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdmissionsCubit>();
    final l10n = context.l10n;
    final cycle = state.selectedCycle;
    final visible = state.visibleProgrammes;

    return SingleChildScrollView(
      child: ResponsiveContent(
        maxWidth: AppDimensions.maxContentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProgrammesHeader(resultCount: visible.length),
            // The cycle notice is conditional because the catalogue and the
            // cycles arrive separately: without one there is no deadline or fee
            // to quote, and the cards below would compare against a guess.
            if (cycle != null)
              CycleNotice(
                cycle: cycle,
                now: now,
                onSwitchCycle: () => _switchCycle(context),
              ),
            AppSpacing.verticalGap(AppSpacing.md),
            ProgrammeSearchField(onChanged: cubit.searchProgrammes),
            FacultyFilterChips(
              counts: state.programmeCounts,
              selected: state.selectedFaculty,
              onSelected: cubit.selectFaculty,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            if (visible.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.canvasGutter,
                ),
                child: EmptyView(
                  message: _emptyMessage(l10n),
                  icon: Icons.search_off,
                ),
              )
            else
              for (final programme in visible)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: ProgrammeCard(
                    programme: programme,
                    now: now,
                    cycleClosesOn: cycle?.closesOn ?? programme.closesOn,
                    availability: state.applyAvailabilityFor(programme, now),
                    onApply: () => _apply(context, programme),
                    onViewDetails: () =>
                        context.showMessage(l10n.commonComingSoon),
                  ),
                ),
            AppSpacing.verticalGap(AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  /// Opens a draft to [programme] and takes the candidate straight to it.
  ///
  /// The cubit answers `null` when the record no longer allows it — a card
  /// drawn before the record changed — and then there is nothing to go to;
  /// the rebuild that follows takes the button away.
  void _apply(BuildContext context, Programme programme) {
    final id = context.read<AdmissionsCubit>().startApplication(
      programme.id,
      now: now,
    );
    if (id == null) return;
    context.goNamed(
      Routes.admissionsApplicationDetailName,
      pathParameters: {'id': id},
    );
  }

  Future<void> _switchCycle(BuildContext context) async {
    final cubit = context.read<AdmissionsCubit>();
    final chosen = await showCyclePicker(
      context,
      cycles: state.cycles,
      selectedCycleId: state.selectedCycleId,
      now: now,
    );

    // A dismissal changes nothing, which is what returning `null` is for.
    if (chosen != null) cubit.selectCycle(chosen);
  }

  /// Says *why* the list is empty.
  ///
  /// A bare "no results" after a filter is a dead end; naming the faculty or
  /// echoing the query tells the candidate which control to undo.
  String _emptyMessage(AppLocalizations l10n) {
    final query = state.programmeQuery.trim();

    if (query.isNotEmpty) return l10n.admissionsProgrammesNoResults(query);

    final faculty = state.selectedFaculty;
    if (faculty != null) {
      return l10n.admissionsProgrammesNoResultsFaculty(
        facultyLabel(l10n, faculty),
      );
    }
    return l10n.admissionsProgrammesNoResultsAll;
  }
}
