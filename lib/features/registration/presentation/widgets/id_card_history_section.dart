import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/registration_models.dart';
import 'registration_card.dart';
import 'registration_chrome.dart';
import 'registration_labels.dart';

/// Past cards listed under the ID card request form.
class IdCardHistorySection extends StatelessWidget {
  const IdCardHistorySection({required this.record, super.key});

  final IdCardRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final history = record.history;
    final dateFormat = AppDateFormats.medium(l10n.localeName);
    final monthYear = AppDateFormats.monthYear(l10n.localeName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RegistrationSectionHeader(
          title: l10n.idCardHistoryTitle,
          countLabel: l10n.idCardHistoryCount(history.length),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        if (history.isEmpty)
          RegistrationCard(
            clip: false,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Icon(
                  Icons.badge_outlined,
                  size: AppDimensions.iconLarge,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  l10n.idCardHistoryEmptyTitle,
                  style: theme.textTheme.titleSmall,
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.idCardHistoryEmptyBody,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          RegistrationCard(
            child: Column(
              children: [
                for (var i = 0; i < history.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      color: theme.colorScheme.outlineVariant,
                    ),
                  IdCardHistoryRow(
                    entry: history[i],
                    requestedLabel: dateFormat.format(history[i].requestedOn),
                    expiresLabel: monthYear.format(history[i].expiresOn),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// One history ledger row with serial, reason line, and status tag.
class IdCardHistoryRow extends StatelessWidget {
  const IdCardHistoryRow({
    required this.entry,
    required this.requestedLabel,
    required this.expiresLabel,
    super.key,
  });

  final IdCardHistoryEntry entry;
  final String requestedLabel;
  final String expiresLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final reason = RegistrationLabels.idCardReason(l10n, entry.reason);
    final line = entry.isFirstCard
        ? l10n.idCardHistoryFirstCard(requestedLabel, expiresLabel)
        : entry.expired
        ? l10n.idCardHistoryLineExpired(
            reason,
            requestedLabel,
            expiresLabel,
          )
        : l10n.idCardHistoryLine(reason, requestedLabel, expiresLabel);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            entry.status == IdCardHistoryStatus.replaced
                ? Icons.credit_card_off_outlined
                : Icons.credit_card_outlined,
            size: AppDimensions.iconDense,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.serial,
                  style: AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  line,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          StatusTag(
            label: RegistrationLabels.idCardHistoryStatus(l10n, entry.status),
            tone: entry.status == IdCardHistoryStatus.collected
                ? AppTone.success
                : AppTone.neutral,
          ),
        ],
      ),
    );
  }
}
