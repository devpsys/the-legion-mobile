import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/admissions_fixtures.dart';
import 'admissions_state.dart';

/// Drives the candidate admissions portal.
///
/// Presentation only, and deliberately so: the admissions endpoints do not exist
/// yet, so this cubit reads `presentation/mock/` and models the interactions the
/// screen offers. It has no repository and no use case because there is nothing
/// to fetch — when the API lands, swap [AdmissionsFixtures] for use cases and
/// keep every public method here, so the pages do not change.
class AdmissionsCubit extends Cubit<AdmissionsState> {
  AdmissionsCubit() : super(const AdmissionsState());

  /// Loads the candidate's record.
  ///
  /// Synchronous because the source is in memory; a repository version awaits
  /// its call and guards with [AdmissionsStatus.failure].
  void load() {
    if (state.status == AdmissionsStatus.ready) return;

    emit(state.copyWith(status: AdmissionsStatus.loading, clearFailure: true));
    emit(
      state.copyWith(
        status: AdmissionsStatus.ready,
        candidate: AdmissionsFixtures.candidate,
        cycles: AdmissionsFixtures.cycles,
        applications: AdmissionsFixtures.applications,
        bulletins: AdmissionsFixtures.bulletins,
        jambResultPending: AdmissionsFixtures.jambResultPending,
      ),
    );
  }

  /// Requests a fresh confirmation link.
  void resendEmailLink() {
    if (state.isSendingEmailLink) return;

    emit(
      state.copyWith(
        emailConfirmation: EmailConfirmationStatus.sending,
        clearFailure: true,
      ),
    );
    // The mock always succeeds; the API decides, and reports through
    // [AdmissionsStatus.failure] when it does not.
    emit(
      state.copyWith(
        emailConfirmation: EmailConfirmationStatus.sent,
        // Re-hiding the gate once it is satisfied would hide the confirmation
        // that the candidate acted.
      ),
    );
  }

  /// Hides the confirmation banner for this session.
  void dismissEmailBanner() =>
      emit(state.copyWith(isEmailBannerDismissed: true));

  /// Brings the banner back, for the header bell.
  void restoreEmailBanner() => emit(
    state.copyWith(
      isEmailBannerDismissed: false,
      emailConfirmation: EmailConfirmationStatus.idle,
    ),
  );

  /// Restores the initial state, for a fresh entry into the feature.
  void reset() => emit(const AdmissionsState());
}
