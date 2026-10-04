import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';

/// What the checkout is for: the invoices by reference and title, a line
/// per balance, the gateway's charge, and the total they come to.
///
/// The total is handed in by the state that summed the same lines, so the
/// figures on the card add up by construction. It is the whole balance plus
/// the charge whatever instalment is chosen below: this card says what is
/// owed, the footer says what is being paid now.
class PaymentDetailsCard extends StatelessWidget {
  const PaymentDetailsCard({
    required this.invoices,
    required this.session,
    required this.gatewayChargeMinorUnits,
    required this.totalMinorUnits,
    super.key,
  });

  /// The open invoices being paid.
  final List<Invoice> invoices;

  /// The session on the term tag, e.g. `2026/2027`.
  final String session;

  final int gatewayChargeMinorUnits;

  /// Every balance plus the charge, in kobo.
  final int totalMinorUnits;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.feesPaymentDetails.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: AppTextStyles.trackingCapsWide,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              StatusTag(label: l10n.feesTerm(session), tone: AppTone.neutral),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          CheckoutDetailRow(
            label: l10n.feesInvoiceReference,
            values: [for (final invoice in invoices) invoice.reference],
            isCode: true,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          CheckoutDetailRow(
            label: l10n.feesDescription,
            values: [for (final invoice in invoices) invoice.title],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Divider(
            height: AppDimensions.hairline,
            color: theme.colorScheme.outlineVariant,
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          for (final invoice in invoices) ...[
            LabelledValueRow(
              label: invoice.lineLabel,
              value: formatNaira(invoice.balanceMinorUnits),
              isCode: true,
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
          GatewayChargeRow(amountMinorUnits: gatewayChargeMinorUnits),
          AppSpacing.verticalGap(AppSpacing.lg),
          TotalPayableBar(totalMinorUnits: totalMinorUnits),
        ],
      ),
    );
  }
}

/// A muted label and the values it names, one per line, right-aligned.
///
/// A list rather than a joined sentence: two references each get a line a
/// student can read and quote, and nothing has to invent the word between
/// them.
class CheckoutDetailRow extends StatelessWidget {
  const CheckoutDetailRow({
    required this.label,
    required this.values,
    this.isCode = false,
    super.key,
  });

  final String label;
  final List<String> values;

  /// Sets the values in the mono face, for references.
  final bool isCode;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final valueStyle = isCode
        ? AppTextStyles.codeMedium.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: AppTextStyles.semiBold,
          )
        : theme.textTheme.bodyMedium!.copyWith(
            fontWeight: AppTextStyles.semiBold,
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final value in values)
                Text(value, textAlign: TextAlign.end, style: valueStyle),
            ],
          ),
        ),
      ],
    );
  }
}

/// The gateway's statutory charge, with a mark that explains whose it is.
class GatewayChargeRow extends StatelessWidget {
  const GatewayChargeRow({required this.amountMinorUnits, super.key});

  final int amountMinorUnits;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  l10n.feesGatewayCharge,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.xs),
              Tooltip(
                message: l10n.feesGatewayChargeInfo,
                triggerMode: TooltipTriggerMode.tap,
                child: Icon(
                  Icons.info_outline,
                  size: AppDimensions.iconSmall,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.md),
        Text(
          formatNaira(amountMinorUnits),
          style: AppTextStyles.tabular(
            AppTextStyles.codeMedium.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}

/// The total, on its own block, in the accent colour: the one figure on the
/// screen the student is here to read.
class TotalPayableBar extends StatelessWidget {
  const TotalPayableBar({required this.totalMinorUnits, super.key});

  final int totalMinorUnits;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: AppRadii.elementRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.feesTotalPayable,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(
                  l10n.feesTotalPayableNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Text(
            formatNaira(totalMinorUnits),
            style: AppTextStyles.tabular(
              AppTextStyles.codeDisplay.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
