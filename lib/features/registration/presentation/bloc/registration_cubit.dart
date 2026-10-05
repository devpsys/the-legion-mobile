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
    final next = RegistrationFixtures.afterSubmit(
      RegistrationLedger(
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
        declarationAccepted: state.declarationAccepted,
      ),
    );
    _ledger = next;
    _emitLedger(next);
    return true;
  }

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
        declarationAccepted: ledger.declarationAccepted,
        clearFailure: true,
        clearSheet: true,
      ),
    );
  }
}
