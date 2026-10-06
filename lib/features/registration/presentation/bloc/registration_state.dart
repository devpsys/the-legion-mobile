import 'package:equatable/equatable.dart';

import '../models/registration_models.dart';

/// Loading status of the registration portal.
enum RegistrationStatus { initial, loading, ready, failure }

/// Why a drop, add, withdraw, or cancel needs a confirmation sheet.
enum RegistrationSheet {
  /// Adding a course that clashes with the timetable.
  timetableClash,

  /// Dropping would leave the student under the minimum units.
  dropBelowMinimum,

  /// Withdrawing a pending academic petition.
  withdrawAcademicRequest,

  /// Cancelling an in-progress ID card request.
  cancelIdCardRequest,

  /// Confirming a disciplinary appeal before it is lodged.
  lodgeDisciplineAppeal,
}

/// State of the Registration & Records student portal.
class RegistrationState extends Equatable {
  const RegistrationState({
    this.status = RegistrationStatus.initial,
    this.student,
    this.window,
    this.gate,
    this.minimumUnits = 0,
    this.maximumUnits = 0,
    this.courses = const [],
    this.catalogue = const [],
    this.week = const [],
    this.formStatus = CourseFormStatus.notSubmitted,
    this.forms = const [],
    this.studyPlan,
    this.idCard,
    this.academicRequests = const [],
    this.academicDraft = const AcademicRequestDraft(),
    this.discipline,
    this.declarationAccepted = false,
    this.sheet,
    this.sheetCourseId,
    this.failureMessage,
  });

  final RegistrationStatus status;
  final RegistrationStudent? student;
  final RegistrationWindow? window;
  final ResourceGate? gate;
  final int minimumUnits;
  final int maximumUnits;
  final List<RegisteredCourse> courses;
  final List<CatalogueCourse> catalogue;
  final List<WeekMeeting> week;
  final CourseFormStatus formStatus;
  final List<CourseFormRecord> forms;
  final StudyPlan? studyPlan;
  final IdCardRecord? idCard;
  final List<AcademicRequest> academicRequests;
  final AcademicRequestDraft academicDraft;
  final DisciplineRecord? discipline;
  final bool declarationAccepted;

  /// Open confirmation sheet, if any.
  final RegistrationSheet? sheet;

  /// Course or academic-request id the open sheet is about.
  final String? sheetCourseId;

  final String? failureMessage;

  int get registeredUnits => courses
      .where((c) => c.status.countsTowardUnits)
      .fold(0, (sum, c) => sum + c.units);

  int get pendingCount =>
      courses.where((c) => c.status == CourseApprovalStatus.pending).length;

  int get activeCourseCount =>
      courses.where((c) => c.status.countsTowardUnits).length;

  bool get meetsMinimum => registeredUnits >= minimumUnits;

  bool get blocksRegistration => gate?.blocksRegistration ?? false;

  bool get canSubmitForm {
    final windowState = window?.state;
    return !blocksRegistration &&
        meetsMinimum &&
        declarationAccepted &&
        formStatus != CourseFormStatus.submitted &&
        windowState == WindowState.open;
  }

  RegisteredCourse? registeredById(String id) {
    for (final course in courses) {
      if (course.id == id) return course;
    }
    return null;
  }

  CatalogueCourse? catalogueById(String id) {
    for (final course in catalogue) {
      if (course.id == id) return course;
    }
    return null;
  }

  AcademicRequest? academicRequestById(String id) {
    for (final request in academicRequests) {
      if (request.id == id) return request;
    }
    return null;
  }

  DisciplineCase? disciplineCaseById(String id) => discipline?.caseById(id);

  CourseFormRecord? get latestForm => forms.isEmpty ? null : forms.first;

  RegistrationState copyWith({
    RegistrationStatus? status,
    RegistrationStudent? student,
    RegistrationWindow? window,
    ResourceGate? gate,
    int? minimumUnits,
    int? maximumUnits,
    List<RegisteredCourse>? courses,
    List<CatalogueCourse>? catalogue,
    List<WeekMeeting>? week,
    CourseFormStatus? formStatus,
    List<CourseFormRecord>? forms,
    StudyPlan? studyPlan,
    IdCardRecord? idCard,
    List<AcademicRequest>? academicRequests,
    AcademicRequestDraft? academicDraft,
    DisciplineRecord? discipline,
    bool? declarationAccepted,
    RegistrationSheet? sheet,
    String? sheetCourseId,
    bool clearSheet = false,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return RegistrationState(
      status: status ?? this.status,
      student: student ?? this.student,
      window: window ?? this.window,
      gate: gate ?? this.gate,
      minimumUnits: minimumUnits ?? this.minimumUnits,
      maximumUnits: maximumUnits ?? this.maximumUnits,
      courses: courses ?? this.courses,
      catalogue: catalogue ?? this.catalogue,
      week: week ?? this.week,
      formStatus: formStatus ?? this.formStatus,
      forms: forms ?? this.forms,
      studyPlan: studyPlan ?? this.studyPlan,
      idCard: idCard ?? this.idCard,
      academicRequests: academicRequests ?? this.academicRequests,
      academicDraft: academicDraft ?? this.academicDraft,
      discipline: discipline ?? this.discipline,
      declarationAccepted: declarationAccepted ?? this.declarationAccepted,
      sheet: clearSheet ? null : (sheet ?? this.sheet),
      sheetCourseId: clearSheet ? null : (sheetCourseId ?? this.sheetCourseId),
      failureMessage: clearFailure
          ? null
          : (failureMessage ?? this.failureMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    student,
    window,
    gate,
    minimumUnits,
    maximumUnits,
    courses,
    catalogue,
    week,
    formStatus,
    forms,
    studyPlan,
    idCard,
    academicRequests,
    academicDraft,
    discipline,
    declarationAccepted,
    sheet,
    sheetCourseId,
    failureMessage,
  ];
}
