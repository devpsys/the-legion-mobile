import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/fees_fixtures.dart';
import '../models/fees_models.dart';
import 'fees_state.dart';

/// Drives the student fees screen.
///
/// Presentation only, like the admissions portal it is modelled on: the
/// bursary endpoints do not exist yet, so this cubit reads a ledger from
/// `presentation/mock/`. It has no repository and no use case because there
/// is nothing to fetch — when the API lands, swap the ledger for a use case
/// and keep the public methods, so the pages do not change.
///
/// The ledger is injectable so the screen can be tested against any record
/// — a student with nothing owed, one with nothing paid — without the fixture
/// having to be all of them at once.
class FeesCubit extends Cubit<FeesState> {
  FeesCubit({FeesLedger? ledger})
    : _ledger = ledger ?? FeesFixtures.ledger,
      super(const FeesState());

  final FeesLedger _ledger;

  /// Loads the student's ledger.
  ///
  /// Idempotent: the fees tab and the checkout above it both call it on
  /// entry, and whichever is first does the reading. Synchronous because the
  /// source is in memory; a repository version awaits its call and guards
  /// with [FeesStatus.failure].
  void load() {
    if (state.status == FeesStatus.ready) return;

    emit(state.copyWith(status: FeesStatus.loading, clearFailure: true));
    emit(
      state.copyWith(
        status: FeesStatus.ready,
        student: _ledger.student,
        session: _ledger.session,
        invoices: _ledger.invoices,
        payments: _ledger.payments,
        terms: _ledger.terms,
      ),
    );
  }
}
