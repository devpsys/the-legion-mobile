import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radii.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/responsive.dart';
import '../../models/staff/housing_models.dart';
import 'housing_labels.dart';

/// One bed on a room's grid: its number, an icon for its state and, to
/// screen readers, the state and the occupant.
class HousingBedChip extends StatelessWidget {
  const HousingBedChip({required this.bed, required this.dimmed, super.key});

  final HousingBed bed;

  /// The room is not open, so every bed reads as blocked.
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final state = dimmed ? BedState.blocked : bed.state;
    final tone = HousingLabels.bedTone(state);
    final brightness = theme.brightness;
    final occupant = bed.occupant;

    return Semantics(
      label: occupant == null
          ? l10n.housingBedSemantics(
              bed.number,
              HousingLabels.bedState(l10n, state),
            )
          : l10n.housingBedSemanticsOccupied(
              bed.number,
              HousingLabels.bedState(l10n, state),
              occupant,
            ),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: tone.surface(brightness),
          borderRadius: AppRadii.tagRadius,
          border: Border.all(color: tone.border(brightness)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              HousingLabels.bedIcon(state),
              size: AppDimensions.iconSmall,
              color: tone.foreground(brightness),
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Text(
              '${bed.number}',
              style: AppTextStyles.codeSmall.copyWith(
                color: tone.foreground(brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
