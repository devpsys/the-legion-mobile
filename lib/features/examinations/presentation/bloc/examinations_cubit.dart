import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/examinations_fixtures.dart';
import '../models/examinations_models.dart';
import 'examinations_state.dart';

/// Drives the student Examinations & Results portal: the results hub, the
/// examination card and resit registration.
///
/// Presentation only — fixtures until the examinations endpoints land. The
/// ledger is injected so tests and previews can start a student in any state.
class ExaminationsCubit extends Cubit<ExaminationsState> {
  ExaminationsCubit({ExaminationsLedger? ledger})
    : _ledger = ledger ?? ExaminationsFixtures.ledger,
      super(const ExaminationsState());

  ExaminationsLedger _ledger;

  /// Loads the ledger once; later calls keep what the student already did.
  void load() {
    if (state.status == ExaminationsStatus.ready) return;
    _emitLedger();
  }

  /// Replaces the fixture ledger so every state can be previewed.
  ///
  /// Used by the debug preview menu only; production traffic never calls it.
  void previewScenario(ExaminationsPreviewScenario scenario) {
    _ledger = ExaminationsFixtures.ledgerFor(scenario);
    _emitLedger();
  }

  void _emitLedger() {
    emit(
      state.copyWith(status: ExaminationsStatus.loading, clearFailure: true),
    );
    emit(
      state.copyWith(
        status: ExaminationsStatus.ready,
        student: _ledger.student,
        sessionLabel: _ledger.sessionLabel,
        results: _ledger.results,
        card: _ledger.card,
        resits: _ledger.resits,
        clearFailure: true,
        clearNotice: true,
      ),
    );
  }

  /// Registers the student for the resit of [courseCode].
  ///
  /// Returns `false` when the window is closed, the course is not on the
  /// student's failure list, or its units do not fit what is left of the
  /// semester's allowance. The fee is invoiced here; it is not charged.
  bool registerResit(String courseCode) {
    final resits = state.resits;
    if (resits == null) return false;
    final failure = resits.failureFor(courseCode);
    if (failure == null) return false;
    if (!resits.isOpen) {
      emit(state.copyWith(notice: ExaminationsNotice.resitWindowClosed));
      return false;
    }
    if (failure.units > resits.unitsLeft) {
      emit(state.copyWith(notice: ExaminationsNotice.resitOverBudget));
      return false;
    }

    final registration = ResitRegistration(
      code: failure.code,
      title: failure.title,
      units: failure.units,
      termLabel: resits.windowLabel,
      feeMinorUnits: resits.feeFor(failure),
      invoiceReference: 'RS-${99215 + resits.registrations.length}',
    );
    emit(
      state.copyWith(
        resits: resits.copyWith(
          failures: [
            for (final entry in resits.failures)
              if (entry.code != courseCode) entry,
          ],
          registrations: [...resits.registrations, registration],
        ),
        notice: ExaminationsNotice.resitRegistered,
      ),
    );
    return true;
  }

  void clearNotice() => emit(state.copyWith(clearNotice: true));
}
