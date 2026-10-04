import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// One line of a record's terms: a muted label, and the value it names.
///
/// The note rides beside the value rather than under it, and wraps below it
/// only when the row runs out of width — a fee and the word "paid" belong to
/// the same fact, and a note on its own line reads as a second one.
///
/// A value that is a figure — an amount, a reference, a timestamp — is set in
/// the mono face with tabular digits, the way every other figure in the app
/// is, so two rows of them line up and a sum can be read digit by digit.
class LabelledValueRow extends StatelessWidget {
  const LabelledValueRow({
    required this.label,
    required this.value,
    this.isCode = false,
    this.note,
    this.noteColor,
    this.valueColor,
    super.key,
  });

  final String label;
  final String value;

  /// Sets the value in the mono face: for money, references and dates.
  final bool isCode;

  /// A qualifier on the value, e.g. when a fee was paid.
  final String? note;

  /// Overrides the note's muted colour, for a note that is a warning.
  final Color? noteColor;

  /// Overrides the value's colour, for a figure that carries a verdict — an
  /// amount cleared in green, a balance owed in amber.
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final note = this.note;
    final valueStyle = isCode
        ? AppTextStyles.codeMedium.copyWith(
            color: valueColor ?? theme.colorScheme.onSurface,
            fontWeight: AppTextStyles.semiBold,
          )
        : theme.textTheme.bodyLarge!.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.semiBold,
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.sm,
            children: [
              Text(value, style: AppTextStyles.tabular(valueStyle)),
              if (note != null)
                Text(
                  note,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: noteColor ?? theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
