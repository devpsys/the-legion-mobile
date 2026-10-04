import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';

/// Docked Pay action, redirect note, cancel link and assurance strip.
class CardCheckoutFooter extends StatelessWidget {
  const CardCheckoutFooter({
    required this.totalMinorUnits,
    required this.isEnabled,
    required this.transactionReference,
    required this.onPay,
    required this.onCancel,
    super.key,
  });

  final int totalMinorUnits;
  final bool isEnabled;
  final String transactionReference;
  final VoidCallback onPay;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton.icon(
                    onPressed: isEnabled ? onPay : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        AppDimensions.primaryActionHeight,
                      ),
                    ),
                    icon: const Icon(Icons.lock_outline),
                    label: Text(
                      l10n.feesPayAmountAction(formatNaira(totalMinorUnits)),
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Text(
                    l10n.feesPayRedirectNote,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                  TextButton(
                    onPressed: onCancel,
                    child: Text(l10n.feesCancelToFees),
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Text(
                    l10n.feesCbnLicensed,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    l10n.feesEndToEndEncryption,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.xs),
                  Text(
                    l10n.feesTransactionReference(transactionReference),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
