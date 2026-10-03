import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../models/application_detail_models.dart';
import 'application_checklist_row.dart';
import 'application_progress.dart';
import 'section_surface.dart';

/// "Before you submit" — the readiness checklist, and the one action left
/// when the candidate cannot fix a row themselves.
///
/// The count, the rows and the bar all read [ApplicationDetail]'s derived
/// totals, so a row the candidate completes changes all three at once; and
/// the two items the bursary cannot answer are listed with the rest rather
/// than hidden, because a candidate who cannot see them has no way to know
/// they are not theirs to fix.
class ApplicationChecklistCard extends StatelessWidget {
  const ApplicationChecklistCard({
    required this.detail,
    required this.showResendAction,
    required this.isResending,
    required this.onResend,
    required this.onAction,
    super.key,
  });

  final ApplicationDetail detail;

  /// Shown while the address on the record is unconfirmed.
  ///
  /// Deliberately not the banner's `needsEmailConfirmation`: the overview's
  /// banner can be dismissed for the session, and a candidate who hides a
  /// nag there should not lose the only way to answer it here.
  final bool showResendAction;

  /// The send is in flight; the button reports it instead of firing twice.
  final bool isResending;

  final VoidCallback onResend;

  /// What a row's action does, dispatched by the body: resending goes to the
  /// cubit, the invite row scrolls to the form on this same screen, and the
  /// rest report that they are not live yet.
  final ValueChanged<ChecklistAction> onAction;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(title: l10n.admissionsChecklistTitle),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.admissionsChecklistSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          ApplicationProgress(
            completed: detail.completedCount,
            total: detail.checklist.length,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          for (final item in detail.checklist) ...[
            const Divider(height: AppSpacing.xs),
            ApplicationChecklistRow(
              item: item,
              onAction: item.action == ChecklistAction.none
                  ? null
                  : () => onAction(item.action),
            ),
          ],
          if (showResendAction) ...[
            const Divider(height: AppSpacing.xs),
            AppSpacing.verticalGap(AppSpacing.lg),
            OutlinedButton(
              onPressed: isResending ? null : onResend,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, AppDimensions.buttonHeight),
              ),
              child: Text(
                isResending
                    ? l10n.admissionsResendingLink
                    : l10n.admissionsChecklistResendEmail,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.admissionsChecklistResendNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
