import 'package:equatable/equatable.dart';

import '../../../../core/theme/app_tone.dart';

/// Student standing as it affects portal access (README rule 3).
enum StudentStanding { active, suspended, expelled }

/// Lifecycle of a disciplinary case (display labels differ from enum names).
enum DisciplineCaseStatus {
  underInvestigation,
  hearingScheduled,
  decided,
  underAppeal,
}

/// Gravity of the allegation.
enum DisciplineSeverity { minor, major }

/// Category of misconduct.
enum DisciplineCategory { examinationMisconduct, harassment }

/// Finding recorded when a case is decided.
enum DisciplineFinding { foundLiable, notLiable }

/// Kind of sanction imposed.
enum SanctionType { warning, probation, suspension, expulsion }

/// Whether a sanction is still in force.
enum SanctionLifecycle { active, served, lifted }

/// Kind of evidence item on the case file.
enum EvidenceKind { document, writtenStatement }

extension StudentStandingX on StudentStanding {
  bool get isInGoodStanding => this == StudentStanding.active;

  AppTone get tone => switch (this) {
    StudentStanding.active => AppTone.success,
    StudentStanding.suspended => AppTone.danger,
    StudentStanding.expelled => AppTone.danger,
  };
}

extension DisciplineCaseStatusX on DisciplineCaseStatus {
  AppTone get tone => switch (this) {
    DisciplineCaseStatus.underInvestigation => AppTone.info,
    DisciplineCaseStatus.hearingScheduled => AppTone.warning,
    DisciplineCaseStatus.decided => AppTone.neutral,
    DisciplineCaseStatus.underAppeal => AppTone.warning,
  };
}

extension DisciplineSeverityX on DisciplineSeverity {
  AppTone get tone => switch (this) {
    DisciplineSeverity.minor => AppTone.info,
    DisciplineSeverity.major => AppTone.danger,
  };
}

extension SanctionTypeX on SanctionType {
  AppTone get tone => switch (this) {
    SanctionType.warning => AppTone.warning,
    SanctionType.probation => AppTone.warning,
    SanctionType.suspension => AppTone.danger,
    SanctionType.expulsion => AppTone.danger,
  };
}

extension SanctionLifecycleX on SanctionLifecycle {
  AppTone get tone => switch (this) {
    SanctionLifecycle.active => AppTone.danger,
    SanctionLifecycle.served => AppTone.neutral,
    SanctionLifecycle.lifted => AppTone.success,
  };
}

/// One evidence item the student may inspect before a hearing.
class DisciplineEvidence extends Equatable {
  const DisciplineEvidence({
    required this.title,
    required this.kind,
    this.detail = '',
  });

  final String title;
  final EvidenceKind kind;
  final String detail;

  @override
  List<Object?> get props => [title, kind, detail];
}

/// Hearing appointment or record.
class DisciplineHearing extends Equatable {
  const DisciplineHearing({
    required this.heldOn,
    required this.venue,
    this.note = '',
    this.scheduled = false,
  });

  final DateTime heldOn;
  final String venue;
  final String note;

  /// True when the hearing is upcoming rather than already held.
  final bool scheduled;

  @override
  List<Object?> get props => [heldOn, venue, note, scheduled];
}

/// Sanction linked to a case.
class DisciplineSanction extends Equatable {
  const DisciplineSanction({
    required this.caseId,
    required this.type,
    required this.summary,
    required this.lifecycle,
    this.statusNote = '',
  });

  final String caseId;
  final SanctionType type;
  final String summary;
  final SanctionLifecycle lifecycle;

  /// Extra copy (e.g. probation does not change status; expulsion is permanent).
  final String statusNote;

  @override
  List<Object?> get props => [caseId, type, summary, lifecycle, statusNote];
}

/// An appeal lodged against a decided case.
class DisciplineAppeal extends Equatable {
  const DisciplineAppeal({
    required this.grounds,
    required this.lodgedOn,
  });

  final String grounds;
  final DateTime lodgedOn;

  @override
  List<Object?> get props => [grounds, lodgedOn];
}

/// One disciplinary case on the student's record.
class DisciplineCase extends Equatable {
  const DisciplineCase({
    required this.id,
    required this.reference,
    required this.summary,
    required this.status,
    required this.severity,
    required this.category,
    required this.openedOn,
    required this.narrative,
    required this.incidentOn,
    required this.incidentVenue,
    required this.sessionLabel,
    required this.reportedBy,
    required this.reportedOn,
    required this.evidence,
    this.finding,
    this.decidedOn,
    this.decisionReason,
    this.hearing,
    this.sanction,
    this.appealWindowClosesOn,
    this.appeal,
    this.listDetail = '',
  });

