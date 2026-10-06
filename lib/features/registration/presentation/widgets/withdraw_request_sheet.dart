import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// Confirmation sheet before withdrawing a pending academic petition.
class WithdrawRequestSheet extends StatelessWidget {
  const WithdrawRequestSheet({
    required this.title,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  final String title;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: AppColors.transparent,
      builder: (context) => WithdrawRequestSheet(
        title: title,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xl + AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadii.topSheet,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: AppDimensions.sheetHandleWidth,
                height: AppDimensions.sheetHandleHeight,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: AppRadii.chipRadius,
                ),
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            Text(l10n.requestsWithdrawTitle, style: theme.textTheme.titleLarge),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.requestsWithdrawBody(title),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text(l10n.requestsWithdrawConfirm),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel();
              },
              child: Text(l10n.commonCancel),
            ),
          ],
        ),
      ),
    );
  }
}
