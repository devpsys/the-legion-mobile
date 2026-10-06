import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/responsive.dart';

/// Characters in an ID card verification code.
const int idCardVerificationCodeLength = 16;

/// Letters and digits only, in capitals, at most
/// [idCardVerificationCodeLength] long.
String normaliseIdCardVerificationCode(String raw) {
  final cleaned = raw.replaceAll(RegExp('[^A-Za-z0-9]'), '').toUpperCase();
  return cleaned.length > idCardVerificationCodeLength
      ? cleaned.substring(0, idCardVerificationCodeLength)
      : cleaned;
}

/// Mono field for the public ID card check.
class VerifyIdCardCodeField extends StatelessWidget {
  const VerifyIdCardCodeField({
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
          l10n.verifyIdCardCodeLabel,
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
          inputFormatters: const [IdCardCodeFormatter()],
          style: AppTextStyles.codeLarge.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: AppTextStyles.bold,
            letterSpacing: AppTextStyles.trackingCode,
          ),
          decoration: InputDecoration(
            hintText: l10n.verifyIdCardCodeHint,
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

/// Capitalises as the visitor types and drops anything that is not part of
/// a code, so a pasted code with spaces or dashes still reads.
class IdCardCodeFormatter extends TextInputFormatter {
  const IdCardCodeFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = normaliseIdCardVerificationCode(newValue.text);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
