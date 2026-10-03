import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../models/programme_models.dart';
import 'section_surface.dart';

/// "Programme choices" — what the candidate is applying to, and what saving
/// the choice would cost.
///
/// The selects hold their values in the body rather than in a controller:
/// the fee line and the header's deadline both read the first choice, so a
/// value kept here would be one of two sources of truth that part company the
/// moment a candidate changes their mind.
class ApplicationChoicesCard extends StatelessWidget {
  const ApplicationChoicesCard({
    required this.options,
    required this.firstChoiceId,
    required this.secondChoiceId,
    required this.onFirstChoiceChanged,
    required this.onSecondChoiceChanged,
    required this.onSave,
    super.key,
  });

  /// Open programmes only: a closed one cannot be chosen, so it is not on the
  /// menu. The catalogue still lists it — the browser is where a candidate
  /// reads about Law and learns when it opens again.
  final List<Programme> options;

  final String? firstChoiceId;

  /// `null` while the candidate has picked only one.
  final String? secondChoiceId;

  final ValueChanged<String?> onFirstChoiceChanged;

  final ValueChanged<String?> onSecondChoiceChanged;

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final firstChoice = applicationChoiceById(options, firstChoiceId);

    return HubSectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(title: l10n.admissionsChoicesTitle),
          AppSpacing.verticalGap(AppSpacing.lg),
          ApplicationChoiceSelect(
            label: l10n.admissionsChoicesFirstLabel,
            isRequired: true,
            allowNone: false,
            selectedId: firstChoiceId,
            options: options,
            onChanged: onFirstChoiceChanged,
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          ApplicationChoiceSelect(
            label: l10n.admissionsChoicesSecondLabel,
            isRequired: false,
            allowNone: true,
            selectedId: secondChoiceId,
            // The candidate's own first choice is not a second one: offering
            // it here is how a form lets somebody apply to a single programme
            // twice without noticing.
            options: options
                .where((programme) => programme.id != firstChoiceId)
                .toList(),
            onChanged: onSecondChoiceChanged,
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(text: '${l10n.admissionsChoicesFee} '),
                      if (firstChoice != null)
                        TextSpan(
                          text: formatNaira(firstChoice.formFeeMinorUnits),
                          style: AppTextStyles.tabular(
                            AppTextStyles.codeMedium.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: AppTextStyles.semiBold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              OutlinedButton(
                onPressed: onSave,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, AppDimensions.buttonHeight),
                ),
                child: Text(l10n.admissionsChoicesSave),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One labelled `<select>` of the choices card.
///
/// A `DropdownButtonFormField` rather than a menu button because it is a
/// field: it carries a label, a required marker and the same borders the rest
/// of the portal's inputs wear, so a candidate recognises it as a form control
/// before reading the label.
class ApplicationChoiceSelect extends StatelessWidget {
  const ApplicationChoiceSelect({
    required this.label,
    required this.isRequired,
    required this.allowNone,
    required this.selectedId,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final String label;

  final bool isRequired;

  /// Offers the empty option, for the choice that is optional.
  final bool allowNone;

  final String? selectedId;

  final List<Programme> options;

  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    // A record can name a programme that is no longer on the menu — withdrawn
    // since he chose it — and a `DropdownButton` asserts when its value is
    // absent from the items, so an id that is not here falls back to empty.
    final value =
        selectedId != null && applicationChoiceById(options, selectedId) != null
        ? selectedId
        : (allowNone ? '' : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(label, style: theme.textTheme.labelLarge),
            if (!isRequired) ...[
              AppSpacing.horizontalGap(AppSpacing.sm),
              Text(
                l10n.admissionsChoicesOptional,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        DropdownButtonFormField<String>(
          // `initialValue`, not the deprecated `value`: they are the same
          // parameter today (`value` maps onto it), and the field's state
          // follows `initialValue` when the parent rebuilds with a different
          // choice — the guard above is what keeps that value on the menu.
          initialValue: value,
          isExpanded: true,
          isDense: true,
          style: theme.textTheme.bodyMedium,
          iconSize: AppDimensions.iconMedium,
          items: [
            if (allowNone)
              DropdownMenuItem<String>(
                value: '',
                child: Text(
                  l10n.admissionsChoicesNone,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final programme in options)
              DropdownMenuItem<String>(
                value: programme.id,
                child: Text(
                  programme.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: onChanged,
          // Borders, fill and padding come from the theme's input
          // decoration, so a select here wears exactly what every other field
          // in the portal wears.
          decoration: InputDecoration(isDense: true),
        ),
      ],
    );
  }
}

/// The catalogue entry for [id] among [options], or `null` when it is not
/// there — a `null` id, or one the record still names after a programme has
/// been withdrawn.
///
/// Public because both this card and the detail body resolve the same choice
/// (the fee here, the deadline there), and a second lookup written by hand is
/// how the two stop agreeing.
Programme? applicationChoiceById(List<Programme> options, String? id) {
  if (id == null) return null;
  for (final programme in options) {
    if (programme.id == id) return programme;
  }
  return null;
}
