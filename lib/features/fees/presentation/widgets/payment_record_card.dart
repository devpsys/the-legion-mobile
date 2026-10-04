import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';

/// One payment on record: the receipt number and whether the gateway
/// confirmed it, what it paid for, and how.
///
/// The amount is set in the mono face at the card's right edge, and the
/// receipt is a button rather than a link — it is the one artefact a student
/// is asked to produce, so it gets a target the size of a button.
class PaymentRecordCard extends StatelessWidget {
  const PaymentRecordCard({
    required this.payment,
    required this.onReceipt,
    super.key,
  });

  final PaymentRecord payment;

  /// Opens the receipt.
  final VoidCallback onReceipt;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final reference = payment.channelReference;
    final channel = paymentChannelLabel(l10n, payment.channel);

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      payment.reference,
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    StatusTag(
                      label: paymentStatusLabel(l10n, payment.status),
                      tone: payment.status.tone,
                    ),
                  ],
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.md),
              Text(
                formatNaira(payment.amountMinorUnits),
                style: AppTextStyles.tabular(
                  AppTextStyles.codeMedium.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            payment.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  l10n.feesPaymentLine(
                    reference == null
                        ? channel
                        : l10n.feesChannelWithReference(channel, reference),
                    AppDateFormats.medium(l10n.localeName)
                        .format(payment.paidOn),
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: onReceipt,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, AppDimensions.buttonCompact),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                icon: const Icon(
                  Icons.download_outlined,
                  size: AppDimensions.iconSmall,
                ),
                label: Text(l10n.feesReceiptPdf),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The bursary's word for a [PaymentStatus].
///
/// A payment the gateway has not confirmed is "Awaiting confirmation", never
/// "Paid": nothing says the money moved until the gateway says so.
String paymentStatusLabel(AppLocalizations l10n, PaymentStatus status) =>
    switch (status) {
      PaymentStatus.pending => l10n.feesPaymentPending,
      PaymentStatus.succeeded => l10n.feesPaymentSuccessful,
    };

/// The label of a [PaymentChannel].
String paymentChannelLabel(AppLocalizations l10n, PaymentChannel channel) =>
    switch (channel) {
      PaymentChannel.card => l10n.feesChannelCard,
      PaymentChannel.remitaRrr => l10n.feesChannelRemitaRrr,
    };
