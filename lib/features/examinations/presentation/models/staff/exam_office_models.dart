import '../examinations_models.dart';

// ------------------------------------------------------------------ grading

/// One band of a grading scale: a mark at or above [from] earns [letter].
class GradeBand {
  const GradeBand({
    required this.letter,
    required this.from,
    required this.points,
    this.isPass = true,
  });

  final String letter;
  final int from;
  final double points;
  final bool isPass;
}

/// A grading scale: the letters marks fall into and what each is worth.
class GradingScale {
  const GradingScale({
    required this.id,
    required this.name,
    required this.bands,
    required this.appliesTo,
    this.isDefault = false,
    this.maxPoint = 5,
    this.degreeClasses = const [],
  });

  final String id;
  final String name;

  /// Bands from the highest mark down.
  final List<GradeBand> bands;
  final String appliesTo;
  final bool isDefault;
  final double maxPoint;
  final List<ClassificationBand> degreeClasses;

  /// The band a [mark] takes: the highest it reaches, or `null` when it falls
  /// under every band.
  GradeBand? bandFor(int mark) {
    for (final band in bands) {
      if (mark >= band.from) return band;
    }
    return null;
  }

  /// The mark the lowest band starts at.
  int get lowestStart =>
      bands.isEmpty ? 0 : bands.map((band) => band.from).reduce(_min);

  /// `true` when marks near the bottom have no grade.
  bool get hasGap => lowestStart > 0;

  /// Marks from 0 to this one have no grade.
  int get unmappedTop => lowestStart - 1;

  /// How many marks have no grade.
  int get unmappedCount => lowestStart;

  static int _min(int a, int b) => a < b ? a : b;
}

// ------------------------------------------------------------------ results

/// Where a course's marks are in the approval chain.
enum ResultsStage { beingMarked, sentBack, withApprovers, published }

/// Which students the marking sheet lists.
enum MarkFilter { all, unmarked, heldBack, marked }

/// One student's marks on one course.
class StudentMark {
  const StudentMark({
    required this.matric,
    required this.name,
    this.coursework,
    this.exam,
    this.holdReason,
    this.isFlagged = false,
    this.previousTotal,
  });

  final String matric;
  final String name;
  final int? coursework;
  final int? exam;

  /// Why the mark is held back; `null` when it is not.
  final String? holdReason;

  /// The head of department flagged this mark when sending the batch back.
  final bool isFlagged;

  /// The total before the head of department's revision.
  final int? previousTotal;

  bool get isHeld => holdReason != null;

  int? get total =>
      coursework != null && exam != null ? coursework! + exam! : null;

  /// No mark, or only half of one, and not held back.
  bool get isUnmarked => !isHeld && total == null;

  bool get isMarked => !isHeld && total != null;

  StudentMark copyWith({
    int? coursework,
    int? exam,
    bool clearCoursework = false,
    bool clearExam = false,
    String? holdReason,
    bool clearHold = false,
  }) {
    return StudentMark(
      matric: matric,
      name: name,
      coursework: clearCoursework ? null : coursework ?? this.coursework,
      exam: clearExam ? null : exam ?? this.exam,
      holdReason: clearHold ? null : holdReason ?? this.holdReason,
      isFlagged: isFlagged,
      previousTotal: previousTotal,
    );
  }
}

/// The head of department's note on a batch sent back for revision.
class HodNote {
  const HodNote({
    required this.author,
    required this.sentOn,
    required this.note,
  });

  final String author;
  final DateTime sentOn;
  final String note;
}

/// One course's marks, from the first mark entered to publication.
class MarkingBatch {
  const MarkingBatch({
    required this.id,
    required this.courseCode,
    required this.title,
    required this.units,
    required this.termLabel,
    required this.stage,
    required this.entries,
    this.hodNote,
    this.approvalDesk,
    this.approvalDue,
    this.publishedOn,
    this.gazetteRef,
  });

  /// The batch reference, e.g. `RB-2026-00412`.
  final String id;
  final String courseCode;
  final String title;
  final int units;
  final String termLabel;
  final ResultsStage stage;
  final List<StudentMark> entries;
  final HodNote? hodNote;
  final String? approvalDesk;
  final DateTime? approvalDue;
  final DateTime? publishedOn;
  final String? gazetteRef;

  /// What the coursework part is marked out of.
  static const int maxCoursework = 30;

  /// What the final examination is marked out of.
  static const int maxExam = 70;

  bool get isEditable =>
      stage == ResultsStage.beingMarked || stage == ResultsStage.sentBack;

