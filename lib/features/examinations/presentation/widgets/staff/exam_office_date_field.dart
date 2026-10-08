import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import 'exam_office_labels.dart';

/// A labelled field that opens a date picker. Shows [errorText] under it.
class ExamOfficeDateField extends StatelessWidget {
  const ExamOfficeDateField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String? errorText;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final value = this.value;

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
        InkWell(
          onTap: () => _pick(context),
          child: InputDecorator(
            decoration: InputDecoration(
              errorText: errorText,
              suffixIcon: const Icon(Icons.calendar_today_outlined),
            ),
            child: Text(
              value == null
                  ? l10n.examOfficeDatePlaceholder
                  : ExamOfficeLabels.date(l10n, value),
            ),
          ),
        ),
      ],
    );
  }
}
