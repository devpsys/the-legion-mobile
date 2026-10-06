import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/widgets/status_tag.dart';
import '../../../models/staff/approvals_models.dart';

/// One course form in the HoD approvals queue.
class ApprovalQueueCard extends StatelessWidget {
  const ApprovalQueueCard({
    required this.item,
    required this.onReview,
    required this.onAdvise,
    super.key,
  });

  final ApprovalQueueItem item;
  final VoidCallback onReview;
  final VoidCallback onAdvise;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              StatusTag(
                label: item.processed
                    ? l10n.staffApprovalsQueueProcessed
                    : l10n.staffApprovalsQueuePending(item.pendingCourseCount),
                tone: item.processed ? AppTone.success : AppTone.warning,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.staffApprovalsQueueMeta(
              item.matricNumber,
              item.programmeCode,
              l10n.registrationLevel(item.level),
            ),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (item.atMinimum || item.hasClash) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                if (item.atMinimum)
                  StatusTag(
                    label: l10n.staffApprovalsFlagAtMinimum,
                    tone: AppTone.warning,
                  ),
                if (item.hasClash)
                  StatusTag(
                    label: l10n.staffApprovalsFlagClash,
                    tone: AppTone.info,
                  ),
              ],
            ),
          ],
          AppSpacing.verticalGap(AppSpacing.md),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: onReview,
                child: Text(
                  item.processed
                      ? l10n.staffApprovalsViewForm
                      : l10n.staffApprovalsReviewForm,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              TextButton(
                onPressed: onAdvise,
                child: Text(l10n.staffApprovalsStudyPlan),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
