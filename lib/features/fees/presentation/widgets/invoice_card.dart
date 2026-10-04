import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';

/// One invoice: its reference and status, what it is for, and where it
/// stands.
///
/// A bill that is part paid shows its ledger — billed, cleared, remaining —
/// and a bar, because the student's question is "how far along am I". A bill
/// nothing has been paid on shows one figure and its deadline, because the
/// question is "how much, by when". Both offer to pay what is left; a bill
/// that is settled or cancelled offers nothing, since nothing is owed.
class InvoiceCard extends StatelessWidget {
  const InvoiceCard({
    required this.invoice,
    required this.onPay,
    required this.onBreakdown,
    super.key,
  });

  final Invoice invoice;

  /// Opens the checkout for this invoice alone.
  final VoidCallback onPay;

  /// Opens the bill's line items.
  final VoidCallback onBreakdown;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final isPartPaid = invoice.isOutstanding && invoice.paidMinorUnits > 0;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  invoice.reference,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: AppColors.infoText(theme.brightness),
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              StatusTag(
                label: invoiceStatusLabel(l10n, invoice.status),
                tone: invoice.status.tone,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            invoice.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            invoice.subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          if (invoice.status == InvoiceStatus.open)
            InvoiceDueAmount(invoice: invoice)
          else
            InvoiceLedger(invoice: invoice),
          if (isPartPaid) ...[
            AppSpacing.verticalGap(AppSpacing.lg),
            InvoicePaymentProgress(invoice: invoice),
          ],
          if (invoice.isOutstanding) ...[
            AppSpacing.verticalGap(AppSpacing.lg),
            InvoiceActions(
              invoice: invoice,
              onPay: onPay,
              onBreakdown: onBreakdown,
            ),
          ],
        ],
      ),
    );
  }
}

/// Billed, cleared and remaining, on a tinted block so the three figures read
/// as one ledger.
class InvoiceLedger extends StatelessWidget {
  const InvoiceLedger({required this.invoice, super.key});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final brightness = theme.brightness;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
      ),
      child: Column(
        children: [
          LabelledValueRow(
            label: l10n.feesTotalBilled,
            value: formatNaira(invoice.totalMinorUnits),
            isCode: true,
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          LabelledValueRow(
            label: l10n.feesAmountCleared,
            value: formatNaira(invoice.paidMinorUnits),
            isCode: true,
            valueColor: AppColors.successText(brightness),
          ),
          if (invoice.isOutstanding) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            LabelledValueRow(
              label: l10n.feesRemainingBalance,
              value: formatNaira(invoice.balanceMinorUnits),
              isCode: true,
              valueColor: AppColors.warningText(brightness),
            ),
          ],
        ],
      ),
    );
  }
}

/// The deadline and the one figure of a bill nothing has been paid on.
class InvoiceDueAmount extends StatelessWidget {
  const InvoiceDueAmount({required this.invoice, super.key});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            l10n.feesDueOn(
              AppDateFormats.long(l10n.localeName).format(invoice.dueOn),
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              l10n.feesAmount.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: AppTextStyles.trackingCaps,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.xs),
            Text(
              formatNaira(invoice.balanceMinorUnits),
              style: AppTextStyles.tabular(
                AppTextStyles.codeDisplay.copyWith(
                  color: AppColors.dangerText(theme.brightness),
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// How far along a part-paid bill is: the percentage, and the bar under it.
///
/// Both come from the same two integers on the invoice, so the label cannot
/// say one thing while the bar draws another.
class InvoicePaymentProgress extends StatelessWidget {
  const InvoicePaymentProgress({required this.invoice, super.key});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.feesPaymentProgress,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
            ),
            Text(
              l10n.feesPercent(invoice.paidPercent),
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadii.chipRadius,
          child: LinearProgressIndicator(
            // Always a number: a `null` value animates forever and would hang
            // `pumpAndSettle` in every test that touches the card.
            value: invoice.paidFraction,
            minHeight: AppDimensions.trackHeight,
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}

/// The buttons under an open bill: pay what is left and, for a bill that is
/// part paid, see what it is made of.
class InvoiceActions extends StatelessWidget {
  const InvoiceActions({
    required this.invoice,
    required this.onPay,
    required this.onBreakdown,
    super.key,
  });

  final Invoice invoice;
  final VoidCallback onPay;
  final VoidCallback onBreakdown;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final balance = formatNaira(invoice.balanceMinorUnits);

    if (invoice.paidMinorUnits == 0) {
      return FilledButton.icon(
        onPressed: onPay,
        icon: const Icon(Icons.payment_outlined),
        label: Text(l10n.feesPayAmount(balance)),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: FilledButton(
            onPressed: onPay,
            child: Text(l10n.feesPayBalance(balance)),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          flex: 2,
          child: OutlinedButton(
            onPressed: onBreakdown,
            child: Text(l10n.feesBreakdown),
          ),
        ),
      ],
    );
  }
}

/// The bursary's word for an [InvoiceStatus].
///
/// Never the enum's name: `open` is a bill that is "Unpaid", and
/// `partiallyPaid` reads "Part paid", the way the bursary's receipts do.
String invoiceStatusLabel(AppLocalizations l10n, InvoiceStatus status) =>
    switch (status) {
      InvoiceStatus.open => l10n.feesStatusUnpaid,
      InvoiceStatus.partiallyPaid => l10n.feesStatusPartPaid,
      InvoiceStatus.paid => l10n.feesStatusSettled,
      InvoiceStatus.cancelled => l10n.feesStatusCancelled,
    };
