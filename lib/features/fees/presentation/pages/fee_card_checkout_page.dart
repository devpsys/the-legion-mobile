import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/fee_card_checkout_cubit.dart';
import '../bloc/fee_checkout_cubit.dart';
import '../bloc/fees_cubit.dart';
import '../bloc/fees_state.dart';
import '../mock/fees_fixtures.dart';
import '../widgets/card_checkout_top_bar.dart';
import '../widgets/fee_card_checkout_body.dart';

/// Card entry after the university checkout's Proceed.
///
/// Reads the chosen invoices and amount from [FeeCheckoutCubit] when that
/// visit is still open; a cold deep link falls back to every open invoice on
/// the ledger. Pay does not mark money moved — it opens the gateway return
/// as awaiting confirmation.
class FeeCardCheckoutPage extends StatefulWidget {
  const FeeCardCheckoutPage({super.key});

  @override
  FeeCardCheckoutPageState createState() => FeeCardCheckoutPageState();
}

/// State of [FeeCardCheckoutPage].
class FeeCardCheckoutPageState extends State<FeeCardCheckoutPage> {
  @override
  void initState() {
    super.initState();
    final fees = context.read<FeesCubit>()..load();
    final checkout = context.read<FeeCheckoutCubit>();
    final terms = fees.state.terms ?? FeesFixtures.terms;
    final student = fees.state.student ?? FeesFixtures.student;
    final session = fees.state.session.isEmpty
        ? FeesFixtures.session
        : fees.state.session;

    final invoices =
        checkout.state.isStarted && checkout.state.invoices.isNotEmpty
        ? checkout.state.invoices
        : fees.state.outstandingInvoicesFor(const []);

    context.read<FeeCardCheckoutCubit>().start(
      invoices: invoices,
      student: student,
      session: session,
      terms: terms,
      amountMinorUnits: checkout.state.isStarted
          ? checkout.state.amountMinorUnits
          : null,
      payableMinorUnits: checkout.state.isStarted
          ? checkout.state.payableMinorUnits
          : null,
    );
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(Routes.feesCheckoutName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<FeesCubit, FeesState>(
      builder: (context, fees) {
        return Scaffold(
          backgroundColor: AppColors.canvas(context.colors.brightness),
          appBar: CardCheckoutTopBar(onBack: _back),
          body: SafeArea(
            top: false,
            child: switch (fees.status) {
              FeesStatus.initial || FeesStatus.loading => const LoadingView(),
              FeesStatus.failure => EmptyView(
                message: l10n.errorsServer,
                icon: Icons.cloud_off_outlined,
              ),
              FeesStatus.ready => const FeeCardCheckoutBody(),
            },
          ),
        );
      },
    );
  }
}
