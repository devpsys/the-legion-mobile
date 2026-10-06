import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';

/// A single-select row of filter chips for staff queues.
///
/// Generic over the filter type so the approvals queue, the request queue,
/// the directory status filter (nullable: `null` is "any") and the ID card
/// tabs share one chip treatment.
class StaffFilterChips<T> extends StatelessWidget {
  const StaffFilterChips({
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    super.key,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final value in values)
          ChoiceChip(
            label: Text(labelOf(value)),
            selected: value == selected,
            onSelected: (_) => onSelected(value),
          ),
      ],
    );
  }
}
