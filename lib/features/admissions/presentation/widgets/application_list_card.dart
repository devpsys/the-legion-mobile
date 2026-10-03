import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/admissions_models.dart';
import 'application_card_footer.dart';
import 'status_tag.dart';
import 'striped_card.dart';

/// One application on the Applications tab — the "waiting screen".
///
/// Wider in scope than the compact [ApplicationSummaryCard] the overview
/// lists, because this is where a candidate comes to read the record rather
/// than glance at it: reference and status on one line, then the cycle, the
/// programme and whatever was recorded as a second choice, then the footer
/// that says what happens next.
///
/// The card that explains itself *why* it is finished sits **outside** the
/// surface: a rejection with its reason drawn on the card reads as a verdict
/// on the candidate, and the reason — the cycle closed — is a fact about the
/// calendar that belongs underneath.
class ApplicationListCard extends StatelessWidget {
  const ApplicationListCard({
    required this.application,
    required this.now,
    required this.onOpen,
    required this.onOpenPortal,
    super.key,
  });

  final ApplicationSummary application;

  /// Injected so the footer's age stamp is deterministic.
  final DateTime now;

  /// Opens the application's detail. Not offered on a matriculated
  /// application: the design gives it no chevron, and there is no detail
  /// screen behind a decision that is already carried out.
  final VoidCallback onOpen;

  /// Leaves the portal for the student portal, from a matriculated card.
  final VoidCallback onOpenPortal;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final cycleClosedOn = application.cycleClosedOn;
    final tracking = application.trackingCode;
    final secondChoice = application.secondChoiceName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        StripedCard(
          tone: application.status.tone,
          isRaised: true,
          // A matriculated application leads to the portal instead of to a
          // detail screen, so it carries no tap-through of its own.
          onTap: application.matricNumber == null ? onOpen : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: tracking == null
                        ? const SizedBox.shrink()
                        : Text(
                            tracking,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.codeLarge.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  StatusTag(
                    label: applicationStatusLabel(l10n, application.status),
                    tone: application.status.tone,
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                application.cycleName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                application.programmeName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
              if (secondChoice != null) ...[
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.admissionsSecondChoice(secondChoice),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.md),
              ApplicationCardFooter(
                application: application,
                now: now,
                onOpenPortal: onOpenPortal,
              ),
            ],
          ),
        ),
        if (cycleClosedOn != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              left: AppSpacing.md,
              right: AppSpacing.md,
            ),
            child: Text(
              l10n.admissionsCycleClosedNote(
                DateFormat.yMMMd(l10n.localeName).format(cycleClosedOn),
              ),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.denseLineHeight,
              ),
            ),
          ),
      ],
    );
  }
}
