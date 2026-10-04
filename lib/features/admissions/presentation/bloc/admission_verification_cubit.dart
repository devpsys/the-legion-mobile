import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/admissions_fixtures.dart';
import '../models/application_detail_models.dart';
import 'admission_verification_state.dart';

/// Answers one question for whoever is handed an admission letter: is it
/// genuine?
///
/// Presentation only, like the portal cubit: there is no verification
/// endpoint yet, so the register it consults is `presentation/mock/`. The
/// lookup is injectable so the page can be tested against any register, and
/// so the API, when it lands, slots in here without the page changing.
///
/// Deliberately knows nothing about a session. The person checking a letter
/// is a landlord or an employer, not a candidate, and must never be shown
/// more than the letter already says — which is all [AdmissionVerificationResult]
/// carries.
class AdmissionVerificationCubit extends Cubit<AdmissionVerificationState> {
  AdmissionVerificationCubit({AdmissionVerificationLookup? lookup})
    : _lookup = lookup ?? AdmissionsFixtures.verify,
      super(const AdmissionVerificationState());

  final AdmissionVerificationLookup _lookup;

  /// Records the code as typed. A new code voids the last answer: a result on
  /// screen must always be the result for the code in the field.
  void codeChanged(String code) {
    if (state.code == code) return;
    emit(
      state.copyWith(
        code: code,
        status: AdmissionVerificationStatus.idle,
        clearResult: true,
      ),
    );
  }

  /// Asks the register about the code in the field.
  ///
  /// Synchronous because the register is in memory; a repository version
  /// awaits its call between the two emits.
  void verify() {
    if (!state.canVerify) return;

    emit(
      state.copyWith(
        status: AdmissionVerificationStatus.checking,
        clearResult: true,
      ),
    );
    final result = _lookup(state.code);
    emit(
      result == null
          ? state.copyWith(status: AdmissionVerificationStatus.notFound)
          : state.copyWith(
              status: AdmissionVerificationStatus.verified,
              result: result,
            ),
    );
  }

  /// Records [code] and checks it in one step — for a code that arrived in
  /// the link the QR mark encodes, where there is nothing to type.
  void verifyCode(String code) {
    codeChanged(code);
    verify();
  }
}

/// Resolves a verification code to what its letter prints, or `null`.
typedef AdmissionVerificationLookup = AdmissionVerificationResult? Function(
  String code,
);
