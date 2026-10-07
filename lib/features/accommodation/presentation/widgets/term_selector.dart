import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../models/accommodation_models.dart';

/// "Book for term 1 / term 2": the switch that decides which term everything
/// below it is about.
class TermSelector extends StatelessWidget {
  const TermSelector({
    required this.terms,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<TermAccommodation> terms;
  final AccommodationTerm selected;
  final ValueChanged<AccommodationTerm> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final current = terms.where((term) => term.term == selected);
    final label = current.isEmpty ? '' : current.first.label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.accommodationBookFor,
          style: AppTextStyles.codeSmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: AppTextStyles.semiBold,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        SegmentedButton<AccommodationTerm>(
          showSelectedIcon: false,
          segments: [
            for (final term in terms)
              ButtonSegment<AccommodationTerm>(
                value: term.term,
                label: Text(term.label),
                icon: Icon(
                  term.term == selected
                      ? Icons.check_circle
                      : Icons.event_outlined,
                ),
              ),
          ],
          selected: {selected},
          onSelectionChanged: (values) => onSelected(values.first),
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        Text(
          l10n.accommodationEverythingBelow(label),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
