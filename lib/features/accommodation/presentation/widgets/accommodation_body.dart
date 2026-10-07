import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/accommodation_cubit.dart';
import '../bloc/accommodation_state.dart';
import '../models/accommodation_models.dart';
import 'accommodation_header.dart';
import 'accommodation_link_card.dart';
import 'accommodation_support_card.dart';
import 'checked_in_section.dart';
import 'confirmed_bed_section.dart';
import 'held_bed_section.dart';
import 'needs_terms_card.dart';
import 'not_scheduled_card.dart';
import 'offered_bed_section.dart';
import 'room_list_section.dart';
import 'term_selector.dart';

/// Scrollable body of the Accommodation hub.
///
/// One screen that switches on the selected term's [AllocationPhase]: nothing
/// scheduled, the agreement gate, the room list, a held bed, a waitlist
/// offer, a confirmed bed or a resident.
class AccommodationBody extends StatelessWidget {
  const AccommodationBody({
    required this.state,
    required this.cubit,
    super.key,
  });

  final AccommodationState state;
  final AccommodationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final student = state.student;
    final term = state.current;
    if (student == null || term == null) return const SizedBox.shrink();
    final phase = term.phase;

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.md,
            bottom: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AccommodationHeader(
                student: student,
                termLabel: term.label,
                phase: phase,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              TermSelector(
                terms: state.terms,
                selected: state.selectedTerm,
                onSelected: cubit.selectTerm,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              switch (phase) {
                AllocationPhase.notScheduled => NotScheduledCard(
                  termLabel: term.label,
                ),
                AllocationPhase.needsTerms => NeedsTermsCard(
                  termLabel: term.label,
                  version: state.agreement?.version ?? '',
                  onOpenTerms: () =>
                      context.goNamed(Routes.accommodationTermsName),
                ),
                AllocationPhase.roomList => RoomListSection(
                  key: ValueKey(term.term),
                  term: term,
                  cubit: cubit,
                ),
                AllocationPhase.held => HeldBedSection(
                  state: state,
                  term: term,
                  cubit: cubit,
                ),
                AllocationPhase.offered => OfferedBedSection(
                  state: state,
                  term: term,
                  cubit: cubit,
                ),
                AllocationPhase.confirmed => ConfirmedBedSection(
                  state: state,
                  term: term,
                  cubit: cubit,
                ),
                AllocationPhase.checkedIn => CheckedInSection(term: term),
              },
              AppSpacing.verticalGap(AppSpacing.lg),
              AccommodationLinkCard(
                icon: Icons.history_edu_outlined,
                title: l10n.accommodationHistoryLinkTitle,
                body: l10n.accommodationHistoryLinkBody,
                onOpen: () => context.goNamed(Routes.accommodationHistoryName),
              ),
              if (phase != AllocationPhase.checkedIn) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                AccommodationSupportCard(
                  title: l10n.accommodationSupportTitle,
                  detail: l10n.accommodationSupportExtension,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
