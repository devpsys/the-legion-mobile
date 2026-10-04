import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Label above an input field.
///
/// The designs use a persistent, primary-coloured label rather than Material's
/// floating label, which keeps the credential compartments legible when both
/// fields are in their resting state.
///
/// A required field carries the marker after its text, in the error colour so
/// it reads as a flag rather than as part of the name.
class FieldLabel extends StatelessWidget {
  const FieldLabel({required this.text, this.isRequired = false, super.key});

  final String text;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelMedium?.copyWith(
      color: theme.colorScheme.primary,
    );
    if (!isRequired) return Text(text, style: style);

    return Text.rich(
      TextSpan(
        text: text,
        style: style,
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            text: context.l10n.fieldRequiredMarker,
            style: style?.copyWith(color: theme.colorScheme.error),
          ),
        ],
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
    this.isRequired = false,
    super.key,
  });

  final String label;
  final Widget child;
  final String? helper;
  final bool isError;

  /// Whether the label is flagged with the required marker.
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final hasHelper = helper != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(text: label, isRequired: isRequired),
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