  int get enrolled => entries.length;
  int get markedCount => entries.where((entry) => entry.isMarked).length;
  int get unmarkedCount => entries.where((entry) => entry.isUnmarked).length;
  int get heldCount => entries.where((entry) => entry.isHeld).length;
  int get flaggedCount => entries.where((entry) => entry.isFlagged).length;

  List<StudentMark> get unmarkedEntries => [
    for (final entry in entries)
      if (entry.isUnmarked) entry,
  ];

  /// The marking sheet's rows under [filter].
  List<StudentMark> visible(MarkFilter filter) {
    return [
      for (final entry in entries)
        if (switch (filter) {
          MarkFilter.all => true,
          MarkFilter.unmarked => entry.isUnmarked,
          MarkFilter.heldBack => entry.isHeld,
          MarkFilter.marked => entry.isMarked,
        })
          entry,
    ];
  }

  MarkingBatch copyWith({ResultsStage? stage, List<StudentMark>? entries}) {
    return MarkingBatch(
      id: id,
      courseCode: courseCode,
      title: title,
      units: units,
      termLabel: termLabel,
      stage: stage ?? this.stage,
      entries: entries ?? this.entries,
      hodNote: hodNote,
      approvalDesk: approvalDesk,
      approvalDue: approvalDue,
      publishedOn: publishedOn,
      gazetteRef: gazetteRef,
    );
  }
}

// ----------------------------------------------------------------- sessions

/// Where an examination session is in its life.
enum SessionStatus { scheduled, live, closed }

/// Where one paper is: not sat, being sat, sat, or called off.
enum PaperStatus { scheduled, inProgress, sat, cancelled }

/// How much of a paper's roll has a seat.
enum SeatingStatus { notSeated, partial, seated }

/// A room a paper's candidates sit in.
class PaperRoom {
  const PaperRoom({required this.name, required this.seated});

  final String name;
  final int seated;
}

/// A room the office could add to a paper that is short of seats.
class OverflowRoom {
  const OverflowRoom({required this.name, required this.capacity});

  final String name;
  final int capacity;
}

/// One timetabled paper.
class ExamPaper {
  const ExamPaper({
    required this.id,
    required this.courseCode,
    required this.title,
    required this.startsAt,
    required this.minutes,
    required this.enrolled,
    this.rooms = const [],
    this.status = PaperStatus.scheduled,
    this.cancelReason,
  });

  final String id;
  final String courseCode;
  final String title;
  final DateTime startsAt;
  final int minutes;
  final int enrolled;
  final List<PaperRoom> rooms;
  final PaperStatus status;
  final String? cancelReason;

  int get seated => rooms.fold(0, (total, room) => total + room.seated);
  int get unseated => enrolled - seated;

  SeatingStatus get seating {
    if (seated == 0) return SeatingStatus.notSeated;
    return seated < enrolled ? SeatingStatus.partial : SeatingStatus.seated;
  }

  DateTime get endsAt => startsAt.add(Duration(minutes: minutes));

  /// A paper that has been sat cannot be called off.
  bool get isCancellable => status != PaperStatus.sat;

  ExamPaper copyWith({
    List<PaperRoom>? rooms,
    PaperStatus? status,
    String? cancelReason,
  }) {
    return ExamPaper(
      id: id,
      courseCode: courseCode,
      title: title,
      startsAt: startsAt,
      minutes: minutes,
      enrolled: enrolled,
      rooms: rooms ?? this.rooms,
      status: status ?? this.status,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }
}

/// A student who has two papers at the same time.
class ExamClash {
  const ExamClash({
    required this.matric,
    required this.firstCourse,
    required this.secondCourse,
  });

  final String matric;
  final String firstCourse;
  final String secondCourse;
}

/// An examination card issued in a session, and whether it is still good.
class IssuedCard {
  const IssuedCard({
    required this.matric,
    required this.name,
    required this.cardNumber,
    required this.checkCode,
    this.withdrawnReason,
  });

  final String matric;
  final String name;
  final String cardNumber;
  final String checkCode;
  final String? withdrawnReason;

  bool get isWithdrawn => withdrawnReason != null;

  IssuedCard withdrawn(String reason) {
    return IssuedCard(
      matric: matric,
      name: name,
      cardNumber: cardNumber,
      checkCode: checkCode,
      withdrawnReason: reason,
    );
  }
}

/// An examination period inside a semester, with its papers under it.
class ExamSession {
  const ExamSession({
    required this.id,
    required this.name,
    required this.termLabel,
    required this.startsOn,
    required this.endsOn,
    required this.cardsOpenOn,
    required this.status,
    this.papers = const [],
    this.clashes = const [],
    this.issuedCards = const [],
  });

