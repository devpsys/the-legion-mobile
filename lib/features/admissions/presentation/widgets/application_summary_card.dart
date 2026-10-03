import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/admissions_models.dart';
import 'status_tag.dart';
import 'striped_card.dart';

/// One application in the candidate's list.
class ApplicationSummaryCard extends StatelessWidget {
  const ApplicationSummaryCard({
    required this.application,
    this.onTap,
    super.key,
  });

  final ApplicationSummary application;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final tracking = application.trackingCode;

    return StripedCard(
      tone: application.status.tone,
      isRaised: true,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  application.programmeName,
                  style: theme.textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  application.department,
                  style: theme.textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  DateFormat.yMMMd(l10n.localeName)
                      .format(application.submittedOn),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusTag(
                label: applicationStatusLabel(l10n, application.status),
                tone: application.status.tone,
              ),
              if (tracking != null) ...[
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  tracking,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
