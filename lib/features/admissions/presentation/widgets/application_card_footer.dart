import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';

/// The last row of an application card: what the status means for what
/// happens next.
///
/// Three shapes, because the three endings leave a candidate with three
/// different questions:
///
/// * an outstanding offer quotes the deadline that answers it, and stamps how
///   fresh the record is beside it;
/// * anything else prints that date on its own, so the card says how current
///   it is without pretending there is an action attached;
/// * a matriculation drops both for the matric number and the way into the
///   student portal — the application is finished, so there is nothing to tap.
class ApplicationCardFooter extends StatelessWidget {
  const ApplicationCardFooter({
    required this.application,
    required this.now,
    required this.onOpenPortal,
    super.key,
  });

  final ApplicationSummary application;

  /// Injected so the age stamp is read against the same clock as the rest of
  /// the screen rather than the device's, which is what keeps the test on it
  /// from going stale at midnight.
  final DateTime now;

  /// Leaves the portal for the student portal. Only offered where the
  /// application has somewhere to go.
  final VoidCallback onOpenPortal;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final matricNumber = application.matricNumber;
    final respondBy = application.respondBy;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: AppDimensions.hairline,
          // Half strength: the divider separates lines inside the card, so it
          // must stay quieter than the card's own border.
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        if (matricNumber != null)
          _matriculation(context, matricNumber)
        else if (respondBy != null)
          _offerDeadline(context, respondBy)
        else
          _lastUpdated(context),
      ],
    );
  }

  /// The bridge out of the portal: matriculation number, and the door.
  Widget _matriculation(BuildContext context, String matricNumber) {
    final theme = context.theme;
    final l10n = context.l10n;
    const tone = AppTone.success;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.admissionsMatriculation.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: AppTextStyles.trackingCaps,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                matricNumber,
                style: AppTextStyles.codeMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: onOpenPortal,
          style: OutlinedButton.styleFrom(
            foregroundColor: tone.foreground(theme.brightness),
            backgroundColor: tone.surface(theme.brightness),
            side: BorderSide.none,
            minimumSize: const Size(0, AppDimensions.buttonCompact),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.elementRadius,
            ),
          ),
          icon: const Icon(Icons.arrow_outward, size: AppDimensions.iconSmall),
          label: Text(l10n.admissionsOpenStudentPortal),
        ),
      ],
    );
  }

  /// The offer's response deadline, and the age of the record beside it.
  Widget _offerDeadline(BuildContext context, DateTime respondBy) {
    final theme = context.theme;
    final l10n = context.l10n;
    const tone = AppTone.warning;

    return Row(
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule_outlined,
                size: AppDimensions.iconSmall,
                color: tone.foreground(theme.brightness),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Flexible(
                child: Text(
                  l10n.admissionsRespondBy(
                    AppDateFormats.medium(l10n.localeName).format(respondBy),
                  ),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: tone.foreground(theme.brightness),
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                applicationUpdateLabel(l10n, application.updatedOn, now),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Icon(
              Icons.chevron_right,
              size: AppDimensions.iconMedium,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }

  /// The plain "when did this last move" line, for everything that is neither
  /// waiting on a deadline nor finished.
  Widget _lastUpdated(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            l10n.admissionsUpdatedOn(
              AppDateFormats.medium(l10n.localeName)
                  .format(application.updatedOn),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Icon(
          Icons.chevron_right,
          size: AppDimensions.iconMedium,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

/// The trailing stamp on an offer: how long ago the application changed.
///
/// Relative while the change still reads as an event — "3 hours ago" is what a
/// candidate wants beside an offer that landed this morning — and a date once
/// it is a matter of record, because "147 days ago" is arithmetic nobody
/// asked to do.
String applicationUpdateLabel(
  AppLocalizations l10n,
  DateTime updatedOn,
  DateTime now,
) {
  final age = now.difference(updatedOn);

  if (age > Duration.zero && age < const Duration(days: 1)) {
    if (age.inMinutes < 1) return l10n.admissionsAgeJustNow;
    if (age.inHours < 1) return l10n.admissionsAgeMinutes(age.inMinutes);
    return l10n.admissionsAgeHours(age.inHours);
  }

  return l10n.admissionsUpdatedOn(
    AppDateFormats.medium(l10n.localeName).format(updatedOn),
  );
}
