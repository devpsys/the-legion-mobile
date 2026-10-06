import 'package:equatable/equatable.dart';

import '../../../../../core/theme/app_tone.dart';
import '../registration_models.dart';

/// Filter on the HoD registration-approvals queue.
enum ApprovalsQueueFilter { awaiting, approved, all }

/// Filter on the student-requests decision queue.
enum RequestDecisionFilter { all, pending, decided }

/// One course form waiting in the HoD approvals queue.
class ApprovalQueueItem extends Equatable {
  const ApprovalQueueItem({
    required this.studentId,
    required this.name,
    required this.matricNumber,
    required this.programmeCode,
    required this.level,
    required this.pendingCourseCount,
    required this.processed,
    this.atMinimum = false,
    this.hasClash = false,
  });

  final String studentId;
  final String name;
  final String matricNumber;
  final String programmeCode;
  final int level;
  final int pendingCourseCount;
  final bool processed;
  final bool atMinimum;
  final bool hasClash;

  @override
  List<Object?> get props => [
    studentId,
    name,
    matricNumber,
    programmeCode,
    level,
    pendingCourseCount,
    processed,
    atMinimum,
    hasClash,
  ];
}

/// One course line on a student's form under review.
class ApprovalCourseLine extends Equatable {
  const ApprovalCourseLine({
    required this.id,
    required this.code,
    required this.title,
    required this.section,
    required this.units,
    required this.status,
    this.clashAccepted = false,
    this.decidedBy = '',
    this.decidedOn,
    this.selected = false,
  });

  final String id;
  final String code;
  final String title;
  final String section;
  final int units;
  final CourseApprovalStatus status;
  final bool clashAccepted;
  final String decidedBy;
  final DateTime? decidedOn;
  final bool selected;

  bool get isPending => status == CourseApprovalStatus.pending;

  ApprovalCourseLine copyWith({
    CourseApprovalStatus? status,
    bool? selected,
    String? decidedBy,
    DateTime? decidedOn,
  }) {
    return ApprovalCourseLine(
      id: id,
      code: code,
      title: title,
      section: section,
      units: units,
      status: status ?? this.status,
      clashAccepted: clashAccepted,
      decidedBy: decidedBy ?? this.decidedBy,
      decidedOn: decidedOn ?? this.decidedOn,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
    id,
    code,
    title,
    section,
    units,
    status,
    clashAccepted,
    decidedBy,
    decidedOn,
    selected,
  ];
}

/// Full course-form dossier the HoD decides on.
class StudentRegistrationReview extends Equatable {
  const StudentRegistrationReview({
    required this.studentId,
    required this.name,
    required this.matricNumber,
    required this.programme,
    required this.level,
    required this.sessionLabel,
    required this.registeredUnits,
    required this.maximumUnits,
    required this.minimumUnits,
    required this.courses,
    this.directDepartment = false,
    this.rejectDraft = '',
  });

  final String studentId;
  final String name;
  final String matricNumber;
  final String programme;
  final int level;
  final String sessionLabel;
  final int registeredUnits;
  final int maximumUnits;
  final int minimumUnits;
  final List<ApprovalCourseLine> courses;

  /// When true, the department registers courses directly — no approve queue.
  final bool directDepartment;
  final String rejectDraft;

  int get pendingCount => courses.where((c) => c.isPending).length;

  bool get atMinimum => registeredUnits <= minimumUnits;

  List<ApprovalCourseLine> get selectedPending => courses
      .where((c) => c.isPending && c.selected)
      .toList(growable: false);

  StudentRegistrationReview copyWith({
    List<ApprovalCourseLine>? courses,
    bool? directDepartment,
    String? rejectDraft,
  }) {
    return StudentRegistrationReview(
      studentId: studentId,
      name: name,
      matricNumber: matricNumber,
      programme: programme,
      level: level,
      sessionLabel: sessionLabel,
      registeredUnits: registeredUnits,
      maximumUnits: maximumUnits,
      minimumUnits: minimumUnits,
      courses: courses ?? this.courses,
      directDepartment: directDepartment ?? this.directDepartment,
      rejectDraft: rejectDraft ?? this.rejectDraft,
    );
  }

