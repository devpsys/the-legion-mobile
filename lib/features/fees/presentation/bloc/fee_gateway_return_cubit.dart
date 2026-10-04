import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/fees_fixtures.dart';
import '../models/fees_models.dart';
import 'fee_gateway_return_state.dart';

/// Loads one gateway-return visit by payment reference.
///
/// Presentation only: the register is in `presentation/mock/`. Injectable
/// lookup so tests can feed any return, and so a repository can replace the
/// fixture when the endpoint lands.
class FeeGatewayReturnCubit extends Cubit<FeeGatewayReturnState> {
  FeeGatewayReturnCubit({GatewayReturnLookup? lookup})
    : _lookup = lookup ?? FeesFixtures.gatewayReturn,
      super(const FeeGatewayReturnState());

  final GatewayReturnLookup _lookup;

  /// Resolves [reference] from the register.
  void load(String reference) {
    emit(
      state.copyWith(
        loadStatus: FeeGatewayReturnLoadStatus.loading,
        clearPayment: true,
      ),
    );
    final payment = _lookup(reference);
    emit(
      payment == null
          ? state.copyWith(loadStatus: FeeGatewayReturnLoadStatus.notFound)
          : state.copyWith(
              loadStatus: FeeGatewayReturnLoadStatus.ready,
              payment: payment,
            ),
    );
  }

  /// Mock hand-off: a pending return becomes the succeeded fixture.
  ///
  /// Used by tests (and a future "refresh" once the gateway polls). The page
  /// does not expose a control for this — confirmation is the gateway's job.
  void confirm() {
    final current = state.payment;
    if (current == null) return;
    final next = FeesFixtures.confirmReturn(current);
    if (next == current) return;
    emit(state.copyWith(payment: next));
  }
}

/// Resolves a gateway-return reference, or `null`.
typedef GatewayReturnLookup = GatewayReturn? Function(String reference);
