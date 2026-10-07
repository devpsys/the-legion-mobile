import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// A labelled text field. The caller owns the [controller].
class HousingField extends StatelessWidget {
  const HousingField({
    required this.label,
    required this.controller,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.maxLines = 1,
    this.prefixText,
    this.onChanged,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? prefixText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.codeSmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          minLines: 1,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixText: prefixText,
          ),
        ),
      ],
    );
  }
}

/// A labelled whole-number control with minus and plus buttons.
class HousingStepper extends StatelessWidget {
  const HousingStepper({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.suffix,
    super.key,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final String? suffix;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final suffix = this.suffix;

    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        IconButton.outlined(
          onPressed: value - step < min ? null : () => onChanged(value - step),
          icon: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            suffix == null ? '$value' : '$value $suffix',
            style: AppTextStyles.tabular(theme.textTheme.titleMedium!),
          ),
        ),
        IconButton.outlined(
          onPressed: value + step > max ? null : () => onChanged(value + step),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
