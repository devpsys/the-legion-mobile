/// View models of the student Registration & Records screens.
///
/// Presentation-only shapes fed from `presentation/mock/` until the registry
/// endpoints exist. Amounts that touch fees stay in kobo ints; units are
/// whole credits.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/theme/app_tone.dart';

/// Where the registration window stands for everyone.
enum WindowState {
  /// Not yet open.
  upcoming,

  /// Full add and submit.
  open,

  /// Courses may be added or dropped; the form is already in.
  addDropOnly,

  /// Closed to ordinary registration.
  closed,
}

/// Display tone of a [WindowState].
extension WindowStateTone on WindowState {
  AppTone get tone => switch (this) {
    WindowState.upcoming => AppTone.info,
    WindowState.open => AppTone.success,
    WindowState.addDropOnly => AppTone.warning,
    WindowState.closed => AppTone.neutral,
  };
}

/// Where a registered course stands with the adviser / department.
enum CourseApprovalStatus {
  /// Cleared by the adviser.
  approved,

  /// Waiting on the adviser — display as "Awaiting approval".
  pending,

  /// Turned down, with a reason.
  rejected,

  /// Removed by the student after it was on the form.
  dropped,

  /// Clash kept deliberately — display as "Clash accepted".
  clashAccepted,
}

/// Tone of a course approval status.
extension CourseApprovalStatusTone on CourseApprovalStatus {
  AppTone get tone => switch (this) {
    CourseApprovalStatus.approved => AppTone.success,
    CourseApprovalStatus.pending => AppTone.warning,
    CourseApprovalStatus.rejected => AppTone.danger,
    CourseApprovalStatus.dropped => AppTone.neutral,
    CourseApprovalStatus.clashAccepted => AppTone.info,
  };

  /// `true` while the course still counts toward registered units.
  bool get countsTowardUnits =>
      this == CourseApprovalStatus.approved ||
      this == CourseApprovalStatus.pending ||
      this == CourseApprovalStatus.clashAccepted;
}

/// Why a catalogue course cannot be added freely.
enum CatalogueBlock {
  /// Overlaps an already registered meeting.
  timetableClash,

  /// No seats left.
  full,

  /// A prerequisite is missing — offer a waiver request.
  missingPrerequisite,

  /// The section is not open in this window.
  notOpenYet,

  /// Outside the student's degree plan (allowed, with a note).
  outsidePlan,
}

/// Where the course form stands.
enum CourseFormStatus {
  /// Nothing submitted this window.
  notSubmitted,

  /// Saved locally, not yet with the registry.
  draft,

  /// With the registry.
  submitted,
}

/// Three-state resource gate from the bursary / records check.
enum ResourceGateKind {
  /// Cleared to proceed.
  allowed,

  /// Cannot be checked yet — amber "Not tracked", does not block.
  unverified,

  /// Blocked by a concrete reason (e.g. fees).
  blocked,
}

/// The student the registration screens bill as the subject.
class RegistrationStudent extends Equatable {
  const RegistrationStudent({
    required this.name,
    required this.matricNumber,
    required this.level,
    required this.programme,
    required this.faculty,
    required this.department,
  });

  final String name;
  final String matricNumber;
  final int level;
  final String programme;
  final String faculty;
  final String department;

  @override
  List<Object?> get props => [
    name,
    matricNumber,
    level,
    programme,
    faculty,
    department,
  ];
}

/// The academic window for registration.
class RegistrationWindow extends Equatable {
  const RegistrationWindow({
    required this.session,
    required this.termLabel,
    required this.state,
    required this.scheduleLine,
    this.overrideExpiresOn,
  });

  final String session;

  /// e.g. `First semester`.
  final String termLabel;

  final WindowState state;

  /// Prose schedule line under the identity strip.
  final String scheduleLine;

  /// When a personal "Open for you" override expires; `null` when none.
  final DateTime? overrideExpiresOn;

  /// `true` when this student alone has a personal open override.
  bool get isPersonalOverride => overrideExpiresOn != null;

  @override
  List<Object?> get props => [
    session,
    termLabel,
    state,
    scheduleLine,
    overrideExpiresOn,
  ];
}

/// One side of the three-state resource gate.
class ResourceGate extends Equatable {
  const ResourceGate({
    required this.kind,
    this.blockingReason,
    this.unverifiedDetail,
  });

  final ResourceGateKind kind;

  /// Shown when [kind] is [ResourceGateKind.blocked].
  final String? blockingReason;

  /// Shown when [kind] is [ResourceGateKind.unverified].
  final String? unverifiedDetail;

