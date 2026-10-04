import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';

/// The one field on the verification page: the code off the foot of a letter.
///
/// Set in the mono face and forced to capitals, because that is how the code
/// is printed and a visitor is copying it letter by letter. The tick in the
/// suffix appears once the code is the right length — a reading aid, not a
/// verdict; only the register gives one of those.
class VerificationCodeField extends StatelessWidget {
  const VerificationCodeField({
    required this.controller,
    required this.isComplete,
    required this.enabled,
    required this.onChanged,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;

  /// `true` once the code has the shape of one the register could answer.
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
          l10n.admissionsVerifyCodeLabel,
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
          inputFormatters: const [UpperCaseTextFormatter()],
          style: AppTextStyles.codeLarge.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: AppTextStyles.bold,
            letterSpacing: AppTextStyles.trackingCode,
          ),
          decoration: InputDecoration(
            hintText: l10n.admissionsVerifyCodeHint,
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

/// Keeps whatever is typed in capitals, caret and all.
class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
