import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/money.dart';

/// The form fee of a programme, right-aligned against the title.
///
/// In the mono face with tabular figures: a candidate comparing four fees needs
/// the decimal points and the thousands separators to line up, and Inter's
/// proportional digits make ₦7,500.00 look narrower than ₦6,000.00.
class ProgrammeFee extends StatelessWidget {
  const ProgrammeFee({
    required this.minorUnits,
    required this.isMuted,
    super.key,
  });

  /// The fee in kobo. See `core/utils/money.dart`.
  final int minorUnits;

  /// Muted on a closed programme: the number is history, not a price.
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final foreground = isMuted
        ? theme.colorScheme.onSurfaceVariant
        : theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          // Spaced capitals: it is a column heading, not a sentence.
          l10n.admissionsProgrammeFormFee.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: AppTextStyles.trackingCaps,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          formatNaira(minorUnits),
          style: AppTextStyles.tabular(
            AppTextStyles.codeMedium.copyWith(
              color: foreground,
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}
