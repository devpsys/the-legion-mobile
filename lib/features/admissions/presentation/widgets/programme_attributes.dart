import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../models/programme_models.dart';

/// The localized name of a study mode.
String studyModeLabel(AppLocalizations l10n, StudyMode mode) => switch (mode) {
  StudyMode.undergraduateFullTime => l10n.admissionsStudyModeUndergraduate,
  StudyMode.directEntryFullTime => l10n.admissionsStudyModeDirectEntry,
  StudyMode.diplomaFullTime => l10n.admissionsStudyModeDiploma,
};

/// Duration and study mode, on a hairline-framed row.
///
/// Between two rules rather than floating in the card: it is the factual strip
/// a candidate scans past, and the rules let the eye skip it.
class ProgrammeAttributes extends StatelessWidget {
  const ProgrammeAttributes({
    required this.durationYears,
    required this.studyMode,
    super.key,
  });

  final int durationYears;
  final StudyMode studyMode;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    // `outline` is the muted icon role; `outlineVariant` is the hairline.
    final iconColor = theme.colorScheme.outline;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: theme.colorScheme.surfaceContainer),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, size: AppDimensions.iconSmall, color: iconColor),
          AppSpacing.horizontalGap(AppSpacing.xs),
          Flexible(
            child: Text(
              l10n.admissionsProgrammeDuration(durationYears),
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              '•',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outlineVariant,
              ),
            ),
          ),
          Icon(
            Icons.school_outlined,
            size: AppDimensions.iconSmall,
            color: iconColor,
          ),
          AppSpacing.horizontalGap(AppSpacing.xs),
          Flexible(
            child: Text(
              studyModeLabel(l10n, studyMode),
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
