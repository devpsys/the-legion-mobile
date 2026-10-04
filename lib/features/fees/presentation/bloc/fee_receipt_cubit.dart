import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/fees_fixtures.dart';
import '../models/fees_models.dart';
import 'fee_receipt_state.dart';

/// Loads one official e-receipt by payment / receipt id.
class FeeReceiptCubit extends Cubit<FeeReceiptState> {
  FeeReceiptCubit({OfficialReceiptLookup? lookup})
    : _lookup = lookup ?? FeesFixtures.receipt,
      super(const FeeReceiptState());

  final OfficialReceiptLookup _lookup;

  void load(String id) {
    emit(
      state.copyWith(
        loadStatus: FeeReceiptLoadStatus.loading,
        clearReceipt: true,
      ),
    );
    final receipt = _lookup(id);
    emit(
      receipt == null
          ? state.copyWith(loadStatus: FeeReceiptLoadStatus.notFound)
          : state.copyWith(
              loadStatus: FeeReceiptLoadStatus.ready,
              receipt: receipt,
            ),
    );
  }
}

/// Resolves an official receipt by id, or `null`.
typedef OfficialReceiptLookup = OfficialReceipt? Function(String id);
