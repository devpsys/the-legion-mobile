import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../bloc/fee_card_checkout_cubit.dart';
import '../bloc/fee_card_checkout_state.dart';

/// Supported networks strip and the card fields on the card checkout.
///
/// Controllers stay in the parent body so rebuilds do not lose the caret;
/// this widget only draws and forwards changes.
class CardCheckoutForm extends StatelessWidget {
  const CardCheckoutForm({
    required this.state,
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
    required this.pin,
    super.key,
  });

  final FeeCardCheckoutState state;
  final TextEditingController cardNumber;
  final TextEditingController expiry;
  final TextEditingController cvv;
  final TextEditingController pin;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final cubit = context.read<FeeCardCheckoutCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.feesSupportedNetworks,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            StatusTag(label: l10n.feesNetworkMastercard, tone: AppTone.neutral),
            StatusTag(label: l10n.feesNetworkVerve, tone: AppTone.neutral),
            StatusTag(label: l10n.feesNetworkVisa, tone: AppTone.neutral),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.xl),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.feesCardInformation,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                l10n.feesCardInformationDetail,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              TextField(
                controller: cardNumber,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  const CardNumberInputFormatter(),
                ],
                onChanged: cubit.cardNumberChanged,
                style: AppTextStyles.codeLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  labelText: l10n.feesCardNumber,
                  hintText: l10n.feesCardNumberHint,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiry,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        const CardExpiryInputFormatter(),
                      ],
                      onChanged: cubit.expiryChanged,
                      style: AppTextStyles.codeMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.feesCardExpiry,
                        hintText: l10n.feesCardExpiryHint,
                      ),
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: cvv,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      onChanged: cubit.cvvChanged,
                      style: AppTextStyles.codeMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.feesCardCvv,
                        hintText: l10n.feesCardCvvHint,
                        suffixIcon: Tooltip(
                          message: l10n.feesCardCvvHelp,
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(
                            Icons.help_outline,
                            size: AppDimensions.iconSmall,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              TextField(
                controller: pin,
                keyboardType: TextInputType.number,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: cubit.pinChanged,
                style: AppTextStyles.codeMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  labelText: l10n.feesCardPin,
                  hintText: l10n.feesCardPinHint,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              Text(
                l10n.feesCardPinNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.feesSaveCard,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Switch.adaptive(
                    value: state.saveCard,
                    onChanged: cubit.saveCardChanged,
                  ),
                ],
              ),
              Text(
                l10n.feesCardTokenNote,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Groups card digits as `#### #### #### ####`.
class CardNumberInputFormatter extends TextInputFormatter {
  const CardNumberInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Formats expiry digits as `MM/YY`.
class CardExpiryInputFormatter extends TextInputFormatter {
  const CardExpiryInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
