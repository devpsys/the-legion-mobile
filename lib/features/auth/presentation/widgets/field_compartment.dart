import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Label above an input field.
///
/// The designs use a persistent, primary-coloured label rather than Material's
/// floating label, which keeps the credential compartments legible when both
/// fields are in their resting state.
class FieldLabel extends StatelessWidget {
  const FieldLabel({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.primary,
      ),
    );
  }
}

/// Helper / validation message under an input field.
class FieldHelper extends StatelessWidget {
  const FieldHelper({required this.text, this.isError = false, super.key});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style:
          (isError
                  ? theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    )
                  : theme.textTheme.bodySmall)
              ?.copyWith(height: AppTextStyles.denseLineHeight),
    );
  }
}

/// Compartment wrapping one labelled input plus its helper message.
class FieldCompartment extends StatelessWidget {
  const FieldCompartment({
    required this.label,
    required this.child,
    this.helper,
    this.isError = false,
    super.key,
  });

  final String label;
  final Widget child;
  final String? helper;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final hasHelper = helper != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(text: label),
        AppSpacing.verticalGap(AppSpacing.xs),
        child,
        if (hasHelper) ...[
          AppSpacing.verticalGap(AppSpacing.xs),
          FieldHelper(text: helper!, isError: isError),
        ],
      ],
    );
  }
}
