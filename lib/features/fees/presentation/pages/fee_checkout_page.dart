import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/fee_checkout_cubit.dart';
import '../bloc/fees_cubit.dart';
import '../bloc/fees_state.dart';
import '../widgets/checkout_top_bar.dart';
import '../widgets/fee_checkout_body.dart';

/// Paying one or more open invoices: a stack step above the fees tab.
///
/// Its own bar with a back arrow and no tab bar, because a student choosing
/// how to pay is in a task, not moving between sections. Which invoices it
/// is for arrives from the route; none named means every open one.
class FeeCheckoutPage extends StatefulWidget {
  const FeeCheckoutPage({required this.invoiceIds, super.key});

  /// Ids of the open invoices to pay; empty for all of them.
  final List<String> invoiceIds;

  @override
  FeeCheckoutPageState createState() => FeeCheckoutPageState();
}

/// State of [FeeCheckoutPage].
///
/// Public because private widget classes are banned, and because starting
/// the visit from the ledger is a behaviour a test should be able to name.
class FeeCheckoutPageState extends State<FeeCheckoutPage> {
  @override
  void initState() {
    super.initState();
    // The ledger first — idempotent, and a deep link may land here before
    // the tab has read it — then the visit, with the invoices the link named.
    // The read is synchronous while the ledger is a fixture; a repository
    // version starts the visit from a listener on the fees cubit instead.
    final fees = context.read<FeesCubit>()..load();
    final terms = fees.state.terms;
    if (terms != null) {
      context.read<FeeCheckoutCubit>().start(
        invoices: fees.state.outstandingInvoicesFor(widget.invoiceIds),
        terms: terms,
      );
    }
  }

  void _back() {
    // Nested under the tab, so there is normally a page to pop to; a cold
    // deep link that somehow is not stacked goes to the tab explicitly.
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(Routes.feesName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<FeesCubit, FeesState>(
      builder: (context, fees) {
        final student = fees.student;

        return Scaffold(
          backgroundColor: AppColors.canvas(context.colors.brightness),
          appBar: CheckoutTopBar(onBack: _back),
          body: SafeArea(
            top: false,
            child: switch (fees.status) {
              FeesStatus.initial || FeesStatus.loading => const LoadingView(),
              FeesStatus.failure => EmptyView(
                message: l10n.errorsServer,
                icon: Icons.cloud_off_outlined,
              ),
              FeesStatus.ready =>
                student == null
                    ? EmptyView(message: l10n.feesCheckoutNothingToPay)
                    : FeeCheckoutBody(student: student, session: fees.session),
            },
          ),
        );
      },
    );
  }
}
