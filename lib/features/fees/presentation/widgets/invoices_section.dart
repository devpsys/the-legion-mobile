import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';
import 'invoice_card.dart';

/// The session's invoices, headed with how many are still open.
class InvoicesSection extends StatelessWidget {
  const InvoicesSection({
    required this.session,
    required this.invoices,
    required this.onPay,
    required this.onBreakdown,
    super.key,
  });

  /// The session the heading names, e.g. `2026/2027`.
  final String session;

  /// Newest first.
  final List<Invoice> invoices;

  /// Opens the checkout for one invoice.
  final void Function(Invoice invoice) onPay;

  /// Opens one invoice's line items.
  final void Function(Invoice invoice) onBreakdown;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final pending = invoices.where((invoice) => invoice.isOutstanding).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: l10n.feesInvoicesHeading(session),
          action: Text(
            l10n.feesPendingCount(pending),
            style: AppTextStyles.codeSmall.copyWith(
              color: pending == 0
                  ? AppColors.successText(theme.brightness)
                  : AppColors.infoText(theme.brightness),
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        if (invoices.isEmpty)
          Text(
            l10n.feesNoInvoices,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final (index, invoice) in invoices.indexed) ...[
            if (index > 0) AppSpacing.verticalGap(AppSpacing.md),
            InvoiceCard(
              invoice: invoice,
              onPay: () => onPay(invoice),
              onBreakdown: () => onBreakdown(invoice),
            ),
          ],
      ],
    );
  }
}
