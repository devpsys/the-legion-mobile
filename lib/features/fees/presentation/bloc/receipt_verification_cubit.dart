import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/fees_fixtures.dart';
import '../models/fees_models.dart';
import 'receipt_verification_state.dart';

/// Answers one question for whoever is handed a bursary receipt: is it
/// genuine?
///
/// Deliberately knows nothing about a session. The result carries only the
/// five facts the fees README allows — never a matric or a contact detail.
class ReceiptVerificationCubit extends Cubit<ReceiptVerificationState> {
  ReceiptVerificationCubit({ReceiptVerificationLookup? lookup})
    : _lookup = lookup ?? FeesFixtures.verifyReceipt,
      super(const ReceiptVerificationState());

  final ReceiptVerificationLookup _lookup;

  void codeChanged(String code) {
    if (state.code == code) return;
    emit(
      state.copyWith(
        code: code,
        status: ReceiptVerificationStatus.idle,
        clearResult: true,
      ),
    );
  }

  void verify() {
    if (!state.canVerify) return;

    emit(
      state.copyWith(
        status: ReceiptVerificationStatus.checking,
        clearResult: true,
      ),
    );
    final result = _lookup(state.code);
    emit(
      result == null
          ? state.copyWith(status: ReceiptVerificationStatus.notFound)
          : state.copyWith(
              status: ReceiptVerificationStatus.verified,
              result: result,
            ),
    );
  }

  void verifyCode(String code) {
    codeChanged(code);
    verify();
  }
}

/// Resolves a verification code to the five public facts, or `null`.
typedef ReceiptVerificationLookup = ReceiptVerificationResult? Function(
  String code,
);
