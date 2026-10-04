import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/fee_card_checkout_cubit.dart';
import '../bloc/fee_card_checkout_state.dart';
import 'card_checkout_footer.dart';
import 'card_checkout_form.dart';
import 'card_checkout_schedule.dart';

/// Card checkout once a session is started: schedule, form and Pay footer.
class FeeCardCheckoutBody extends StatefulWidget {
  const FeeCardCheckoutBody({super.key});

  @override
  FeeCardCheckoutBodyState createState() => FeeCardCheckoutBodyState();
}

/// State of [FeeCardCheckoutBody].
class FeeCardCheckoutBodyState extends State<FeeCardCheckoutBody> {
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _expiry = TextEditingController();
  final TextEditingController _cvv = TextEditingController();
  final TextEditingController _pin = TextEditingController();

  @override
  void dispose() {
    _cardNumber.dispose();
    _expiry.dispose();
    _cvv.dispose();
    _pin.dispose();
    super.dispose();
  }

  void _pay() {
    final reference = context.read<FeeCardCheckoutCubit>().payReference();
    if (reference == null) return;
    // Pay opens the return as awaiting confirmation — never as a success.
    context.goNamed(
      Routes.feesGatewayReturnName,
      queryParameters: {Routes.feesGatewayReturnRefParam: reference},
    );
  }

  void _cancel() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(Routes.feesName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<FeeCardCheckoutCubit, FeeCardCheckoutState>(
      builder: (context, state) {
        final session = state.session;
        if (session == null) {
          return EmptyView(
            message: l10n.feesCheckoutNothingToPay,
            icon: Icons.credit_card_off_outlined,
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ResponsiveContent(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CardCheckoutSchedule(session: session),
                        AppSpacing.verticalGap(AppSpacing.xl),
                        CardCheckoutForm(
                          state: state,
                          cardNumber: _cardNumber,
                          expiry: _expiry,
                          cvv: _cvv,
                          pin: _pin,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CardCheckoutFooter(
              totalMinorUnits: session.totalMinorUnits,
              isEnabled: state.canPay,
              transactionReference: session.transactionReference,
              onPay: _pay,
              onCancel: _cancel,
            ),
          ],
        );
      },
    );
  }
}
