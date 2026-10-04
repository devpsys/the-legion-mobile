import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/fees_state.dart';
import '../models/fees_models.dart';
import 'bursary_notice_card.dart';
import 'fees_header.dart';
import 'invoices_section.dart';
import 'outstanding_balance_card.dart';
import 'payment_history_section.dart';

/// The fees tab once the ledger is in: the header, the outstanding total,
/// the session's invoices, the payment history and the bursary's notice.
///
/// Every "pay" leads to one checkout, told which open invoices it is for:
/// the hero names none and so pays all of them, a card names its own. The
/// breakdown, the full history and the receipts have no screen yet and say
/// so.
class FeesBody extends StatelessWidget {
  const FeesBody({required this.state, super.key});

  final FeesState state;

  void _checkout(BuildContext context, Iterable<String> invoiceIds) {
    final query = Routes.feesCheckoutInvoicesQuery(invoiceIds);
    context.goNamed(
      Routes.feesCheckoutName,
      queryParameters: {
        if (query.isNotEmpty) Routes.feesCheckoutInvoicesParam: query,
      },
    );
  }

  void _notAvailable(BuildContext context) {
    context.showMessage(context.l10n.commonComingSoon);
  }

  @override
  Widget build(BuildContext context) {
    final student = state.student;

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (student != null) ...[
                FeesHeader(student: student),
                AppSpacing.verticalGap(AppSpacing.xl),
              ],
              OutstandingBalanceCard(
                outstandingMinorUnits: state.outstandingMinorUnits,
                invoices: state.outstandingInvoices,
                dueOn: state.nextDueOn,
                onPay: () => _checkout(context, const []),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              InvoicesSection(
                session: state.session,
                invoices: state.invoices,
                onPay: (invoice) => _checkout(context, [invoice.id]),
                onBreakdown: (_) => _notAvailable(context),
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              PaymentHistorySection(
                payments: state.payments,
                onViewAll: () => _notAvailable(context),
                onReceipt: (payment) {
                  if (payment.status != PaymentStatus.succeeded) {
                    _notAvailable(context);
                    return;
                  }
                  context.goNamed(
                    Routes.feesReceiptName,
                    pathParameters: {Routes.feesReceiptIdParam: payment.id},
                  );
                },
              ),
              AppSpacing.verticalGap(AppSpacing.xl),
              const BursaryNoticeCard(),
            ],
          ),
        ),
      ),
    );
  }
}
