import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/widgets/responsive_content.dart';

/// Sticky decision bar under a course form: select, approve or reject.
class ApprovalActionBar extends StatelessWidget {
  const ApprovalActionBar({
    required this.selectedCount,
    required this.onSelectAll,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final int selectedCount;
  final VoidCallback onSelectAll;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final hasSelection = selectedCount > 0;

    return Material(
      color: theme.colorScheme.surface,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: SafeArea(
          top: false,
          child: ResponsiveContent(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.canvasGutter,
              vertical: AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.staffApprovalsSelectedCount(selectedCount),
                        style: AppTextStyles.codeSmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onSelectAll,
                      child: Text(l10n.staffApprovalsSelectAll),
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: hasSelection ? onReject : null,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                            AppDimensions.primaryActionHeight,
                          ),
                          foregroundColor: theme.colorScheme.error,
                        ),
                        child: Text(l10n.staffApprovalsRejectSelected),
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: hasSelection ? onApprove : null,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(
                            AppDimensions.primaryActionHeight,
                          ),
                        ),
                        child: Text(l10n.staffApprovalsApproveSelected),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
