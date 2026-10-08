import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../models/examinations_models.dart';

/// Asks the student to confirm a resit: the fee, and that both marks count.
///
/// Resolves to `true` only when they register; dismissing the sheet or
/// tapping "Not yet" resolves to `false`.
class ResitConfirmSheet extends StatelessWidget {
  const ResitConfirmSheet({
    required this.record,
    required this.failure,
    super.key,
  });

  final ResitsRecord record;
  final ResitFailure failure;

  static Future<bool> show(
    BuildContext context, {
    required ResitsRecord record,
    required ResitFailure failure,
  }) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.canvas(context.theme.brightness),
      builder: (_) => ResitConfirmSheet(record: record, failure: failure),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final muted = theme.colorScheme.onSurfaceVariant;
    final warning = AppTone.warning.foreground(theme.brightness);

    return SafeArea(
      child: SingleChildScrollView(
        padding: AppSpacing.sheet,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l10n.examResitConfirmTitle(failure.code),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: AppRadii.tagRadius,
                  ),
                  child: Text(
                    l10n.examResitConfirmTag(record.windowLabel),
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: AppRadii.blockRadius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.examResitConfirmUnits,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: muted,
                          ),
                        ),
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Flexible(
                        child: Text(
                          l10n.examResitConfirmRate(
                            formatNaira(record.feePerUnitMinorUnits),
                            failure.units,
                          ),
                          textAlign: TextAlign.end,
                          style: AppTextStyles.codeMedium.copyWith(
                            color: muted,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.examResitConfirmTotal.toUpperCase(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: AppTextStyles.semiBold,
                            letterSpacing: AppTextStyles.trackingCaps,
                          ),
                        ),
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Text(
                        l10n.examResitConfirmTotalValue(
                          formatNaira(record.feeFor(failure)),
                        ),
                        style: AppTextStyles.tabular(
                          AppTextStyles.codeLarge.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: AppDimensions.iconSmall,
                        color: theme.colorScheme.primary,
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.examResitConfirmInvoiceNote,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.help_outline,
                  size: AppDimensions.iconDense,
                  color: muted,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.examResitConfirmWithdraw,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: muted,
                      height: AppTextStyles.relaxedLineHeight,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh.withValues(
                  alpha: 0.6,
                ),
                borderRadius: AppRadii.blockRadius,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber,
                    size: AppDimensions.iconDense,
                    color: warning,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.examResitConfirmBothTitle.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: warning,
                            fontWeight: AppTextStyles.bold,
                            letterSpacing: AppTextStyles.trackingCaps,
                          ),
                        ),
                        AppSpacing.verticalGap(AppSpacing.xs),
                        Text(
                          l10n.examResitConfirmBothBody(
                            failure.failedScore,
                            failure.failedTermLabel,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(
                  AppDimensions.sheetActionHeight,
                ),
              ),
              icon: const Icon(Icons.check_circle_outline),
              label: Text(l10n.examResitConfirmAction),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(foregroundColor: muted),
              child: Text(l10n.examResitConfirmDecline),
            ),
          ],
        ),
      ),
    );
  }
}