  final String id;
  final String reference;
  final String summary;
  final DisciplineCaseStatus status;
  final DisciplineSeverity severity;
  final DisciplineCategory category;
  final DateTime openedOn;
  final String narrative;
  final DateTime incidentOn;
  final String incidentVenue;
  final String sessionLabel;
  final String reportedBy;
  final DateTime reportedOn;
  final List<DisciplineEvidence> evidence;
  final DisciplineFinding? finding;
  final DateTime? decidedOn;
  final String? decisionReason;
  final DisciplineHearing? hearing;
  final DisciplineSanction? sanction;
  final DateTime? appealWindowClosesOn;
  final DisciplineAppeal? appeal;

  /// Extra line shown on the list card under the meta row.
  final String listDetail;

  /// Minimum characters for grounds of appeal (design form rule).
  static const int appealGroundsMinLength = 50;

  bool get hasAppealLodged => appeal != null;

  /// Whether an appeal may still be lodged at [asOf] (portal clock).
  bool canAppealAt(DateTime asOf) {
    if (status != DisciplineCaseStatus.decided) return false;
    if (hasAppealLodged) return false;
    if (finding != DisciplineFinding.foundLiable) return false;
    final closes = appealWindowClosesOn;
    if (closes == null) return false;
    return !asOf.isAfter(closes);
  }

  /// Whether the appeal window has ended at [asOf] without an appeal lodged.
  bool appealWindowClosedAt(DateTime asOf) {
    if (status != DisciplineCaseStatus.decided) return false;
    if (hasAppealLodged) return false;
    final closes = appealWindowClosesOn;
    if (closes == null) return false;
    return asOf.isAfter(closes);
  }

  DisciplineCase copyWith({
    DisciplineCaseStatus? status,
    DisciplineAppeal? appeal,
    DateTime? appealWindowClosesOn,
    bool clearAppealWindow = false,
  }) {
    return DisciplineCase(
      id: id,
      reference: reference,
      summary: summary,
      status: status ?? this.status,
      severity: severity,
      category: category,
      openedOn: openedOn,
      narrative: narrative,
      incidentOn: incidentOn,
      incidentVenue: incidentVenue,
      sessionLabel: sessionLabel,
      reportedBy: reportedBy,
      reportedOn: reportedOn,
      evidence: evidence,
      finding: finding,
      decidedOn: decidedOn,
      decisionReason: decisionReason,
      hearing: hearing,
      sanction: sanction,
      appealWindowClosesOn: clearAppealWindow
          ? null
          : (appealWindowClosesOn ?? this.appealWindowClosesOn),
      appeal: appeal ?? this.appeal,
      listDetail: listDetail,
    );
  }

  @override
  List<Object?> get props => [
    id,
    reference,
    summary,
    status,
    severity,
    category,
    openedOn,
    narrative,
    incidentOn,
    incidentVenue,
    sessionLabel,
    reportedBy,
    reportedOn,
    evidence,
    finding,
    decidedOn,
    decisionReason,
    hearing,
    sanction,
    appealWindowClosesOn,
    appeal,
    listDetail,
  ];
}

/// Discipline module slice for one portal visit.
class DisciplineRecord extends Equatable {
  const DisciplineRecord({
    required this.standing,
    required this.cases,
    required this.sanctions,
    required this.asOf,
    this.appealDraft = '',
  });

  final StudentStanding standing;
  final List<DisciplineCase> cases;
  final List<DisciplineSanction> sanctions;

  /// Portal clock used for appeal-window checks (fixtures pin this).
  final DateTime asOf;
  final String appealDraft;

  bool get isEmpty => cases.isEmpty && sanctions.isEmpty;

  int get activeSanctionCount =>
      sanctions.where((s) => s.lifecycle == SanctionLifecycle.active).length;

  DisciplineCase? caseById(String id) {
    for (final item in cases) {
      if (item.id == id) return item;
    }
    return null;
  }

  bool canAppeal(DisciplineCase item) => item.canAppealAt(asOf);

  bool appealWindowClosed(DisciplineCase item) =>
      item.appealWindowClosedAt(asOf);

  DisciplineRecord copyWith({
    StudentStanding? standing,
    List<DisciplineCase>? cases,
    List<DisciplineSanction>? sanctions,
    DateTime? asOf,
    String? appealDraft,
  }) {
    return DisciplineRecord(
      standing: standing ?? this.standing,
      cases: cases ?? this.cases,
      sanctions: sanctions ?? this.sanctions,
      asOf: asOf ?? this.asOf,
      appealDraft: appealDraft ?? this.appealDraft,
    );
  }

  @override
  List<Object?> get props => [standing, cases, sanctions, asOf, appealDraft];
}
