import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';

/// Coloured pill carrying an application status or a bulletin category.
///
/// One widget for both, so "amber means the same thing" everywhere in the
/// portal: amber is actionable-but-not-yours (an offer, a warning), red is
/// closed and final, blue is in progress, green is done.
class StatusTag extends StatelessWidget {
  const StatusTag({
    required this.label,
    required this.tone,
    this.isUppercase = false,
    this.icon,
    super.key,
  });

  final String label;
  final AppTone tone;

  /// Spaced capitals, for tags that name a source or a programme rather than
  /// report a status. Application statuses stay in sentence case.
  final bool isUppercase;

  /// A glyph before the label, for the one verdict a colour alone should not
  /// have to carry. Most tags go without.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final foreground = tone.foreground(theme.brightness);
    final icon = this.icon;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.surface(theme.brightness),
        borderRadius: AppRadii.chipRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppDimensions.iconMicro, color: foreground),
            AppSpacing.horizontalGap(AppSpacing.xs),
          ],
          Text(
            isUppercase ? label.toUpperCase() : label,
            style: theme.textTheme.labelSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}

/// The localized label for an [ApplicationStatus].
///
/// The label is never derived from the enum's name: `offered` reads "Admission
/// offered", and `expired` reads "Offer expired" so the amber tone is explained
/// rather than looking like a mistake.
String applicationStatusLabel(
  AppLocalizations l10n,
  ApplicationStatus status,
) => switch (status) {
  ApplicationStatus.draft => l10n.admissionsStatusDraft,
  ApplicationStatus.submitted => l10n.admissionsStatusSubmitted,
  ApplicationStatus.underReview => l10n.admissionsStatusUnderReview,
  ApplicationStatus.offered => l10n.admissionsStatusOffered,
  ApplicationStatus.accepted => l10n.admissionsStatusAccepted,
  ApplicationStatus.declined => l10n.admissionsStatusDeclined,
  ApplicationStatus.rejected => l10n.admissionsStatusRejected,
  ApplicationStatus.withdrawn => l10n.admissionsStatusWithdrawn,
  ApplicationStatus.expired => l10n.admissionsStatusExpired,
  ApplicationStatus.matriculated => l10n.admissionsStatusMatriculated,
};
