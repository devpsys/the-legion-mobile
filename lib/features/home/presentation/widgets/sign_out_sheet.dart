import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';

/// Confirmation sheet for signing out.
///
/// Signing out ends the session, so it asks first — and states what is needed
/// to get back in, which is the question a student has at that moment.
class SignOutSheet extends StatelessWidget {
  const SignOutSheet({required this.onConfirm, super.key});

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
      backgroundColor: Colors.transparent,
      builder: (context) => SignOutSheet(onConfirm: onConfirm),
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
                width: 40,
                height: 6,
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.dangerSurface(theme.brightness),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.logout, size: 22, color: danger),
                ),
                AppSpacing.horizontalGap(AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.homeSignOut,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              l10n.homeSignOutBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.45,
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
                minimumSize: const Size.fromHeight(48),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.elementRadius,
                ),
              ),
              child: Text(l10n.homeSignOut),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                backgroundColor: theme.colorScheme.surfaceContainerHigh,
                minimumSize: const Size.fromHeight(48),
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
