import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/programme_models.dart';

/// Days before a programme's own deadline at which the card turns red.
///
/// A fortnight, not a day: the deadline is a date on a form the candidate may
/// not have started, so urgency has to start while there is still time to do
/// something about it. A candidate who is told "closes in 10 days" and has not
/// heard anything at all still has a chance; one told "closes tomorrow" does not.
const int closingSoonDays = 14;

/// The strip along the bottom of a programme card: standing on the left,
/// action on the right.
///
/// Its own surface and top rule, so the action reads as belonging to the card
/// rather than floating in it — and so a long evaluation above never pushes it
/// out of reach.
class ProgrammeCardActions extends StatelessWidget {
  const ProgrammeCardActions({
    required this.programme,
    required this.now,
    required this.onApply,
    required this.onViewDetails,
    super.key,
  });

  final Programme programme;

  /// Injected so "closes in 10 days" is deterministic.
  final DateTime now;

  final VoidCallback onApply;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final isClosingSoon =
        !programme.isClosed && programme.daysUntilClose(now) <= closingSoonDays;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _standingLabel(l10n),
              maxLines: 2,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isClosingSoon
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          ProgrammeAction(
            programme: programme,
            onApply: onApply,
            onViewDetails: onViewDetails,
          ),
        ],
      ),
    );
  }

  String _standingLabel(AppLocalizations l10n) {
    if (programme.isClosed) return l10n.admissionsProgrammeArchived;

    final days = programme.daysUntilClose(now);
    return days <= closingSoonDays
        ? l10n.admissionsProgrammeClosesIn(days)
        : l10n.admissionsProgrammeAdmissionsActive;
  }
}

/// The card's single action.
///
/// Filled and forward-pointing while an application can be started; outlined and
/// outward-pointing once it cannot. The icon changes too, because "start
/// something new" and "read about a past session" are not the same offer.
class ProgrammeAction extends StatelessWidget {
  const ProgrammeAction({
    required this.programme,
    required this.onApply,
    required this.onViewDetails,
    super.key,
  });

  final Programme programme;
  final VoidCallback onApply;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final isOpen = programme.canApply;

    final label = Text(
      isOpen
          ? l10n.admissionsProgrammeApply
          : l10n.admissionsProgrammeViewDetails,
    );
    final icon = Icon(
      isOpen ? Icons.arrow_forward : Icons.arrow_outward,
      size: AppDimensions.iconSmall,
    );

    if (!isOpen) {
      return OutlinedButton.icon(
        onPressed: onViewDetails,
        // The glyph trails the label: this opens something that already exists,
        // rather than continuing the flow of the card.
        iconAlignment: IconAlignment.end,
        icon: icon,
        label: label,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          backgroundColor: theme.colorScheme.surfaceContainer,
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          // The theme stretches buttons to the full width; inside a `Row` that
          // is an infinite minimum, so a card action states its own size.
          minimumSize: const Size(0, AppDimensions.buttonCompact),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.elementRadius,
          ),
        ),
      );
    }

    return FilledButton.icon(
      onPressed: onApply,
      iconAlignment: IconAlignment.end,
      icon: icon,
      label: label,
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        minimumSize: const Size(0, AppDimensions.buttonCompact),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.elementRadius,
        ),
      ),
    );
  }
}