  @override
  List<Object?> get props => [
    studentId,
    name,
    matricNumber,
    programme,
    level,
    sessionLabel,
    registeredUnits,
    maximumUnits,
    minimumUnits,
    courses,
    directDepartment,
    rejectDraft,
  ];
}

/// A student petition waiting for a HoD decision.
class RequestDecisionItem extends Equatable {
  const RequestDecisionItem({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.studentName,
    required this.matricNumber,
    required this.programmeCode,
    required this.level,
    required this.filedOn,
    required this.status,
    required this.effectNote,
    required this.studentNote,
    this.decisionNote = '',
    this.rejectDraft = '',
  });

  final String id;
  final AcademicRequestType type;
  final String title;
  final String summary;
  final String studentName;
  final String matricNumber;
  final String programmeCode;
  final int level;
  final DateTime filedOn;
  final AcademicRequestStatus status;
  final String effectNote;
  final String studentNote;
  final String decisionNote;
  final String rejectDraft;

  bool get isPending => status == AcademicRequestStatus.pending;

  RequestDecisionItem copyWith({
    AcademicRequestStatus? status,
    String? decisionNote,
    String? rejectDraft,
  }) {
    return RequestDecisionItem(
      id: id,
      type: type,
      title: title,
      summary: summary,
      studentName: studentName,
      matricNumber: matricNumber,
      programmeCode: programmeCode,
      level: level,
      filedOn: filedOn,
      status: status ?? this.status,
      effectNote: effectNote,
      studentNote: studentNote,
      decisionNote: decisionNote ?? this.decisionNote,
      rejectDraft: rejectDraft ?? this.rejectDraft,
    );
  }

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    summary,
    studentName,
    matricNumber,
    programmeCode,
    level,
    filedOn,
    status,
    effectNote,
    studentNote,
    decisionNote,
    rejectDraft,
  ];
}

/// Advising view of a student's study plan (staff).
class StudyPlanAdvice extends Equatable {
  const StudyPlanAdvice({
    required this.studentId,
    required this.name,
    required this.matricNumber,
    required this.programme,
    required this.unitsPassed,
    required this.unitsPlanned,
    required this.awardThreshold,
    required this.coursesStillToPass,
    required this.terms,
    required this.warnings,
    this.adviceDraft = '',
  });

  final String studentId;
  final String name;
  final String matricNumber;
  final String programme;
  final int unitsPassed;
  final int unitsPlanned;
  final int awardThreshold;
  final int coursesStillToPass;
  final List<StudyPlanTermAdvice> terms;
  final List<String> warnings;
  final String adviceDraft;

  StudyPlanAdvice copyWith({String? adviceDraft}) {
    return StudyPlanAdvice(
      studentId: studentId,
      name: name,
      matricNumber: matricNumber,
      programme: programme,
      unitsPassed: unitsPassed,
      unitsPlanned: unitsPlanned,
      awardThreshold: awardThreshold,
      coursesStillToPass: coursesStillToPass,
      terms: terms,
      warnings: warnings,
      adviceDraft: adviceDraft ?? this.adviceDraft,
    );
  }

  @override
  List<Object?> get props => [
    studentId,
    name,
    matricNumber,
    programme,
    unitsPassed,
    unitsPlanned,
    awardThreshold,
    coursesStillToPass,
    terms,
    warnings,
    adviceDraft,
  ];
}

class StudyPlanTermAdvice extends Equatable {
  const StudyPlanTermAdvice({
    required this.label,
    required this.plannedUnits,
    required this.maximumUnits,
    required this.courseCodes,
    this.overCeiling = false,
  });

  final String label;
  final int plannedUnits;
  final int maximumUnits;
  final List<String> courseCodes;
  final bool overCeiling;

  @override
  List<Object?> get props => [
    label,
    plannedUnits,
    maximumUnits,
    courseCodes,
    overCeiling,
  ];
}

extension ApprovalsQueueFilterX on ApprovalsQueueFilter {
  AppTone get tone => switch (this) {
    ApprovalsQueueFilter.awaiting => AppTone.warning,
    ApprovalsQueueFilter.approved => AppTone.success,
    ApprovalsQueueFilter.all => AppTone.neutral,
  };
}
