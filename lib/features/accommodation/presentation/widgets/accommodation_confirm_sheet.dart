import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// A bottom sheet that asks the student to confirm something that cannot be
/// undone: cancelling a booking, declining an offer.
///
/// [show] resolves to `true` only when the student confirms; closing the
/// sheet any other way is "keep it".
class AccommodationConfirmSheet extends StatelessWidget {
  const AccommodationConfirmSheet({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.keepLabel,
    super.key,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final String keepLabel;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
    required String keepLabel,
  }) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: AppColors.transparent,
      builder: (context) => AccommodationConfirmSheet(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
        keepLabel: keepLabel,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.xl,
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
                Icon(
                  Icons.warning_amber_outlined,
                  size: AppDimensions.iconHero,
                  color: theme.colorScheme.error,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmLabel),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(keepLabel),
            ),
          ],
        ),
      ),
    );
  }
}
