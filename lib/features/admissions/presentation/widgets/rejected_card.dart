import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';
import '../models/application_detail_models.dart';
import '../models/programme_models.dart';
import 'faculty_filter_chips.dart';
import 'programme_attributes.dart';
import 'status_tag.dart';

/// The strip above a decision: whose portal this is, and which cycle it ends.
///
/// A red pip and a caption rather than a banner — the colour tells a candidate
/// the news before they read it, and the caption says this is final without
/// repeating the card below.
class ApplicationDecisionStrip extends StatelessWidget {
  const ApplicationDecisionStrip({required this.cycleSession, super.key});

  /// The session of the cycle the decision belongs to, e.g. `2025/2026`. The
  /// short form, so the chip holds its line beside the caption; the cycle's
  /// full name is quoted in the notice below.
  final String cycleSession;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Row(
      children: [
        Container(
          width: AppDimensions.indicator,
          height: AppDimensions.indicator,
          decoration: BoxDecoration(
            color: AppTone.danger.foreground(theme.brightness),
            shape: BoxShape.circle,
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          child: Text(
            l10n.admissionsDecisionContext.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: AppTextStyles.trackingCaps,
            ),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            borderRadius: AppRadii.tagRadius,
          ),
          child: Text(
            l10n.admissionsDecisionCycleChip(cycleSession),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// The headline of a refusal: the programme, the verdict, and the file it
/// belongs to.
///
/// A red band across the top and a status pill beside the name — the two ways
/// the portal says "closed and final" — over a recessed grid of the facts a
/// candidate quotes when they write to the registry: who, which reference, and
/// when it was filed and decided.
class ApplicationRejectedBanner extends StatelessWidget {
  const ApplicationRejectedBanner({
    required this.application,
    required this.notice,
    required this.programme,
    required this.applicantName,
    super.key,
  });

  final ApplicationSummary application;

  final RejectionNotice notice;

  /// The catalogue entry, to name its faculty and mode of study. `null` when
  /// the catalogue no longer carries it, in which case only the department is
  /// quoted.
  final Programme? programme;

  /// The candidate's name, or `null` while the profile is loading.
  final String? applicantName;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final programme = this.programme;
    final applicantName = this.applicantName;
    final trackingCode = application.trackingCode;
    // The faculty and the mode, not the department: a refusal is the
    // faculty's decision, and the mode names which cutoff it was held to.
    final subtitle = programme == null
        ? application.department
        : l10n.admissionsFacultyAndMode(
            facultyLabel(l10n, programme.faculty),
            studyModeLabel(l10n, programme.studyMode),
          );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: AppDimensions.accentStripe,
            color: AppTone.danger.accent(theme.brightness),
          ),
          Padding(
            padding: AppSpacing.sheet,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.admissionsDecisionProgrammeApplied
                                .toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: AppTextStyles.trackingCaps,
                            ),
                          ),
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            application.programmeName,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.md),
                    // The verdict in the committee's words, not the list's
                    // one-word status: this is the page that delivers it.
                    StatusTag(
                      label: l10n.admissionsDecisionUnsuccessful,
                      tone: application.status.tone,
                      icon: Icons.cancel,
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.lg),
                // A fact the record cannot supply is left out rather than
                // drawn as an empty cell under its caption.
                ApplicationFactGrid(
                  facts: [
                    if (applicantName != null)
                      ApplicationFact(
                        label: l10n.admissionsApplicantLabel,
                        value: applicantName,
                      ),
                    if (trackingCode != null)
                      ApplicationFact(
                        label: l10n.admissionsDecisionReference,
                        value: trackingCode,
                        isCode: true,
                        valueColor: theme.colorScheme.primary,
                      ),
                    ApplicationFact(
                      label: l10n.admissionsDecisionSubmittedOn,
                      value: _dateTime(l10n, application.submittedOn),
                      isCode: true,
                    ),
                    ApplicationFact(
                      label: l10n.admissionsDecisionDecidedOn,
                      value: _dateTime(l10n, notice.decidedOn),
                      isCode: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// `14 Sep 2026 • 09:00`.
  static String _dateTime(AppLocalizations l10n, DateTime value) =>
      l10n.admissionsDecisionDateTime(
        AppDateFormats.medium(l10n.localeName).format(value),
        AppDateFormats.time(l10n.localeName).format(value),
      );
}

/// The recessed grid of facts under a decision, two to a row.
///
/// Laid out in pairs rather than as a `GridView` because the rows are a
/// handful and their heights differ — a name wraps where a timestamp does not
/// — and a scroll view inside a scroll view is the one thing a card must not
/// be. An odd last fact keeps its half-width so the columns stay aligned.
class ApplicationFactGrid extends StatelessWidget {
  const ApplicationFactGrid({required this.facts, super.key});

  final List<Widget> facts;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final rows = <List<Widget>>[
      for (var i = 0; i < facts.length; i += 2)
        facts.sublist(i, i + 2 > facts.length ? facts.length : i + 2),
    ];

    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: AppColors.subtle(theme.brightness),
        borderRadius: AppRadii.blockRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (index, row) in rows.indexed) ...[
            if (index > 0) AppSpacing.verticalGap(AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: row.first),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: row.length > 1 ? row.last : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A labelled fact on a recessed grid: a muted caption over its value.
///
/// A reference or a timestamp is set in the mono face, the way the rest of the
/// portal sets a code, so it can be read digit by digit.
class ApplicationFact extends StatelessWidget {
  const ApplicationFact({
    required this.label,
    required this.value,
    this.isCode = false,
    this.valueColor,
    super.key,
  });

  final String label;
  final String value;

  /// Sets the value in the mono face, for a reference, a date or a number.
  final bool isCode;

  /// Overrides the value's colour — the brand colour for the reference, the
  /// one figure on the grid a candidate quotes back.
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final color = valueColor ?? theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          value,
          style: isCode
              ? AppTextStyles.codeMedium.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.semiBold,
                )
              : theme.textTheme.titleMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
