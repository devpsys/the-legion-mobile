import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../models/fees_models.dart';

/// Mono field for the public receipt check, auto-formatting as XXXX-XXXX-XXXX.
class ReceiptVerificationCodeField extends StatelessWidget {
  const ReceiptVerificationCodeField({
    required this.controller,
    required this.isComplete,
    required this.enabled,
    required this.onChanged,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final bool isComplete;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.feesVerifyCodeLabel,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: AppTextStyles.semiBold,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        TextField(
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.characters,
          autocorrect: false,
          enableSuggestions: false,
          inputFormatters: const [
            UpperCaseReceiptCodeFormatter(),
            ReceiptCodeGroupFormatter(),
          ],
          style: AppTextStyles.codeLarge.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: AppTextStyles.bold,
            letterSpacing: AppTextStyles.trackingCode,
          ),
          decoration: InputDecoration(
            hintText: l10n.feesVerifyCodeHint,
            hintStyle: AppTextStyles.codeLarge.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: AppTextStyles.trackingCode,
            ),
            suffixIcon: Icon(
              Icons.check_circle,
              size: AppDimensions.iconMedium,
              color: isComplete
                  ? AppTone.success.foreground(theme.brightness)
                  : theme.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }
}

/// Forces capitals as the visitor types.
class UpperCaseReceiptCodeFormatter extends TextInputFormatter {
  const UpperCaseReceiptCodeFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.toUpperCase();
    return newValue.copyWith(
      text: text,
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}

/// Groups a receipt code as `XXXX-XXXX-XXXX`.
class ReceiptCodeGroupFormatter extends TextInputFormatter {
  const ReceiptCodeGroupFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalised = normaliseReceiptVerificationCode(newValue.text);
    final clipped = normalised.length > receiptVerificationCodeLength
        ? normalised.substring(0, receiptVerificationCodeLength)
        : normalised;
    final text = formatReceiptVerificationCode(clipped);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