  final String id;
  final String name;
  final String termLabel;
  final DateTime startsOn;
  final DateTime endsOn;
  final DateTime cardsOpenOn;
  final SessionStatus status;
  final List<ExamPaper> papers;
  final List<ExamClash> clashes;
  final List<IssuedCard> issuedCards;

  ExamPaper? paperById(String paperId) {
    for (final paper in papers) {
      if (paper.id == paperId) return paper;
    }
    return null;
  }

  ExamPaper? paperForCourse(String courseCode) {
    for (final paper in papers) {
      if (paper.courseCode == courseCode) return paper;
    }
    return null;
  }

  ExamSession copyWith({
    List<ExamPaper>? papers,
    List<IssuedCard>? issuedCards,
  }) {
    return ExamSession(
      id: id,
      name: name,
      termLabel: termLabel,
      startsOn: startsOn,
      endsOn: endsOn,
      cardsOpenOn: cardsOpenOn,
      status: status,
      papers: papers ?? this.papers,
      clashes: clashes,
      issuedCards: issuedCards ?? this.issuedCards,
    );
  }
}

/// What is wrong with a session form.
enum SessionDraftError {
  nameRequired,
  datesRequired,
  endBeforeStart,
  cardsAfterStart,
}

/// The open-a-session form, before it is saved.
class SessionDraft {
  const SessionDraft({
    required this.name,
    required this.termLabel,
    this.startsOn,
    this.endsOn,
    this.cardsOpenOn,
  });

  final String name;
  final String termLabel;
  final DateTime? startsOn;
  final DateTime? endsOn;
  final DateTime? cardsOpenOn;

  Set<SessionDraftError> validate() {
    final start = startsOn;
    final end = endsOn;
    final cards = cardsOpenOn;
    return {
      if (name.trim().isEmpty) SessionDraftError.nameRequired,
      if (start == null || end == null || cards == null)
        SessionDraftError.datesRequired,
      if (start != null && end != null && !end.isAfter(start))
        SessionDraftError.endBeforeStart,
      if (start != null && cards != null && cards.isAfter(start))
        SessionDraftError.cardsAfterStart,
    };
  }
}

// ---------------------------------------------------------------- incidents

/// What kind of incident a hall reported.
enum IncidentKind { malpractice, absence, illness, disruption, other }

/// Where an incident is in being settled.
enum IncidentStatus { reported, underReview, referred, closed }

/// One incident reported from an examination hall.
class ExamIncident {
  const ExamIncident({
    required this.id,
    required this.kind,
    required this.status,
    required this.courseCode,
    required this.sittingAt,
    required this.hall,
    required this.description,
    this.matric,
    this.holdsMark = false,
    this.disciplineRef,
    this.hearingOn,
  });

  final String id;
  final IncidentKind kind;
  final IncidentStatus status;
  final String courseCode;
  final DateTime sittingAt;
  final String hall;
  final String description;

  /// `null` for an incident filed against the paper only.
  final String? matric;

  /// The incident is holding the student's mark for [courseCode] back.
  final bool holdsMark;
  final String? disciplineRef;
  final DateTime? hearingOn;

  bool get isOpen => status != IncidentStatus.closed;

  ExamIncident copyWith({
    IncidentStatus? status,
    bool? holdsMark,
    String? disciplineRef,
    DateTime? hearingOn,
  }) {
    return ExamIncident(
      id: id,
      kind: kind,
      status: status ?? this.status,
      courseCode: courseCode,
      sittingAt: sittingAt,
      hall: hall,
      description: description,
      matric: matric,
      holdsMark: holdsMark ?? this.holdsMark,
      disciplineRef: disciplineRef ?? this.disciplineRef,
      hearingOn: hearingOn ?? this.hearingOn,
    );
  }
}

/// One line of an incident batch, as the invigilator's file gave it.
class ImportRow {
  const ImportRow({
    required this.courseCode,
    required this.subject,
    required this.kindText,
    required this.time,
    required this.description,
  });

  final String courseCode;

  /// A matric number, a name, or nothing.
  final String subject;
  final String kindText;
  final String time;
  final String description;
}

/// What the import would do with a row.
enum ImportAction { importIt, importUnattached, leave }

/// Why the import would do it.
enum ImportReason {
  ready,
  missingDescription,
  unknownKind,
  duplicateInBatch,
  alreadyImported,
  noMatchingPaper,
  noStudentNamed,
  studentNotFound,
}

/// A row and what a dry run says about it.
class ImportRowReport {
  const ImportRowReport({
    required this.row,
    required this.action,
    required this.reason,
    this.kind,
  });

