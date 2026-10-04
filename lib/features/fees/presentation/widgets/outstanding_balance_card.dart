import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';

/// The hero of the fees tab: everything owed, when it is due, what it is
/// made of, and the one button that pays it.
///
/// The total is handed in already summed by the state from the same open
/// invoices the strip lists, so the figure and its breakdown cannot
/// disagree. With nothing owed the card says so and offers no button: a
/// payment screen must never invite a payment of nothing.
class OutstandingBalanceCard extends StatelessWidget {
  const OutstandingBalanceCard({
    required this.outstandingMinorUnits,
    required this.invoices,
    required this.dueOn,
    required this.onPay,
    super.key,
  });

  /// Everything owed, in kobo.
  final int outstandingMinorUnits;

  /// The open invoices the total is made of.
  final List<Invoice> invoices;

  /// The earliest deadline among them; `null` when nothing is owed.
  final DateTime? dueOn;

  /// Opens the checkout for every open invoice.
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final dueOn = this.dueOn;
    final hasOutstanding = outstandingMinorUnits > 0;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    l10n.feesOutstandingLabel.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: AppTextStyles.trackingCapsWide,
                    ),
                  ),
                ),
              ),
              if (dueOn != null) ...[
                AppSpacing.horizontalGap(AppSpacing.sm),
                StatusTag(
                  label: l10n.feesDueOn(
                    AppDateFormats.long(l10n.localeName).format(dueOn),
                  ),
                  tone: AppTone.warning,
                  icon: Icons.schedule_outlined,
                ),
              ],
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            formatNaira(outstandingMinorUnits),
            style: AppTextStyles.tabular(
              theme.textTheme.headlineLarge!.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          if (hasOutstanding) ...[
            if (invoices.length > 1) ...[
              OutstandingBreakdownStrip(invoices: invoices),
              AppSpacing.verticalGap(AppSpacing.lg),
            ],
            FilledButton.icon(
              onPressed: onPay,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward),
              label: Text(
                l10n.feesPayOutstanding(formatNaira(outstandingMinorUnits)),
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              l10n.feesPaymentChannelsNote,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ] else
            Text(
              l10n.feesNothingOutstanding,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.successText(theme.brightness),
              ),
            ),
        ],
      ),
    );
  }
}

/// The open invoices the outstanding total is made of, each named with its
/// balance.
///
/// A `Wrap` rather than one line with separators: two bills fit a phone
/// width, a third or a long translation drops to the next line instead of
/// overflowing.
class OutstandingBreakdownStrip extends StatelessWidget {
  const OutstandingBreakdownStrip({required this.invoices, super.key});

  final List<Invoice> invoices;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final amountStyle = AppTextStyles.codeSmall.copyWith(
      color: theme.colorScheme.onSurface,
      fontWeight: AppTextStyles.semiBold,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
      ),
      child: Wrap(
        spacing: AppSpacing.lg,
        runSpacing: AppSpacing.xs,
        children: [
          for (final invoice in invoices)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(invoice.shortLabel, style: labelStyle),
                AppSpacing.horizontalGap(AppSpacing.xs),
                Text(
                  formatNaira(invoice.balanceMinorUnits),
                  style: AppTextStyles.tabular(amountStyle),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
