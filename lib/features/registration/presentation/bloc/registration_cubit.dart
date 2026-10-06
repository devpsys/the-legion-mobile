import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/registration_fixtures.dart';
import '../models/registration_models.dart';
import 'registration_state.dart';

/// Drives the student Registration & Records portal.
///
/// Presentation only: the registry endpoints are not online, so this cubit
/// serves [RegistrationFixtures] and models the interactions the screens
/// offer. When the API lands, swap the fixtures for use cases and keep every
/// public method here.
class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit({RegistrationLedger? ledger})
    : _ledger = ledger ?? RegistrationFixtures.ledger,
      super(const RegistrationState());

  RegistrationLedger _ledger;

  /// Loads the student's registration record. Idempotent once ready.
  void load() {
    if (state.status == RegistrationStatus.ready) return;
    emit(
      state.copyWith(status: RegistrationStatus.loading, clearFailure: true),
    );
    _emitLedger(_ledger);
  }

  void declarationChanged(bool accepted) {
    if (state.declarationAccepted == accepted) return;
    emit(state.copyWith(declarationAccepted: accepted));
  }

  /// Asks to drop [courseId]. Opens the minimum sheet when the drop would
  /// leave the student under the required units; otherwise drops at once.
  void requestDrop(String courseId) {
    final course = state.registeredById(courseId);
    if (course == null || !course.canDrop) return;
    if (!course.status.countsTowardUnits) return;

    final nextUnits = state.registeredUnits - course.units;
    if (nextUnits < state.minimumUnits) {
      emit(
        state.copyWith(
          sheet: RegistrationSheet.dropBelowMinimum,
          sheetCourseId: courseId,
        ),
      );
      return;
    }
    _drop(courseId);
  }

  /// Confirms a drop that was held behind the minimum sheet.
  void confirmDrop() {
    final id = state.sheetCourseId;
    emit(state.copyWith(clearSheet: true));
    if (id != null) _drop(id);
  }

  void cancelSheet() => emit(state.copyWith(clearSheet: true));

  /// Re-adds a previously dropped course (rejected courses stay blocked).
  void requestReadd(String courseId) {
    final course = state.registeredById(courseId);
    if (course == null) return;
    if (course.status != CourseApprovalStatus.dropped) return;
    _readd(courseId);
  }

  /// Asks to add a catalogue course. Opens the clash sheet when needed.
  void requestAdd(String catalogueId) {
    final offer = state.catalogueById(catalogueId);
    if (offer == null) return;
    if (offer.block == CatalogueBlock.full ||
        offer.block == CatalogueBlock.notOpenYet ||
        offer.block == CatalogueBlock.missingPrerequisite) {
      return;
    }
    if (offer.block == CatalogueBlock.timetableClash) {
      emit(
        state.copyWith(
          sheet: RegistrationSheet.timetableClash,
          sheetCourseId: catalogueId,
        ),
      );
      return;
    }
    _add(offer, clashAccepted: false);
  }

  /// Confirms adding a clashing catalogue course.
  void confirmAddAnyway() {
    final id = state.sheetCourseId;
    final offer = id == null ? null : state.catalogueById(id);
    emit(state.copyWith(clearSheet: true));
    if (offer != null) _add(offer, clashAccepted: true);
  }

  /// Mock submit: records a course form and flips the form status.
  ///
  /// Does not invent a gateway — the form is the registry's own document.
  bool submitForm() {
    if (!state.canSubmitForm) return false;
    final next = RegistrationFixtures.afterSubmit(_snapshotLedger());
    _ledger = next;
    _emitLedger(next);
    return true;
  }

  void setIdCardDraftReason(IdCardReason? reason) {
    final card = state.idCard;
    if (card == null) return;
    emit(
      state.copyWith(
        idCard: reason == null
            ? card.copyWith(clearDraftReason: true)
            : card.copyWith(draftReason: reason),
      ),
    );
  }

  /// Submits a first-issue or replacement ID card request when unlocked.
  bool submitIdCardRequest() {
    final card = state.idCard;
    if (card == null || !card.canSubmitRequest) return false;
    final reason = card.draftReason!;
    final serial =
        'LG/ID/2026/${(8900 + card.history.length).toString().padLeft(5, '0')}';
    final feeRequired = !card.isFirstIssue;
    final next = card.copyWith(
      hasEverHeldCard: true,
      clearDraftReason: true,
      activeRequest: IdCardActiveRequest(
        serial: serial,
        status: IdCardStatus.requested,
        reason: reason,
        requestedOn: DateTime(2026, 10, 6),
        feePayment: feeRequired
            ? IdCardFeePayment.unpaid
            : IdCardFeePayment.notRequired,
        feeMinorUnits: feeRequired ? card.replacementFeeMinorUnits : 0,
        canCancel: true,
      ),
    );
    emit(state.copyWith(idCard: next));
    return true;
  }

  void requestCancelIdCard() {
    final active = state.idCard?.activeRequest;
    if (active == null || !active.canCancel) return;
    emit(state.copyWith(sheet: RegistrationSheet.cancelIdCardRequest));
  }

  void confirmCancelIdCard() {
    final card = state.idCard;
    emit(state.copyWith(clearSheet: true));
    if (card == null) return;
    emit(state.copyWith(idCard: card.copyWith(clearActiveRequest: true)));
  }

  void setAcademicDraftType(AcademicRequestType type) {
    emit(state.copyWith(academicDraft: state.academicDraft.copyWith(type: type)));
  }

  void setAcademicDraftCourse(String value) {
    emit(
      state.copyWith(academicDraft: state.academicDraft.copyWith(courseCode: value)),
    );
  }

  void setAcademicDraftPrerequisite(String value) {
    emit(
      state.copyWith(
        academicDraft: state.academicDraft.copyWith(prerequisiteCode: value),
      ),
    );
  }

  void setAcademicDraftReasons(String value) {
    emit(
      state.copyWith(academicDraft: state.academicDraft.copyWith(reasons: value)),
    );
  }

  /// Files a new academic petition from the draft (mock).
  bool submitAcademicRequest() {
    final draft = state.academicDraft;
    if (draft.reasons.trim().isEmpty) return false;
    if (draft.type == AcademicRequestType.waivePrerequisite) {
      if (draft.courseCode.trim().isEmpty ||
          draft.prerequisiteCode.trim().isEmpty) {
        return false;
      }
    }

    final summary = switch (draft.type) {
      AcademicRequestType.waivePrerequisite =>
        'Take ${draft.courseCode.trim()} without ${draft.prerequisiteCode.trim()}',
      AcademicRequestType.overload => draft.reasons.trim(),
      AcademicRequestType.underload => draft.reasons.trim(),
      AcademicRequestType.lateRegistration => draft.reasons.trim(),
      AcademicRequestType.addDropAfterDeadline => draft.reasons.trim(),
      AcademicRequestType.changeOfProgramme => draft.reasons.trim(),
    };

    final emphasis = <String>[
      if (draft.courseCode.trim().isNotEmpty) draft.courseCode.trim(),
      if (draft.prerequisiteCode.trim().isNotEmpty)
        draft.prerequisiteCode.trim(),
    ];

    final request = AcademicRequest(
      id: 'req-${DateTime(2026, 10, 6).millisecondsSinceEpoch}',
      type: draft.type,
      title: _academicTitle(draft.type),
      summary: summary,
      filedOn: DateTime(2026, 10, 6),
      status: AcademicRequestStatus.pending,
      canWithdraw: true,
      emphasis: emphasis,
    );

    emit(
      state.copyWith(
        academicRequests: [request, ...state.academicRequests],
        academicDraft: AcademicRequestDraft(type: draft.type),
      ),
    );
    return true;
  }

  void requestWithdrawAcademic(String requestId) {
    final request = state.academicRequestById(requestId);
    if (request == null || !request.canWithdraw) return;
    emit(
      state.copyWith(
        sheet: RegistrationSheet.withdrawAcademicRequest,
        sheetCourseId: requestId,
      ),
    );
  }

  void confirmWithdrawAcademic() {
    final id = state.sheetCourseId;
    emit(state.copyWith(clearSheet: true));
    if (id == null) return;
    final updated = state.academicRequests
        .map((request) {
          if (request.id != id) return request;
          return AcademicRequest(
            id: request.id,
            type: request.type,
            title: request.title,
            summary: request.summary,
            filedOn: request.filedOn,
            status: AcademicRequestStatus.withdrawn,
            decisionNote: request.decisionNote,
            emphasis: request.emphasis,
          );
        })
        .toList(growable: false);
    emit(state.copyWith(academicRequests: updated));
  }

  static String _academicTitle(AcademicRequestType type) => switch (type) {
    AcademicRequestType.lateRegistration => 'Late registration',
    AcademicRequestType.addDropAfterDeadline =>
      'Add or drop courses after the deadline',
    AcademicRequestType.overload => 'Register more units than allowed',
    AcademicRequestType.underload => 'Register fewer units than the minimum',
    AcademicRequestType.waivePrerequisite => 'Waive a prerequisite',
    AcademicRequestType.changeOfProgramme => 'Change of programme',
  };

  void _drop(String courseId) {
    final updated = state.courses
        .map((course) {
          if (course.id != courseId) return course;
          return RegisteredCourse(
            id: course.id,
            code: course.code,
            title: course.title,
            section: course.section,
            units: course.units,
            status: CourseApprovalStatus.dropped,
            rejectReason: course.rejectReason,
            canDrop: false,
          );
        })
        .toList(growable: false);
    emit(state.copyWith(courses: updated, clearSheet: true));
  }

  void _readd(String courseId) {
    final updated = state.courses
        .map((course) {
          if (course.id != courseId) return course;
          return RegisteredCourse(
            id: course.id,
            code: course.code,
            title: course.title,
            section: course.section,
            units: course.units,
            status: CourseApprovalStatus.pending,
            canDrop: true,
          );
        })
        .toList(growable: false);
    emit(state.copyWith(courses: updated, clearSheet: true));
  }

  void _add(CatalogueCourse offer, {required bool clashAccepted}) {
    if (state.courses.any(
      (c) =>
          c.code == offer.code &&
          c.section == offer.section &&
          c.status.countsTowardUnits,
    )) {
      return;
    }

    final droppedMatches = state.courses
        .where(
          (c) =>
              c.code == offer.code &&
              c.section == offer.section &&
              c.status == CourseApprovalStatus.dropped,
        )
        .toList(growable: false);
    if (droppedMatches.isNotEmpty) {
      final matchId = droppedMatches.first.id;
      final revived = state.courses
          .map((course) {
            if (course.id != matchId) return course;
            return RegisteredCourse(
              id: course.id,
              code: course.code,
              title: course.title,
              section: course.section,
              units: course.units,
              status: clashAccepted
                  ? CourseApprovalStatus.clashAccepted
                  : CourseApprovalStatus.pending,
              canDrop: true,
            );
          })
          .toList(growable: false);
      final catalogue = state.catalogue
          .where((c) => c.id != offer.id)
          .toList(growable: false);
      emit(
        state.copyWith(
          courses: revived,
          catalogue: catalogue,
          clearSheet: true,
        ),
      );
      return;
    }

    final added = RegisteredCourse(
      id: 'reg-${offer.id}',
      code: offer.code,
      title: offer.title,
      section: offer.section,
      units: offer.units,
      status: clashAccepted
          ? CourseApprovalStatus.clashAccepted
          : CourseApprovalStatus.pending,
    );
    final catalogue = state.catalogue
        .where((c) => c.id != offer.id)
        .toList(growable: false);
    emit(
      state.copyWith(
        courses: [...state.courses, added],
        catalogue: catalogue,
        clearSheet: true,
      ),
    );
  }

  RegistrationLedger _snapshotLedger() {
    return RegistrationLedger(
      student: state.student!,
      window: state.window!,
      gate: state.gate!,
      minimumUnits: state.minimumUnits,
      maximumUnits: state.maximumUnits,
      courses: state.courses,
      catalogue: state.catalogue,
      week: state.week,
      formStatus: state.formStatus,
      forms: state.forms,
      studyPlan: state.studyPlan!,
      idCard: state.idCard!,
      academicRequests: state.academicRequests,
      declarationAccepted: state.declarationAccepted,
    );
  }

  void _emitLedger(RegistrationLedger ledger) {
    emit(
      state.copyWith(
        status: RegistrationStatus.ready,
        student: ledger.student,
        window: ledger.window,
        gate: ledger.gate,
        minimumUnits: ledger.minimumUnits,
        maximumUnits: ledger.maximumUnits,
        courses: ledger.courses,
        catalogue: ledger.catalogue,
        week: ledger.week,
        formStatus: ledger.formStatus,
        forms: ledger.forms,
        studyPlan: ledger.studyPlan,
        idCard: ledger.idCard,
        academicRequests: ledger.academicRequests,
        declarationAccepted: ledger.declarationAccepted,
        clearFailure: true,
        clearSheet: true,
      ),
    );
  }
}
