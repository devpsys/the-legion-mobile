import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/programme_models.dart';

/// The localized short name of a faculty.
///
/// Kept beside the chips rather than inside one, because the same four names
/// label the empty states and the results a filter has narrowed.
String facultyLabel(AppLocalizations l10n, Faculty faculty) =>
    switch (faculty) {
      Faculty.science => l10n.admissionsFacultyScience,
      Faculty.arts => l10n.admissionsFacultyArts,
      Faculty.law => l10n.admissionsFacultyLaw,
      Faculty.engineering => l10n.admissionsFacultyEngineering,
    };

/// Horizontal faculty filter above the catalogue.
///
/// Scrolling rather than wrapping: the chips carry counts, so they are wider
/// than a 390px canvas, and wrapping would push the first programme below the
/// fold on every phone.
class FacultyFilterChips extends StatelessWidget {
  const FacultyFilterChips({
    required this.counts,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Programmes per faculty, in [Faculty] order.
  final Map<Faculty, int> counts;

  /// `null` means "all faculties".
  final Faculty? selected;

  final ValueChanged<Faculty?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = counts.values.fold(0, (sum, count) => sum + count);

    return SizedBox(
      height: AppDimensions.filterChipRowHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.canvasGutter,
        ),
        children: [
          FacultyChip(
            label: l10n.admissionsFacultyFilterAll(total),
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          for (final faculty in Faculty.values)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: FacultyChip(
                // Positional, in the order `app_localizations.dart` declares
                // them — `count` then `faculty`, which is *not* the order they
                // appear in the ARB. Guessing from the ARB renders
                // "2 (Science)"; the chip test is what catches that.
                label: l10n.admissionsFacultyFilterNamed(
                  counts[faculty] ?? 0,
                  facultyLabel(l10n, faculty),
                ),
                isSelected: selected == faculty,
                // A faculty with nothing in it is shown but not offered: a chip
                // that vanishes whenever the catalogue changes would make the
                // filter feel unreliable, and so would a tap that changes
                // nothing a candidate can see.
                onTap: (counts[faculty] ?? 0) == 0
                    ? null
                    : () => onSelected(faculty),
              ),
            ),
        ],
      ),
    );
  }
}

/// One pill of [FacultyFilterChips].
class FacultyChip extends StatelessWidget {
  const FacultyChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;

  /// `null` disables the chip.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Center(
      child: Material(
        color: isSelected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainer,
        borderRadius: AppRadii.chipRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.chipRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: AppRadii.chipRadius,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            // Dimmed rather than dropped: an empty faculty is still an answer.
            child: Opacity(
              opacity: onTap == null ? disabledOpacity : 1,
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: isSelected
                      ? AppTextStyles.semiBold
                      : AppTextStyles.medium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// How far a chip the candidate cannot press is dimmed.
  static const double disabledOpacity = 0.6;
}
