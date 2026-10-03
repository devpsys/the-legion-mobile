import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../models/admissions_models.dart';

/// The cycle the browser is quoting, and the way out of it.
///
/// A notice rather than a header row: what a candidate needs before reading a
/// fee is *which* cycle the fee belongs to and *when* it stops meaning anything.
class CycleNotice extends StatelessWidget {
  const CycleNotice({
    required this.cycle,
    required this.now,
    required this.onSwitchCycle,
    super.key,
  });

  final AdmissionCycle cycle;

  /// Injected so the open/closed reading is deterministic.
  final DateTime now;

  final VoidCallback onSwitchCycle;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final isOpen = cycle.isOpenAt(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: AppRadii.rowRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.calendar_today,
            size: AppDimensions.iconDense,
            color: theme.colorScheme.primaryContainer,
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cycle.name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Row(
                  children: [
                    // Expanded, not Flexible: the deadline is the part that
                    // grows in another language, so it takes the leftover
                    // after the fee rather than competing for the whole row.
                    Expanded(
                      child: Text(
                        isOpen
                            ? l10n.admissionsProgrammesCycleCloses(
                                DateFormat.yMMMd(l10n.localeName)
                                    .format(cycle.closesOn),
                              )
                            : l10n.admissionsProgrammesCycleClosed(
                                DateFormat.yMMMd(l10n.localeName)
                                    .format(cycle.closesOn),
                              ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: AppTextStyles.regular,
                        ),
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Text(
                      '•',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    // Money is quoted to the kobo, never rounded.
                    Text(
                      formatNaira(cycle.formFeeMinorUnits),
                      style: AppTextStyles.tabular(
                        AppTextStyles.codeSmall.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          // Height via the style, not a `SizedBox`: a `SizedBox` here would
          // hand the button an unbounded width and it would refuse to lay out.
          OutlinedButton(
            onPressed: onSwitchCycle,
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.outline),
              minimumSize: const Size(0, AppDimensions.buttonCompact),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              // The theme's button label is 13px; the design sets this one at
              // 11px, and the difference is 40px of the notice's text column
              // on a 390px phone.
              textStyle: theme.textTheme.labelSmall,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.elementRadius,
              ),
            ),
            child: Text(l10n.admissionsProgrammesSwitchCycle),
          ),
        ],
      ),
    );
  }
}
