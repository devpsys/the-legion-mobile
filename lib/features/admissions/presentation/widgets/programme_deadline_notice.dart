import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// Amber warning that a programme closes before the cycle does.
///
/// Only rendered when it is true. A candidate who reads "closes 28 February"
/// from the cycle notice and misses a department's earlier deadline discovers
/// it on the day the portal stops accepting applications.
class ProgrammeDeadlineNotice extends StatelessWidget {
  const ProgrammeDeadlineNotice({required this.deadline, super.key});

  /// The programme's own closing date, which is what the message states.
  final DateTime deadline;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        // A wash of the error container rather than a solid block: this is an
        // aside to the card, not the card's verdict, and a full-strength red
        // panel would be read as "blocked".
        color: theme.colorScheme.errorContainer.withValues(alpha: washOpacity),
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: theme.colorScheme.errorContainer),
      ),
      child: Row(
        children: [
          Icon(
            Icons.alarm,
            size: AppDimensions.iconSmall,
            color: theme.colorScheme.error,
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Text(
              l10n.admissionsProgrammeDeadlineAhead(
                DateFormat.yMMMd(l10n.localeName).format(deadline),
              ),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// How far the error container is washed out to become a notice.
  static const double washOpacity = 0.4;
}
