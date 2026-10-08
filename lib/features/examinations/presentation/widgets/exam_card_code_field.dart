import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/examinations_models.dart';

/// The check-code field of the hall-door check: letters and digits, upper
/// case, twelve of them.
class ExamCardCodeField extends StatelessWidget {
  const ExamCardCodeField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textCapitalization: TextCapitalization.characters,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      maxLength: examCardCodeLength,
      style: AppTextStyles.codeLarge,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
      ],
      decoration: InputDecoration(
        labelText: l10n.examVerifyCodeLabel,
        hintText: l10n.examVerifyCodeHint,
        helperText: l10n.examVerifyCodeHelper(examCardCodeLength),
        counterText: '',
      ),
    );
  }
}