  bool get blocksRegistration => kind == ResourceGateKind.blocked;

  @override
  List<Object?> get props => [kind, blockingReason, unverifiedDetail];
}

/// A course on the student's current registration.
class RegisteredCourse extends Equatable {
  const RegisteredCourse({
    required this.id,
    required this.code,
    required this.title,
    required this.section,
    required this.units,
    required this.status,
    this.rejectReason,
    this.canDrop = true,
  });

  final String id;
  final String code;
  final String title;
  final String section;
  final int units;
  final CourseApprovalStatus status;
  final String? rejectReason;

  /// `false` for locked approved cores the window will not let go of.
  final bool canDrop;

  String get codeWithSection => '$code [$section]';

  @override
  List<Object?> get props => [
    id,
    code,
    title,
    section,
    units,
    status,
    rejectReason,
    canDrop,
  ];
}

/// A catalogue offering the student may add.
class CatalogueCourse extends Equatable {
  const CatalogueCourse({
    required this.id,
    required this.code,
    required this.title,
    required this.section,
    required this.units,
    this.block,
    this.seatsLabel,
    this.clashDetail,
    this.prerequisiteCode,
  });

  final String id;
  final String code;
  final String title;
  final String section;
  final int units;
  final CatalogueBlock? block;
  final String? seatsLabel;
  final String? clashDetail;

  /// Missing prerequisite course code shown as "Needs {code}."
  final String? prerequisiteCode;

  String get codeWithSection => '$code [$section]';

  bool get canAdd =>
      block == null ||
      block == CatalogueBlock.timetableClash ||
      block == CatalogueBlock.outsidePlan;

  @override
  List<Object?> get props => [
    id,
    code,
    title,
    section,
    units,
    block,
    seatsLabel,
    clashDetail,
    prerequisiteCode,
  ];
}

/// One meeting slot on the week strip.
class WeekMeeting extends Equatable {
  const WeekMeeting({
    required this.weekday,
    required this.startLabel,
    required this.endLabel,
    required this.courseCode,
    required this.venue,
  });

  /// Monday = 1 … Friday = 5.
  final int weekday;
  final String startLabel;
  final String endLabel;
  final String courseCode;
  final String venue;

  @override
  List<Object?> get props => [weekday, startLabel, endLabel, courseCode, venue];
}

/// A submitted (or historical) course form version.
class CourseFormRecord extends Equatable {
  const CourseFormRecord({
    required this.id,
    required this.versionLabel,
    required this.submittedOn,
    required this.status,
    required this.courses,
    required this.documentId,
    required this.formId,
    this.supersededByVersion,
  });

  final String id;
  final String versionLabel;
  final DateTime submittedOn;
  final CourseFormStatus status;
  final List<RegisteredCourse> courses;
  final String documentId;
  final String formId;
  final String? supersededByVersion;

  bool get isSuperseded => supersededByVersion != null;

  int get totalUnits => courses
      .where((c) => c.status.countsTowardUnits)
      .fold(0, (sum, c) => sum + c.units);

  @override
  List<Object?> get props => [
    id,
    versionLabel,
    submittedOn,
    status,
    courses,
    documentId,
    formId,
    supersededByVersion,
  ];
}

/// A soft advisory on the study plan ("Worth knowing now").
class StudyPlanWarning extends Equatable {
  const StudyPlanWarning({
    required this.detail,
    this.title = '',
    this.emphasis = const [],
  });

  /// Optional short heading; the structured-audit layout shows [detail] only.
  final String title;
  final String detail;

  /// Substrings in [detail] to emphasise (typically course codes).
  final List<String> emphasis;

  @override
  List<Object?> get props => [title, detail, emphasis];
}

/// One term block on the study plan.
class PlannedTerm extends Equatable {
  const PlannedTerm({
    required this.id,
    required this.label,
    required this.eyebrow,
    required this.courses,
    this.isCurrent = false,
    this.subtitle,
    this.unitsOverride,
    this.note,
    this.overLimit = false,
  });

  final String id;
  final String label;
  final String eyebrow;
  final List<RegisteredCourse> courses;
  final bool isCurrent;

  /// Compact line under the term label (e.g. SIWES / Industrial Training).
  final String? subtitle;

  /// When set, used instead of summing [courses] (e.g. compact SIWES row).
  final int? unitsOverride;
  final String? note;
  final bool overLimit;

  int get units =>
      unitsOverride ?? courses.fold(0, (sum, course) => sum + course.units);

  @override
  List<Object?> get props => [
    id,
    label,
    eyebrow,
    courses,
    isCurrent,
    subtitle,
    unitsOverride,
    note,
    overLimit,
  ];
}

