import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/admissions_fixtures.dart';
import '../models/jamb_models.dart';
import 'jamb_claim_state.dart';

/// Matches what a candidate types against the CAPS import.
///
/// Presentation only, like the verification cubit it is modelled on: there is
/// no import endpoint yet, so the records it consults are `presentation/mock/`.
/// The lookup is injectable so the page can be tested against any import, and
/// so the API, when it lands, slots in here without the page changing.
///
/// Matching and linking are two steps on purpose. A match shows the candidate
/// the record so they can see it is theirs; linking is the irreversible act,
/// and belongs to the portal's own cubit, which owns the record it changes.
/// This one only answers "whose result is this?".
class JambClaimCubit extends Cubit<JambClaimState> {
  JambClaimCubit({JambResultLookup? lookup})
    : _lookup = lookup ?? AdmissionsFixtures.matchJambResult,
      super(const JambClaimState());

  final JambResultLookup _lookup;

  /// Records the number as typed. Any change voids the last answer: a record
  /// on screen must always be the record for the facts in the form.
  void registrationNumberChanged(String value) {
    if (state.registrationNumber == value) return;
    emit(_voided(state.copyWith(registrationNumber: value)));
  }

  void surnameChanged(String value) {
    if (state.surname == value) return;
    emit(_voided(state.copyWith(surname: value)));
  }

  void dateOfBirthChanged(DateTime value) {
    if (state.dateOfBirth == value) return;
    emit(_voided(state.copyWith(dateOfBirth: value)));
  }

  /// Asks the import about the facts in the form.
  ///
  /// Synchronous because the import is in memory; a repository version awaits
  /// its call between the two emits.
  void match() {
    final request = state.request;
    if (request == null || !state.canMatch) return;

    emit(state.copyWith(status: JambClaimStatus.matching, clearResult: true));
    final result = _lookup(request);
    emit(
      result == null
          ? state.copyWith(status: JambClaimStatus.notFound)
          : state.copyWith(status: JambClaimStatus.matched, result: result),
    );
  }

  JambClaimState _voided(JambClaimState next) =>
      next.copyWith(status: JambClaimStatus.idle, clearResult: true);
}
