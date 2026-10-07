import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/accommodation_cubit.dart';
import '../bloc/accommodation_state.dart';
import '../models/accommodation_models.dart';
import 'room_list_section.dart';
import 'term_selector.dart';

/// Body of the rooms screen: the room list when the selected term is open for
/// booking, otherwise the reason it is not and the way back.
class AccommodationRoomsBody extends StatelessWidget {
  const AccommodationRoomsBody({
    required this.state,
    required this.cubit,
    super.key,
  });

  final AccommodationState state;
  final AccommodationCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final term = state.current;
    if (term == null) return const SizedBox.shrink();

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
              TermSelector(
                terms: state.terms,
                selected: state.selectedTerm,
                onSelected: cubit.selectTerm,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              if (term.phase == AllocationPhase.roomList)
                RoomListSection(
                  key: ValueKey(term.term),
                  term: term,
                  cubit: cubit,
                )
              else ...[
                ToneCallout(
                  tone: AppTone.info,
                  icon: Icons.info_outline,
                  title: l10n.accommodationRoomsClosedTitle,
                  body: l10n.accommodationRoomsClosedBody(term.label),
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () => context.goNamed(Routes.accommodationName),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(l10n.accommodationRoomsBackToHub),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
