import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';

/// Lets the candidate pick which cycle the browser quotes.
///
/// Returns the chosen cycle's id, or `null` if dismissed without choosing —
/// so the caller decides what a dismissal means, and an unchanged selection
/// costs nothing.
///
/// A closed cycle stays selectable. Hiding it would tell a candidate the
/// university no longer runs that programme at all, which is a different and
/// wrong answer.
Future<String?> showCyclePicker(
  BuildContext context, {
  required List<AdmissionCycle> cycles,
  required String? selectedCycleId,
  required DateTime now,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: AppColors.transparent,
    builder: (context) => CyclePickerSheet(
      cycles: cycles,
      selectedCycleId: selectedCycleId,
      now: now,
    ),
  );
}

/// Sheet listing every cycle the candidate can apply to.
class CyclePickerSheet extends StatelessWidget {
  const CyclePickerSheet({
    required this.cycles,
    required this.selectedCycleId,
    required this.now,
    super.key,
  });

  final List<AdmissionCycle> cycles;
  final String? selectedCycleId;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              MediaQuery.sizeOf(context).height *
              AppDimensions.sheetMaxHeightFactor,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadii.topSheet,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: AppDimensions.sheetHandleWidth,
                  height: AppDimensions.sheetHandleHeight,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: AppRadii.chipRadius,
                  ),
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.admissionsProgrammesCyclePickerTitle,
                style: theme.textTheme.headlineSmall,
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Text(
                l10n.admissionsProgrammesCyclePickerBody,
                style: theme.textTheme.bodySmall,
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: cycles.length,
                  separatorBuilder: (context, index) =>
                      AppSpacing.verticalGap(AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final cycle = cycles[index];
                    return CycleOption(
                      cycle: cycle,
                      now: now,
                      isSelected: cycle.id == selectedCycleId,
                      onTap: () => Navigator.of(context).pop(cycle.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One selectable cycle in [CyclePickerSheet].
class CycleOption extends StatelessWidget {
  const CycleOption({
    required this.cycle,
    required this.now,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final AdmissionCycle cycle;
  final DateTime now;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final isOpen = cycle.isOpenAt(now);
    final deadline = AppDateFormats.medium(l10n.localeName)
        .format(cycle.closesOn);

    return Material(
      color: isSelected
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.surfaceContainerHigh,
      borderRadius: AppRadii.rowRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.rowRadius,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cycle.name, style: theme.textTheme.titleMedium),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      isOpen
                          ? l10n.admissionsProgrammesCycleCloses(deadline)
                          : l10n.admissionsProgrammesCycleClosed(deadline),
                      style: theme.textTheme.bodySmall,
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    Text(
                      formatNaira(cycle.formFeeMinorUnits),
                      style: AppTextStyles.tabular(AppTextStyles.codeSmall),
                    ),
                  ],
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: AppDimensions.iconHero,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
