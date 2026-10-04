import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/fees_fixtures.dart';
import '../models/fees_models.dart';
import 'fee_card_checkout_state.dart';

/// Holds one visit's card-entry fields and the schedule being charged.
///
/// Card values never leave this cubit: they are not written to fixtures or
/// storage. [payReference] returns the pending gateway reference so the page
/// can open the return screen — it does not mark money moved.
class FeeCardCheckoutCubit extends Cubit<FeeCardCheckoutState> {
  FeeCardCheckoutCubit() : super(const FeeCardCheckoutState());

  /// Begins the visit from the university checkout's invoices and amount.
  void start({
    required List<Invoice> invoices,
    required FeesStudent student,
    required String session,
    required PaymentTerms terms,
    int? amountMinorUnits,
    int? payableMinorUnits,
  }) {
    emit(
      FeeCardCheckoutState(
        session: FeesFixtures.cardSessionFor(
          invoices: invoices,
          student: student,
          session: session,
          terms: terms,
          amountMinorUnits: amountMinorUnits,
          payableMinorUnits: payableMinorUnits,
        ),
      ),
    );
  }

  void cardNumberChanged(String value) {
    if (state.cardNumber == value) return;
    emit(state.copyWith(cardNumber: value));
  }

  void expiryChanged(String value) {
    if (state.expiry == value) return;
    emit(state.copyWith(expiry: value));
  }

  void cvvChanged(String value) {
    if (state.cvv == value) return;
    emit(state.copyWith(cvv: value));
  }

  void pinChanged(String value) {
    if (state.pin == value) return;
    emit(state.copyWith(pin: value));
  }

  void saveCardChanged(bool value) {
    if (state.saveCard == value) return;
    emit(state.copyWith(saveCard: value));
  }

  /// The pending return reference to open, or `null` while Pay is not ready.
  ///
  /// Does not claim the money moved — that belongs to the gateway-return
  /// screen once the gateway answers.
  String? payReference() {
    if (!state.canPay) return null;
    return state.transactionReference;
  }
}
