import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/registration_models.dart';

/// Confirmation sheet when a drop would leave the student under minimum units.
class DropMinimumSheet extends StatelessWidget {
  const DropMinimumSheet({
    required this.course,
    required this.nextUnits,
    required this.minimumUnits,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  final RegisteredCourse course;
  final int nextUnits;
  final int minimumUnits;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  static Future<void> show(
    BuildContext context, {
    required RegisteredCourse course,
    required int nextUnits,
    required int minimumUnits,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: AppColors.transparent,
      builder: (context) => DropMinimumSheet(
        course: course,
        nextUnits: nextUnits,
        minimumUnits: minimumUnits,
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
            Row(
              children: [
                Container(
                  width: AppDimensions.monogramSize,
                  height: AppDimensions.monogramSize,
                  decoration: BoxDecoration(
                    color: AppColors.warningSurface(theme.brightness),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: AppDimensions.iconHero,
                    color: AppColors.warningText(theme.brightness),
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.registrationDropSheetTitle(course.code),
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              l10n.registrationDropSheetBody(minimumUnits, nextUnits),
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
              child: Text(l10n.registrationDropAnyway),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel();
              },
              child: Text(l10n.registrationKeepIt),
            ),
          ],
        ),
      ),
    );
  }
}
