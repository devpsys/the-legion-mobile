import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../models/application_detail_models.dart';
import 'section_surface.dart';

/// The card an application ends on when it did not end in a place.
///
/// One layout for every such ending, because they answer the same question —
/// "what happened, and what can I do now?" — and a candidate who has met one
/// should not have to learn another. What differs is only the tone of the
/// glyph, the sentence, and the one action offered; the README's rule for tone
/// is kept by the callers: an expiry is amber because nothing the candidate did
/// was wrong, a withdrawal or a refusal is red.
///
/// There is deliberately no withdraw button: a closed record has nothing left
/// to withdraw.
class ApplicationClosedStateCard extends StatelessWidget {
  const ApplicationClosedStateCard({
    required this.tone,
    required this.icon,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.body,
    this.reason,
    this.note,
    super.key,
  });

  final AppTone tone;

  /// The glyph in the badge — a clock, a cross, a lock.
  final IconData icon;

  final String title;

  /// What happened, in one sentence.
  final String? body;

  /// What the candidate said when they withdrew, quoted back to them.
  final String? reason;

  /// What happens next: whether they can apply again, and what stays on file.
  final String? note;

  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final body = this.body;
    final reason = this.reason;
    final note = this.note;

    return HubSectionSurface(
      padding: AppSpacing.sheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppDimensions.statusBadge,
            height: AppDimensions.statusBadge,
            decoration: BoxDecoration(
              color: tone.surface(theme.brightness),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconDisplay,
              color: tone.foreground(theme.brightness),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          if (body != null) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
          if (reason != null) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.subtle(theme.brightness),
                borderRadius: AppRadii.elementRadius,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Text(
                reason,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          if (note != null) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              note,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
          AppSpacing.verticalGap(AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, AppDimensions.buttonHeight),
              ),
              child: Text(actionLabel),
            ),
          ),
        ],
      ),
    );
  }
}

/// An offer that lapsed unanswered.
///
/// Amber, not red: the deadline passed while the candidate was busy, and the
/// card says so plainly — the place went to somebody else, the record stays,
/// and the next cycle is open to them.
class ApplicationExpiredCard extends StatelessWidget {
  const ApplicationExpiredCard({
    required this.detail,
    required this.onBrowse,
    super.key,
  });

  final ApplicationDetail detail;

  /// Opens the programme browser.
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expiredOn = detail.expiredOn;

    return ApplicationClosedStateCard(
      tone: AppTone.warning,
      icon: Icons.schedule_outlined,
      title: l10n.admissionsExpiredTitle,
      // A date the record cannot supply is left out rather than guessed.
      body: expiredOn == null
          ? null
          : l10n.admissionsExpiredBody(
              AppDateFormats.long(l10n.localeName).format(expiredOn),
              detail.application.programmeName,
            ),
      note: l10n.admissionsExpiredNote,
      actionLabel: l10n.admissionsBrowseProgrammes,
      onAction: onBrowse,
    );
  }
}

/// An application the candidate withdrew.
///
/// Red, but neutral-faced: it was the candidate's own decision, so the card
/// restates it and quotes their reason rather than telling them anything they
/// did not already know.
class ApplicationWithdrawnCard extends StatelessWidget {
  const ApplicationWithdrawnCard({
    required this.detail,
    required this.onStartNew,
    super.key,
  });

  final ApplicationDetail detail;

  /// Starts another application.
  final VoidCallback onStartNew;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final withdrawal = detail.withdrawal;
    final reason = withdrawal?.reason;

    return ApplicationClosedStateCard(
      tone: AppTone.danger,
      icon: Icons.cancel_outlined,
      title: l10n.admissionsWithdrawnTitle,
      body: withdrawal == null
          ? null
          : l10n.admissionsWithdrawnBody(
              AppDateFormats.long(l10n.localeName)
                  .format(withdrawal.withdrawnOn),
            ),
      reason: reason == null ? null : l10n.admissionsWithdrawnReason(reason),
      note: l10n.admissionsWithdrawnNote,
      actionLabel: l10n.admissionsStartNewApplication,
      onAction: onStartNew,
    );
  }
}

/// A refusal that carries no written decision.
///
/// The short form: when the committee has attached its reasons, the detail
/// screen draws the full decision instead. Contextualised with a next step
/// rather than left as a wall — a refusal says what is not possible and, in the
/// same breath, what is.
class ApplicationRejectedClosedCard extends StatelessWidget {
  const ApplicationRejectedClosedCard({
    required this.detail,
    required this.onBrowse,
    super.key,
  });

  final ApplicationDetail detail;

  /// Opens the programme browser.
  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ApplicationClosedStateCard(
      tone: AppTone.danger,
      icon: Icons.lock_outline,
      title: l10n.admissionsClosedRejectedTitle,
      body: l10n.admissionsClosedRejectedBody(detail.application.programmeName),
      note: l10n.admissionsClosedRejectedNote,
      actionLabel: l10n.admissionsBrowseProgrammes,
      onAction: onBrowse,
    );
  }
}
