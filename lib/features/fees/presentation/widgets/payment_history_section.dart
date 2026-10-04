import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';
import 'payment_record_card.dart';

/// What the student has paid, newest first, with the receipts.
class PaymentHistorySection extends StatelessWidget {
  const PaymentHistorySection({
    required this.payments,
    required this.onViewAll,
    required this.onReceipt,
    super.key,
  });

  /// Newest first.
  final List<PaymentRecord> payments;

  /// Opens the full history.
  final VoidCallback onViewAll;

  /// Opens one payment's receipt.
  final void Function(PaymentRecord payment) onReceipt;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l10n.feesHistoryHeading,
          action: payments.isEmpty
              ? null
              : TextButton(
                  onPressed: onViewAll,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, AppDimensions.buttonCompact),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(l10n.feesViewAll),
                ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        if (payments.isEmpty)
          Text(
            l10n.feesNoPayments,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final (index, payment) in payments.indexed) ...[
            if (index > 0) AppSpacing.verticalGap(AppSpacing.md),
            PaymentRecordCard(
              payment: payment,
              onReceipt: () => onReceipt(payment),
            ),
          ],
      ],
    );
  }
}
