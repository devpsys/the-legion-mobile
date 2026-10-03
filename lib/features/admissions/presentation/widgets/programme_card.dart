import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/programme_models.dart';
import 'programme_attributes.dart';
import 'programme_card_actions.dart';
import 'programme_card_header.dart';
import 'programme_deadline_notice.dart';
import 'programme_evaluation_pill.dart';

/// One programme in the catalogue.
///
/// Clipped so the action strip's fill runs to the card's rounded corners
/// instead of stopping short of them.
class ProgrammeCard extends StatelessWidget {
  const ProgrammeCard({
    required this.programme,
    required this.now,
    required this.cycleClosesOn,
    required this.onApply,
    required this.onViewDetails,
    super.key,
  });

  final Programme programme;

  /// Injected so the countdown is deterministic.
  final DateTime now;

  /// The cycle's deadline, so the card can flag a programme that closes before
  /// it. Without this a candidate reads the cycle's date off the notice above
  /// and assumes it applies here.
  final DateTime cycleClosesOn;

  final VoidCallback onApply;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    // Suppressed on a closed programme: its date is already on the "Closed on"
    // tag beside the faculty, and an "ahead of the cycle" warning about a
    // deadline that has passed is noise at best.
    final closesAheadOfCycle =
        !programme.isClosed && programme.closesOn.isBefore(cycleClosesOn);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.rowRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: AppSpacing.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ProgrammeCardHeader(programme: programme),
                AppSpacing.verticalGap(AppSpacing.md),
                ProgrammeAttributes(
                  durationYears: programme.durationYears,
                  studyMode: programme.studyMode,
                ),
                if (closesAheadOfCycle) ...[
                  AppSpacing.verticalGap(AppSpacing.md),
                  ProgrammeDeadlineNotice(deadline: programme.closesOn),
                ],
                AppSpacing.verticalGap(AppSpacing.md),
                ProgrammeEvaluationPill(programme: programme),
              ],
            ),
          ),
          ProgrammeCardActions(
            programme: programme,
            now: now,
            onApply: onApply,
            onViewDetails: onViewDetails,
          ),
        ],
      ),
    );
  }
}
