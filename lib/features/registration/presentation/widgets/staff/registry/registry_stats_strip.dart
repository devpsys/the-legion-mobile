import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../models/staff/registry_models.dart';
import '../../../widgets/registration_card.dart';

/// Headline counts of the students directory.
class RegistryStatsStrip extends StatelessWidget {
  const RegistryStatsStrip({required this.stats, super.key});

  final RegistryDirectoryStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        RegistryStatTile(
          label: l10n.staffRegistryStatMatriculated,
          value: stats.matriculated,
          tone: AppTone.info,
        ),
        RegistryStatTile(
          label: l10n.staffRegistryStatusSuspended,
          value: stats.suspended,
          tone: AppTone.warning,
        ),
        RegistryStatTile(
          label: l10n.staffRegistryStatusWithdrawn,
          value: stats.withdrawn,
          tone: AppTone.neutral,
        ),
        RegistryStatTile(
          label: l10n.staffRegistryStatusExpelled,
          value: stats.expelled,
          tone: AppTone.danger,
        ),
        RegistryStatTile(
          label: l10n.staffRegistryStatusGraduated,
          value: stats.graduated,
          tone: AppTone.success,
        ),
      ],
    );
  }
}

/// One count on the directory header, accented by its tone.
class RegistryStatTile extends StatelessWidget {
  const RegistryStatTile({
    required this.label,
    required this.value,
    required this.tone,
    super.key,
  });

  final String label;
  final int value;
  final AppTone tone;

  /// Fixed tile width so the counts wrap into an even grid.
  static const double width = 108;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return SizedBox(
      width: width,
      child: RegistrationCard(
        clip: false,
        borderColor: tone.border(theme.brightness),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: AppTextStyles.trackingCaps,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              NumberFormat.decimalPattern(l10n.localeName).format(value),
              style: AppTextStyles.tabular(
                theme.textTheme.titleMedium!.copyWith(
                  color: tone.foreground(theme.brightness),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