/// How a degree-audit row is drawn on the structured-audit study plan.
enum DegreeAuditKind {
  /// Completed level — compact 2-column card with Passed chip.
  completed,

  /// Current level — ledger with taking-now / still-to-take rows.
  current,

  /// Electives progress strip.
  electives,
}

/// Degree-audit row on the study plan.
class DegreeAuditRow extends Equatable {
  const DegreeAuditRow({
    required this.label,
    required this.detail,
    required this.isComplete,
    this.kind = DegreeAuditKind.completed,
    this.takingNow = const [],
    this.stillToTake = const [],
    this.progressLabel,
  });

  final String label;
  final String detail;
  final bool isComplete;
  final DegreeAuditKind kind;
  final List<String> takingNow;
  final List<String> stillToTake;

  /// Electives progress, e.g. `6 of 9 units passed`.
  final String? progressLabel;

  @override
  List<Object?> get props => [
    label,
    detail,
    isComplete,
    kind,
    takingNow,
    stillToTake,
    progressLabel,
  ];
}

/// An outstanding course the student may assign to a future term.
class StudyPlanCourseOption extends Equatable {
  const StudyPlanCourseOption({
    required this.code,
    required this.title,
    required this.units,
  });

  final String code;
  final String title;
  final int units;

  String get label => '$code - $title ($units units)';

  @override
  List<Object?> get props => [code, title, units];
}

/// The student's study plan as the advising screens draw it.
class StudyPlan extends Equatable {
  const StudyPlan({
    required this.unitsPassed,
    required this.unitsPlanned,
    required this.awardUnits,
    required this.coursesStillToPass,
    required this.warnings,
    required this.adviserName,
    required this.adviserNote,
    required this.adviserNotedOn,
    required this.terms,
    required this.auditRows,
    this.programmeConclusion = '',
    this.warningsIntro = '',
    this.adviserRole = '',
    this.planOptions = const [],
    this.targetTerms = const [],
    this.howThisWorksSecondary = '',
    this.hasDegreePlan = true,
  });

  final int unitsPassed;
  final int unitsPlanned;
  final int awardUnits;
  final int coursesStillToPass;
  final List<StudyPlanWarning> warnings;
  final String adviserName;
  final String adviserNote;
  final DateTime adviserNotedOn;
  final List<PlannedTerm> terms;
  final List<DegreeAuditRow> auditRows;

  /// e.g. `2027/2028, Second semester`.
  final String programmeConclusion;
  final String warningsIntro;
  final String adviserRole;
  final List<StudyPlanCourseOption> planOptions;
  final List<String> targetTerms;
  final String howThisWorksSecondary;
  final bool hasDegreePlan;

  @override
  List<Object?> get props => [
    unitsPassed,
    unitsPlanned,
    awardUnits,
    coursesStillToPass,
    warnings,
    adviserName,
    adviserNote,
    adviserNotedOn,
    terms,
    auditRows,
    programmeConclusion,
    warningsIntro,
    adviserRole,
    planOptions,
    targetTerms,
    howThisWorksSecondary,
    hasDegreePlan,
  ];
}

/// Everything the registration portal needs for one student visit.
class RegistrationLedger extends Equatable {
  const RegistrationLedger({
    required this.student,
    required this.window,
    required this.gate,
    required this.minimumUnits,
    required this.maximumUnits,
    required this.courses,
    required this.catalogue,
    required this.week,
    required this.formStatus,
    required this.forms,
    required this.studyPlan,
    this.declarationAccepted = false,
  });

  final RegistrationStudent student;
  final RegistrationWindow window;
  final ResourceGate gate;
  final int minimumUnits;
  final int maximumUnits;
  final List<RegisteredCourse> courses;
  final List<CatalogueCourse> catalogue;
  final List<WeekMeeting> week;
  final CourseFormStatus formStatus;
  final List<CourseFormRecord> forms;
  final StudyPlan studyPlan;
  final bool declarationAccepted;

  int get registeredUnits => courses
      .where((c) => c.status.countsTowardUnits)
      .fold(0, (sum, c) => sum + c.units);

  int get pendingCount =>
      courses.where((c) => c.status == CourseApprovalStatus.pending).length;

  bool get meetsMinimum => registeredUnits >= minimumUnits;

  bool get canSubmitForm =>
      !gate.blocksRegistration &&
      meetsMinimum &&
      declarationAccepted &&
      formStatus != CourseFormStatus.submitted &&
      window.state == WindowState.open;

  @override
  List<Object?> get props => [
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
    declarationAccepted,
  ];
}
