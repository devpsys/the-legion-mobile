import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/admissions_fixtures.dart';
import '../mock/programme_fixtures.dart';
import '../models/application_detail_models.dart';
import '../models/jamb_models.dart';
import '../models/programme_models.dart';
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
        applicationDetails: AdmissionsFixtures.applicationDetails,
        bulletins: AdmissionsFixtures.bulletins,
        programmes: ProgrammeFixtures.programmes,
        jambResultPending: AdmissionsFixtures.jambResultPending,
        jambLinkApplicationId: AdmissionsFixtures.jambLinkApplicationId,
        selectedCycleId: ProgrammeFixtures.defaultCycleId,
      ),
    );
  }

  /// Opens a draft application to [programmeId] under the cycle the browser
  /// is showing, and returns its id — or `null` when the portal would refuse.
  ///
  /// The refusal mirrors the card: no "Apply" is offered where this returns
  /// `null`, and the check is repeated here so a tap on a card drawn a moment
  /// before the record changed cannot open a second draft in the same
  /// category. The draft goes to the top of the record, which is newest
  /// first, with the detail screen's content already behind it.
  String? startApplication(String programmeId, {required DateTime now}) {
    final programme = state.programmeById(programmeId);
    final cycle = state.selectedCycle;
    if (programme == null || cycle == null) return null;
    if (state.applyAvailabilityFor(programme, now) !=
        ApplyAvailability.available) {
      return null;
    }

    final draft = AdmissionsFixtures.startDraft(
      programme: programme,
      cycle: cycle,
      startedOn: now,
      existing: state.applications,
      linkedJambResult: state.linkedJambResult,
    );
    emit(
      state.copyWith(
        applications: [draft.application, ...state.applications],
        applicationDetails: {
          ...state.applicationDetails,
          draft.application.id: draft,
        },
        clearFailure: true,
      ),
    );
    return draft.application.id;
  }

  /// Puts a matched JAMB result on the record, for good.
  ///
  /// The claim screen matches; this links. Once linked the import has nothing
  /// pending, so the tab's badge and the overview's claim card go, and every
  /// checklist row that was waiting on the score is ticked — the one row the
  /// portal can complete without a form behind it, on whichever draft asks
  /// for it. A second link is ignored: the screen says it cannot be undone,
  /// and the cubit keeps that true.
  void linkJambResult(JambResult result) {
    if (state.hasLinkedJambResult) return;

    emit(
      state.copyWith(
        linkedJambResult: result,
        jambResultPending: false,
        applicationDetails: _withJambClaimed(result),
        clearFailure: true,
      ),
    );
  }

  /// The details with every `claimJamb` row marked met.
  ///
  /// A record without such a row is returned as it was, so the identity of
  /// an untouched detail survives the link.
  Map<String, ApplicationDetail> _withJambClaimed(JambResult result) {
    return {
      for (final MapEntry(key: id, value: detail)
          in state.applicationDetails.entries)
        id:
            detail.checklist.any(
              (item) => item.action == ChecklistAction.claimJamb,
            )
            ? _withJambRowMet(detail, result)
            : detail,
    };
  }

  ApplicationDetail _withJambRowMet(
    ApplicationDetail detail,
    JambResult result,
  ) {
    final checklist = [
      for (final item in detail.checklist)
        if (item.action == ChecklistAction.claimJamb)
          ChecklistItem(
            id: item.id,
            state: RequirementState.met,
            title: item.title,
            detail: AdmissionsFixtures.jambLinkedChecklistDetail(result),
          )
        else
          item,
    ];
    return ApplicationDetail(
      application: detail.application,
      cycleId: detail.cycleId,
      firstChoiceProgrammeId: detail.firstChoiceProgrammeId,
      secondChoiceProgrammeId: detail.secondChoiceProgrammeId,
      history: detail.history,
      checklist: checklist,
      referees: detail.referees,
      offer: detail.offer,
      letter: detail.letter,
      rejection: detail.rejection,
      expiredOn: detail.expiredOn,
      withdrawal: detail.withdrawal,
    );
  }

  /// Narrows the catalogue by free text.
  ///
  /// Held here rather than in the search field so the count in the header, the
  /// filter chips and the list cannot disagree about what is on screen.
  void searchProgrammes(String query) {
    if (state.programmeQuery == query) return;
    emit(state.copyWith(programmeQuery: query));
  }

  /// Picks a faculty, or passes `null` for every faculty.
  void selectFaculty(Faculty? faculty) {
    if (state.selectedFaculty == faculty) return;
    emit(
      state.copyWith(selectedFaculty: faculty, clearFaculty: faculty == null),
    );
  }

  /// Switches the cycle the browser is quoted against.
  ///
  /// The programme list itself is not refetched: the catalogue endpoint is not
  /// built, and pretending a cycle switch changes it would be showing a
  /// candidate a list the server has not confirmed for that cycle.
  void selectCycle(String cycleId) {
    if (state.selectedCycleId == cycleId) return;
    if (state.cycleById(cycleId) == null) return;
    emit(state.copyWith(selectedCycleId: cycleId));
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
