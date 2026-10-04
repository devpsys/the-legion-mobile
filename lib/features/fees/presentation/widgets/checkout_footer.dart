import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';

/// The docked action of the checkout: the button that names the figure, and
/// the sentence that says the connection is safe and what paying unlocks.
///
/// The button is disabled, not hidden, while the instalment is not yet an
/// acceptable amount: the student should see where the action is and read
/// under the field why it is not available.
class CheckoutFooter extends StatelessWidget {
  const CheckoutFooter({
    required this.payableMinorUnits,
    required this.isEnabled,
    required this.onProceed,
    super.key,
  });

  /// What the button offers to charge; `null` while there is no amount.
  final int? payableMinorUnits;

  final bool isEnabled;

  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final payable = payableMinorUnits;

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
                    onPressed: isEnabled ? onProceed : null,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        AppDimensions.primaryActionHeight,
                      ),
                    ),
                    icon: const Icon(Icons.lock_outline),
                    label: Text(
                      payable == null
                          ? l10n.feesProceed
                          : l10n.feesProceedToPay(formatNaira(payable)),
                    ),
                  ),
                  AppSpacing.verticalGap(AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: AppDimensions.iconSmall,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Expanded(
                        child: Text(
                          l10n.feesProceedNote,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
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
