import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// Confirmation sheet for withdrawing an application.
///
/// Asking first, and stating what withdrawal costs, because it is the one
/// action on this screen that cannot be undone — a candidate who taps it by
/// mistake while scrolling should meet a sentence explaining the consequence
/// before they lose the record.
class WithdrawApplicationSheet extends StatelessWidget {
  const WithdrawApplicationSheet({required this.onConfirm, super.key});

  /// Invoked after the sheet is dismissed.
  final VoidCallback onConfirm;

  /// Shows the sheet. Returns once it is dismissed.
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: AppColors.transparent,
      builder: (context) => WithdrawApplicationSheet(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final danger = AppColors.dangerText(theme.brightness);

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
            Row(
              children: [
                Container(
                  width: AppDimensions.monogramSize,
                  height: AppDimensions.monogramSize,
                  decoration: BoxDecoration(
                    color: AppColors.dangerSurface(theme.brightness),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.block,
                    size: AppDimensions.iconHero,
                    color: danger,
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.admissionsWithdrawTitle,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              l10n.admissionsWithdrawBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.xl),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: FilledButton.styleFrom(
                backgroundColor: danger,
                foregroundColor: theme.colorScheme.onError,
                minimumSize: const Size.fromHeight(
                  AppDimensions.sheetActionHeight,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.elementRadius,
                ),
              ),
              child: Text(l10n.admissionsWithdrawAction),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                minimumSize: const Size.fromHeight(
                  AppDimensions.sheetActionHeight,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.elementRadius,
                ),
              ),
              child: Text(l10n.commonCancel),
            ),
          ],
        ),
      ),
    );
  }
}
