import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/fee_checkout_cubit.dart';
import '../bloc/fee_checkout_state.dart';
import '../models/fees_models.dart';
import 'checkout_footer.dart';
import 'payer_verification_card.dart';
import 'payment_amount_card.dart';
import 'payment_details_card.dart';
import 'payment_method_card.dart';

/// The checkout once the visit has its invoices: what is owed, how much to
/// pay, how, by whom, and the docked button that would hand over to the
/// gateway.
///
/// Owns the instalment field's controller, the one piece of UI state the
/// cubit does not hold: the cubit keeps the parsed figure, the controller
/// keeps the characters, and a rebuild must not lose the caret. The gateway
/// is not built yet, so the button says so rather than pretending.
class FeeCheckoutBody extends StatefulWidget {
  const FeeCheckoutBody({
    required this.student,
    required this.session,
    super.key,
  });

  final FeesStudent student;

  /// The session on the details card's term tag.
  final String session;

  @override
  FeeCheckoutBodyState createState() => FeeCheckoutBodyState();
}

/// State of [FeeCheckoutBody].
class FeeCheckoutBodyState extends State<FeeCheckoutBody> {
  final TextEditingController _instalment = TextEditingController();

  @override
  void dispose() {
    _instalment.dispose();
    super.dispose();
  }

  void _modeChanged(PaymentAmountMode mode) {
    final cubit = context.read<FeeCheckoutCubit>();
    if (mode == PaymentAmountMode.instalment && _instalment.text.isEmpty) {
      // Start from the whole balance: the student edits a figure down rather
      // than typing one from nothing, and the button has an amount at once.
      _instalment.text = formatNairaFigure(cubit.state.balanceMinorUnits);
      cubit.instalmentChanged(_instalment.text);
    }
    cubit.amountModeChanged(mode);
  }

  Future<void> _copyReference(String reference) async {
    await Clipboard.setData(ClipboardData(text: reference));
    if (!mounted) return;
    context.showMessage(context.l10n.feesReferenceCopied);
  }

  void _notAvailable() {
    context.showMessage(context.l10n.commonComingSoon);
  }

  void _proceed(FeeCheckoutState state) {
    if (!state.canProceed) return;
    // Only the gateway has a card-entry screen today; bank branch and the
    // virtual account stay on the coming-soon path until their flows land.
    if (state.method != PaymentMethod.gateway) {
      _notAvailable();
      return;
    }
    context.goNamed(Routes.feesCardCheckoutName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<FeeCheckoutCubit, FeeCheckoutState>(
      builder: (context, state) {
        final terms = state.terms;
        // A link naming no open invoice, or a ledger with nothing owed: the
        // screen says so rather than offering to pay nothing.
        if (terms == null || state.balanceMinorUnits == 0) {
          return EmptyView(
            message: l10n.feesCheckoutNothingToPay,
            icon: Icons.receipt_long_outlined,
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
                        PaymentDetailsCard(
                          invoices: state.invoices,
                          session: widget.session,
                          gatewayChargeMinorUnits:
                              state.gatewayChargeMinorUnits,
                          totalMinorUnits: state.fullPayableMinorUnits,
                        ),
                        AppSpacing.verticalGap(AppSpacing.xl),
                        PaymentAmountCard(
                          state: state,
                          controller: _instalment,
                          onModeChanged: _modeChanged,
                          onInstalmentChanged: context
                              .read<FeeCheckoutCubit>()
                              .instalmentChanged,
                        ),
                        AppSpacing.verticalGap(AppSpacing.xl),
                        PaymentMethodCard(
                          method: state.method,
                          terms: terms,
                          student: widget.student,
                          onMethodChanged: context
                              .read<FeeCheckoutCubit>()
                              .methodChanged,
                          onCopyReference: _copyReference,
                        ),
                        AppSpacing.verticalGap(AppSpacing.xl),
                        PayerVerificationCard(student: widget.student),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CheckoutFooter(
              payableMinorUnits: state.payableMinorUnits,
              isEnabled: state.canProceed,
              onProceed: () => _proceed(state),
            ),
          ],
        );
      },
    );
  }
}
