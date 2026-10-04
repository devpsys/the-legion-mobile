import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/money.dart';
import '../models/fees_models.dart';
import 'fee_checkout_state.dart';

/// Holds one visit's choices on the checkout: how much, and by what means.
///
/// Its own cubit, provided per visit, because a half-chosen instalment is
/// not worth keeping once the student leaves the screen — while the ledger
/// it is paying against lives on the fees cubit with the rest of the record.
/// Nothing here says money moved: the gateway is not built yet, and when it
/// is, the hand-off belongs to the gateway-return screen, not to this cubit.
class FeeCheckoutCubit extends Cubit<FeeCheckoutState> {
  FeeCheckoutCubit() : super(const FeeCheckoutState());

  /// Begins the visit against [invoices] on [terms].
  ///
  /// Called by the page with what the ledger holds, so this cubit never
  /// reads fixtures itself. Resets the choices: a visit for a different set
  /// of bills must not inherit the last one's instalment.
  void start({required List<Invoice> invoices, required PaymentTerms terms}) {
    emit(FeeCheckoutState(invoices: invoices, terms: terms));
  }

  void amountModeChanged(PaymentAmountMode mode) {
    if (state.amountMode == mode) return;
    emit(state.copyWith(amountMode: mode));
  }

  /// Records the instalment as typed. Not an amount — empty, letters, a
  /// third decimal — clears it rather than keeping the last valid figure, so
  /// the button never offers to charge something no longer in the field.
  void instalmentChanged(String raw) {
    final parsed = parseNaira(raw);
    if (parsed == null) {
      if (state.instalmentMinorUnits == null) return;
      emit(state.copyWith(clearInstalment: true));
      return;
    }
    if (state.instalmentMinorUnits == parsed) return;
    emit(state.copyWith(instalmentMinorUnits: parsed));
  }

  void methodChanged(PaymentMethod method) {
    if (state.method == method) return;
    emit(state.copyWith(method: method));
  }
}