  final ImportRow row;
  final ImportAction action;
  final ImportReason reason;
  final IncidentKind? kind;
}

/// The incident batch's progress: nothing run, dry-run shown, or imported.
enum ImportStatus { idle, dryRun, imported }

final RegExp _matricPattern = RegExp(r'^\d{2}/[A-Z]{2,4}/\d{4}$');

/// The kind [text] names, or `null` when it names none.
IncidentKind? incidentKindFromText(String text) {
  final wanted = text.trim().toLowerCase();
  for (final kind in IncidentKind.values) {
    if (kind.name == wanted) return kind;
  }
  return null;
}

/// Works out what importing [rows] would do, writing nothing.
///
/// A row is left alone when it is not a report of anything (no description,
/// an unknown kind), repeats an earlier row, was imported before, or names a
/// paper nobody sat. A row with no student, or one the roll does not know, is
/// imported unattached for somebody to attach.
List<ImportRowReport> dryRunIncidentImport({
  required List<ImportRow> rows,
  required List<ExamIncident> existing,
  required Set<String> paperCourseCodes,
  required Set<String> knownMatrics,
}) {
  final seen = <String>{};
  final reports = <ImportRowReport>[];

  for (final row in rows) {
    final kind = incidentKindFromText(row.kindText);
    final subject = row.subject.trim();
    final key = '${row.courseCode}|$subject|${kind?.name}';

    ImportRowReport leave(ImportReason reason) => ImportRowReport(
      row: row,
      action: ImportAction.leave,
      reason: reason,
      kind: kind,
    );

    if (row.description.trim().isEmpty) {
      reports.add(leave(ImportReason.missingDescription));
    } else if (kind == null) {
      reports.add(leave(ImportReason.unknownKind));
    } else if (!paperCourseCodes.contains(row.courseCode)) {
      reports.add(leave(ImportReason.noMatchingPaper));
    } else if (!seen.add(key)) {
      reports.add(leave(ImportReason.duplicateInBatch));
    } else if (existing.any(
      (incident) =>
          incident.courseCode == row.courseCode &&
          incident.matric == subject &&
          incident.kind == kind,
    )) {
      reports.add(leave(ImportReason.alreadyImported));
    } else if (subject.isEmpty) {
      reports.add(
        ImportRowReport(
          row: row,
          action: ImportAction.importUnattached,
          reason: ImportReason.noStudentNamed,
          kind: kind,
        ),
      );
    } else if (!_matricPattern.hasMatch(subject) ||
        !knownMatrics.contains(subject)) {
      reports.add(
        ImportRowReport(
          row: row,
          action: ImportAction.importUnattached,
          reason: ImportReason.studentNotFound,
          kind: kind,
        ),
      );
    } else {
      reports.add(
        ImportRowReport(
          row: row,
          action: ImportAction.importIt,
          reason: ImportReason.ready,
          kind: kind,
        ),
      );
    }
  }
  return reports;
}

// -------------------------------------------------------------------- resits

/// A student's resit registration, as the office sees it.
class ResitSignup {
  const ResitSignup({
    required this.id,
    required this.courseCode,
    required this.matric,
    required this.title,
    required this.units,
    required this.feeMinorUnits,
    this.isAwaitingPayment = true,
  });

  final String id;
  final String courseCode;
  final String matric;
  final String title;
  final int units;
  final int feeMinorUnits;
  final bool isAwaitingPayment;
}

/// One resit window.
class ResitWindow {
  const ResitWindow({
    required this.id,
    required this.name,
    required this.opensOn,
    required this.closesOn,
    required this.feePerUnitMinorUnits,
    required this.isOpen,
    required this.registeredCount,
    this.unitCap,
    this.signups = const [],
  });

  final String id;
  final String name;
  final DateTime opensOn;
  final DateTime closesOn;
  final int feePerUnitMinorUnits;
  final bool isOpen;
  final int registeredCount;

  /// `null` for no cap.
  final int? unitCap;
  final List<ResitSignup> signups;

