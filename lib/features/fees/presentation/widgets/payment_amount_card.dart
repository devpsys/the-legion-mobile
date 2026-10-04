import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/money.dart';
import '../bloc/fee_checkout_state.dart';
import '../models/fees_models.dart';
import 'checkout_option_tile.dart';

/// How much to pay: the whole balance, or an instalment the student types.
///
/// The instalment option is offered only while the balance is above the
/// permitted minimum; below it the only instalment allowed would be the
/// whole balance, which is the other option. The field opens under the
/// option when it is chosen, already holding the balance, so the student
/// edits a figure down rather than typing one from nothing.
class PaymentAmountCard extends StatelessWidget {
  const PaymentAmountCard({
    required this.state,
    required this.controller,
    required this.onModeChanged,
    required this.onInstalmentChanged,
    super.key,
  });

  final FeeCheckoutState state;

  /// The instalment field's text, owned by the body so it outlives rebuilds.
  final TextEditingController controller;

  final ValueChanged<PaymentAmountMode> onModeChanged;

  /// Called with the field's text on every edit.
  final ValueChanged<String> onInstalmentChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final isInstalment = state.amountMode == PaymentAmountMode.instalment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.feesSelectAmount.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: AppTextStyles.trackingCapsWide,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        RadioGroup<PaymentAmountMode>(
          groupValue: state.amountMode,
          onChanged: (mode) {
            if (mode != null) onModeChanged(mode);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CheckoutOptionTile<PaymentAmountMode>(
                value: PaymentAmountMode.full,
                isSelected: !isInstalment,
                title: l10n.feesPayFull,
                detail: l10n.feesPayFullDetail,
                trailing: Text(
                  formatNaira(state.fullPayableMinorUnits),
                  style: AppTextStyles.tabular(
                    AppTextStyles.codeMedium.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                onTap: () => onModeChanged(PaymentAmountMode.full),
              ),
              if (state.allowsInstalment) ...[
                AppSpacing.verticalGap(AppSpacing.sm),
                CheckoutOptionTile<PaymentAmountMode>(
                  value: PaymentAmountMode.instalment,
                  isSelected: isInstalment,
                  title: l10n.feesPayInstalment,
                  detail: l10n.feesMinimumInstalment(
                    formatNaira(state.minimumInstalmentMinorUnits),
                  ),
                  trailing: Icon(
                    isInstalment ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  extra: isInstalment
                      ? InstalmentField(
                          controller: controller,
                          state: state,
                          onChanged: onInstalmentChanged,
                        )
                      : null,
                  onTap: () => onModeChanged(PaymentAmountMode.instalment),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// The instalment, typed in naira with the symbol already in the decoration.
///
/// The field takes only digits, commas and a point; what it means is decided
/// by the cubit, which parses the text and names the problem — too little,
/// too much, not an amount — that the field then shows under itself.
class InstalmentField extends StatelessWidget {
  const InstalmentField({
    required this.controller,
    required this.state,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final FeeCheckoutState state;
  final ValueChanged<String> onChanged;

  /// Only what an amount is made of.
  static final RegExp allowedCharacters = RegExp(r'[\d.,]');

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    // An empty field is not yet wrong; a field with something in it that is
    // not an acceptable amount is.
    final problem = controller.text.trim().isEmpty
        ? null
        : instalmentProblemLabel(l10n, state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.feesSpecifiedAmount.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: AppTextStyles.trackingCaps,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(allowedCharacters),
          ],
          textAlign: TextAlign.end,
          style: AppTextStyles.tabular(
            AppTextStyles.codeLarge.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          decoration: InputDecoration(
            prefixText: nairaSymbol,
            prefixStyle: AppTextStyles.codeLarge.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            errorText: problem,
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}

/// The sentence for what is wrong with the typed instalment, or `null` when
/// nothing is.
String? instalmentProblemLabel(AppLocalizations l10n, FeeCheckoutState state) =>
    switch (state.instalmentProblem) {
      null => null,
      InstalmentProblem.missing => l10n.feesInstalmentMissing,
      InstalmentProblem.belowMinimum => l10n.feesInstalmentBelowMinimum(
        formatNaira(state.minimumInstalmentMinorUnits),
      ),
      InstalmentProblem.aboveBalance => l10n.feesInstalmentAboveBalance(
        formatNaira(state.balanceMinorUnits),
      ),
    };
