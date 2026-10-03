import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../models/programme_models.dart';
import 'faculty_filter_chips.dart';
import 'programme_fee.dart';

/// The name and department of a programme, with its faculty and fee beside it.
class ProgrammeCardHeader extends StatelessWidget {
  const ProgrammeCardHeader({required this.programme, super.key});

  final Programme programme;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final closedOn = programme.closedOn;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  ProgrammeFacultyTag(faculty: programme.faculty),
                  // A closed programme says so next to its faculty, where the
                  // eye lands first — not only in the action strip at the
                  // bottom, which a candidate may never scroll to.
                  if (closedOn != null)
                    ProgrammeClosedTag(
                      label: l10n.admissionsProgrammeClosedOn(
                        DateFormat.yMMMd(l10n.localeName).format(closedOn),
                      ),
                    ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                programme.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(programme.department, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        ProgrammeFee(
          minorUnits: programme.formFeeMinorUnits,
          isMuted: programme.isClosed,
        ),
      ],
    );
  }
}

/// The faculty a programme sits in, as spaced capitals.
///
/// Uppercase and small on purpose: it is the classification, not the name.
class ProgrammeFacultyTag extends StatelessWidget {
  const ProgrammeFacultyTag({required this.faculty, super.key});

  final Faculty faculty;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: AppRadii.checkboxRadius,
      ),
      child: Text(
        facultyLabel(l10n, faculty).toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          letterSpacing: AppTextStyles.trackingCaps,
        ),
      ),
    );
  }
}

/// The date a programme stopped accepting applications.
///
/// Neutral rather than amber or red: the candidate did nothing wrong, and the
/// thing they can still do is note the date and come back next cycle.
class ProgrammeClosedTag extends StatelessWidget {
  const ProgrammeClosedTag({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppTone.neutral.surface(theme.brightness),
        borderRadius: AppRadii.checkboxRadius,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