  ResitWindow copyWith({int? registeredCount, List<ResitSignup>? signups}) {
    return ResitWindow(
      id: id,
      name: name,
      opensOn: opensOn,
      closesOn: closesOn,
      feePerUnitMinorUnits: feePerUnitMinorUnits,
      isOpen: isOpen,
      registeredCount: registeredCount ?? this.registeredCount,
      unitCap: unitCap,
      signups: signups ?? this.signups,
    );
  }
}

/// What is wrong with the open-a-window form.
enum ResitDraftError {
  nameRequired,
  datesRequired,
  closeBeforeOpen,
  feeInvalid,
}

/// The open-a-window form, before it is saved.
class ResitWindowDraft {
  const ResitWindowDraft({
    required this.name,
    this.opensOn,
    this.closesOn,
    this.feePerUnitMinorUnits,
    this.unitCap,
  });

  final String name;
  final DateTime? opensOn;
  final DateTime? closesOn;

  /// `null` when what was typed is not an amount.
  final int? feePerUnitMinorUnits;

  /// `null` for no cap.
  final int? unitCap;

  Set<ResitDraftError> validate() {
    final opens = opensOn;
    final closes = closesOn;
    final fee = feePerUnitMinorUnits;
    return {
      if (name.trim().isEmpty) ResitDraftError.nameRequired,
      if (opens == null || closes == null) ResitDraftError.datesRequired,
      if (opens != null && closes != null && !closes.isAfter(opens))
        ResitDraftError.closeBeforeOpen,
      if (fee == null || fee < 0) ResitDraftError.feeInvalid,
    };
  }
}

// --------------------------------------------------------------- broadsheet

/// What a mark means on the broadsheet.
enum ScoreVerdict { cleared, heldBack, notAPass, marginal }

/// One student's line on a course broadsheet.
class BroadsheetRow {
  const BroadsheetRow({
    required this.matric,
    required this.name,
    required this.units,
    required this.verdict,
    this.score,
    this.grade,
    this.hasDossier = false,
  });

  final String matric;
  final String name;
  final int units;
  final ScoreVerdict verdict;
  final int? score;
  final String? grade;
  final bool hasDossier;
}

/// A course's published results, student by student.
class CourseBroadsheet {
  const CourseBroadsheet({
    required this.courseCode,
    required this.enrolled,
    required this.mean,
    required this.passed,
    required this.rows,
  });

  final String courseCode;
  final int enrolled;
  final double mean;
  final int passed;
  final List<BroadsheetRow> rows;

  double get passRate => enrolled == 0 ? 0 : passed / enrolled * 100;

  int get failingCount =>
      rows.where((row) => row.verdict == ScoreVerdict.notAPass).length;
}

/// One course on a student's semester dossier.
class DossierCourse {
  const DossierCourse({
    required this.code,
    required this.title,
    required this.units,
    required this.verdict,
    this.score,
    this.points,
    this.grade,
    this.incidentId,
  });

  final String code;
  final String title;
  final int units;
  final ScoreVerdict verdict;
  final int? score;
  final double? points;
  final String? grade;
  final String? incidentId;
}

/// A student's semester at a glance, for the registry.
class StudentDossier {
  const StudentDossier({
    required this.matric,
    required this.name,
    required this.programme,
    required this.termLabel,
    required this.cgpa,
    required this.standing,
    required this.classification,
    required this.unitsTaken,
    required this.unitsPassed,
    required this.courses,
  });

  final String matric;
  final String name;
  final String programme;
  final String termLabel;
  final double cgpa;
  final StandingKind standing;
  final String classification;
  final int unitsTaken;
  final int unitsPassed;
  final List<DossierCourse> courses;

  /// The course whose result is still provisional, if any.
  DossierCourse? get provisionalCourse {
    for (final course in courses) {
      if (course.verdict == ScoreVerdict.heldBack) return course;
    }
    return null;
  }
}

// ------------------------------------------------------------------- ledger

/// Everything the examinations office screens draw, in one snapshot.
class ExamOfficeLedger {
  const ExamOfficeLedger({
    required this.officerName,
    required this.termLabels,
    required this.batches,
    required this.sessions,
    required this.scales,
    required this.probationCgpa,
    required this.withdrawalCgpa,
    required this.overflowRooms,
    required this.incidents,
    required this.importRows,
    required this.windows,
    required this.broadsheets,
    required this.dossiers,
  });

  final String officerName;

  /// The semesters the sessions list can show, newest first.
  final List<String> termLabels;
  final List<MarkingBatch> batches;
  final List<ExamSession> sessions;
  final List<GradingScale> scales;
  final double probationCgpa;
  final double withdrawalCgpa;
  final List<OverflowRoom> overflowRooms;
  final List<ExamIncident> incidents;
  final List<ImportRow> importRows;
  final List<ResitWindow> windows;
  final List<CourseBroadsheet> broadsheets;
  final List<StudentDossier> dossiers;
}
