import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/programme_models.dart';

/// The localized headline of a [ProgrammeVerdict].
///
/// Three headlines and a fourth, because "not tracked" is not a failure. See
/// the module README: an unverified requirement must never be drawn as one.
String programmeVerdictLabel(AppLocalizations l10n, ProgrammeVerdict verdict) =>
    switch (verdict) {
      ProgrammeVerdict.eligible => l10n.admissionsVerdictEligible,
      ProgrammeVerdict.needsChecking => l10n.admissionsVerdictNeedsChecking,
      ProgrammeVerdict.notEligible => l10n.admissionsVerdictNotEligible,
      ProgrammeVerdict.closed => l10n.admissionsVerdictClosed,
    };

/// The glyph that carries a [ProgrammeVerdict].
///
/// The icon is not decoration — it is the first thing a candidate reads, so it
/// has to be able to say "nobody could check this" rather than "you failed".
IconData programmeVerdictIcon(ProgrammeVerdict verdict) => switch (verdict) {
  ProgrammeVerdict.eligible => Icons.check_circle,
  ProgrammeVerdict.needsChecking => Icons.warning,
  ProgrammeVerdict.notEligible => Icons.do_not_disturb_on,
  ProgrammeVerdict.closed => Icons.do_not_disturb_on,
};

/// The sentence under a verdict headline.
///
/// A closed programme gets its own: repeating a requirement list under
/// "applications have closed" would imply the requirements still decide it.
String programmeVerdictSummary(AppLocalizations l10n, Programme programme) =>
    programme.isClosed
    ? l10n.admissionsVerdictClosedSummary
    : programme.evaluationSummary;

/// Eligibility callout on a programme card.
class ProgrammeEvaluationPill extends StatelessWidget {
  const ProgrammeEvaluationPill({required this.programme, super.key});

  final Programme programme;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final verdict = programme.verdict;
    final tone = verdict.tone;
    final brightness = theme.brightness;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: tone.surface(brightness),
        borderRadius: AppRadii.elementRadius,
        // A hairline of the same hue: the callout gets an edge without
        // competing with the card's own outline.
        border: Border.all(
          color: tone.foreground(brightness).withValues(alpha: hairlineOpacity),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            programmeVerdictIcon(verdict),
            size: AppDimensions.iconDense,
            color: tone.foreground(brightness),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  programmeVerdictLabel(l10n, verdict),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: tone.foreground(brightness),
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  programmeVerdictSummary(l10n, programme),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: tone.foreground(brightness),
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Strength of a tone's own hairline, so the callout's border reads as a
  /// quieter version of its fill instead of a second outline.
  static const double hairlineOpacity = 0.32;
}
