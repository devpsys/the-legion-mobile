import 'package:equatable/equatable.dart';

/// Scenarios the debug preview menu can load, one fixture ledger each.
enum ExaminationsPreviewScenario {
  publishedGood,
  unpublished,
  probation,
  cardNotIssued,
  cardIssued,
  cardRevoked,
  resitsOpen,
  resitsClosed,
}

/// The student the examinations screens are about.
class ExamStudent extends Equatable {
  const ExamStudent({
    required this.name,
    required this.matricNumber,
    required this.programme,
    required this.level,
    required this.department,
  });

  final String name;
  final String matricNumber;
  final String programme;
  final int level;
  final String department;

  /// Up to two initials, for the monogram on the results dossier.
  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2);
    return parts.map((part) => part[0].toUpperCase()).join();
  }

  @override
  List<Object?> get props => [name, matricNumber, programme, level, department];
}

// ---------------------------------------------------------------- results

/// Whether the registry has published any results for the student.
enum ResultsStatus { unpublished, published }

/// Where a CGPA puts a student against the senate's thresholds.
enum StandingKind { good, probation, withdrawalRisk }

/// An earlier attempt at a course the student has since taken again.
class ResitAnnotation extends Equatable {
  const ResitAnnotation({
    required this.previousScore,
    required this.previousTermLabel,
  });

  final int previousScore;
  final String previousTermLabel;

  @override
  List<Object?> get props => [previousScore, previousTermLabel];
}

/// One course line of a published term.
class CourseResult extends Equatable {
  const CourseResult({
    required this.code,
    required this.title,
    required this.units,
    this.score,
    this.grade,
    this.resit,
    this.isHeldBack = false,
  });

  final String code;
  final String title;
  final int units;

  /// The mark out of 100; `null` while it is held back or not yet marked.
  final int? score;
  final String? grade;
  final ResitAnnotation? resit;

  /// The examinations office is holding this mark back.
  final bool isHeldBack;

  bool get isMarked => score != null && !isHeldBack;

  @override
  List<Object?> get props => [
    code,
    title,
    units,
    score,
    grade,
    resit,
    isHeldBack,
  ];
}

/// A semester whose results the registry has published.
class TermResult extends Equatable {
  const TermResult({
    required this.label,
    required this.levelLabel,
    required this.gpa,
    required this.unitsTaken,
    required this.unitsPassed,
    required this.courses,
  });

  /// `25/26 • 2nd Sem`.
  final String label;
  final String levelLabel;
  final double gpa;
  final int unitsTaken;
  final int unitsPassed;
  final List<CourseResult> courses;

  @override
  List<Object?> get props => [
    label,
    levelLabel,
    gpa,
    unitsTaken,
    unitsPassed,
    courses,
  ];
}

/// One rung of the degree classification scale.
class ClassificationBand extends Equatable {
  const ClassificationBand({
    required this.name,
    required this.from,
    required this.to,
  });

  final String name;
  final double from;
  final double to;

  bool contains(double cgpa) => cgpa >= from && cgpa <= to;

  @override
  List<Object?> get props => [name, from, to];
}

/// The student's level adviser, named when standing needs a conversation.
class LevelAdviser extends Equatable {
  const LevelAdviser({required this.name, required this.office});

  final String name;
  final String office;

  @override
  List<Object?> get props => [name, office];
}

/// The student's published results and where they stand overall.
class ResultsRecord extends Equatable {
  const ResultsRecord({
    required this.status,
    required this.sessionLabel,
    this.cgpa = 0,
    this.standing = StandingKind.good,
    this.terms = const [],
    this.scale = const [],
    this.unitsPassed = 0,
    this.unitsTaken = 0,
    this.adviser,
  });

  final ResultsStatus status;

  /// The first semester label, e.g. `2025/2026`, for the empty state.
  final String sessionLabel;
  final double cgpa;
  final StandingKind standing;
  final List<TermResult> terms;
  final List<ClassificationBand> scale;
  final int unitsPassed;
  final int unitsTaken;
  final LevelAdviser? adviser;

  /// CGPA a student needs to stay out of probation.
  static const double probationCgpa = 2.4;

  /// CGPA under which a student is advised to withdraw.
  static const double withdrawalCgpa = 1.5;

  /// Highest CGPA on the scale.
  static const double maxCgpa = 5;

  /// The classification the CGPA currently earns, if the scale covers it.
  ClassificationBand? get classification {
    for (final band in scale) {
      if (band.contains(cgpa)) return band;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    status,
    sessionLabel,
    cgpa,
    standing,
    terms,
    scale,
    unitsPassed,
    unitsTaken,
    adviser,
  ];
}

// ------------------------------------------------------------------- card

/// Whether the student holds an examination card.
enum CardStatus { notIssued, issued, revoked }

/// The five clearances a card needs.
enum ClearanceGateId { fees, standing, papers, schedule, seats }

/// Where a clearance stands.
enum GateState { passed, blocked, waiting }

/// Why a card was withdrawn.
enum CardRevokedReason { feeReversed }

/// One clearance gate and where it stands.
class ClearanceGate extends Equatable {
  const ClearanceGate({required this.id, required this.state});

  final ClearanceGateId id;
  final GateState state;

  @override
  List<Object?> get props => [id, state];
}

/// One paper on the card's timetable.
class CardPaper extends Equatable {
  const CardPaper({
    required this.courseCode,
    required this.title,
    required this.startsAt,
    this.venue,
    this.seat,
  });

  final String courseCode;
  final String title;
  final DateTime startsAt;

  /// `null` until the office announces the hall.
  final String? venue;
  final int? seat;

  bool get isAnnounced => venue != null;

  @override
  List<Object?> get props => [courseCode, title, startsAt, venue, seat];
}

/// The student's examination card, in whichever state it is.
class ExaminationCard extends Equatable {
  const ExaminationCard({
    required this.status,
    required this.examinationName,
    required this.sessionLabel,
    this.cardNumber = '',
    this.checkCode = '',
    this.papers = const [],
    this.issuedOn,
    this.revokedReason,
    this.gates = const [],
    this.minimumToPayMinorUnits = 0,
    this.outstandingMinorUnits = 0,
  });

  final CardStatus status;

  /// `End of semester examinations`.
  final String examinationName;
  final String sessionLabel;
  final String cardNumber;
  final String checkCode;
  final List<CardPaper> papers;
  final DateTime? issuedOn;
  final CardRevokedReason? revokedReason;
  final List<ClearanceGate> gates;

  /// Fees the student must pay before a card is issued (kobo).
  final int minimumToPayMinorUnits;

  /// Everything the student still owes this term (kobo).
  final int outstandingMinorUnits;

  /// The first gate that is not passed, which the screen leads with.
  ClearanceGate? get blockingGate {
    for (final gate in gates) {
      if (gate.state != GateState.passed) return gate;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    status,
    examinationName,
    sessionLabel,
    cardNumber,
    checkCode,
    papers,
    issuedOn,
    revokedReason,
    gates,
    minimumToPayMinorUnits,
    outstandingMinorUnits,
  ];
}

// ------------------------------------------------------------------ resits

/// Whether the resit window accepts registrations.
enum ResitWindowStatus { open, closed }

/// Where a registered resit stands with the bursary.
enum ResitPaymentStatus { awaitingPayment, paid }

/// A course the student failed and has not since passed.
class ResitFailure extends Equatable {
  const ResitFailure({
    required this.code,
    required this.title,
    required this.units,
    required this.failedTermLabel,
    required this.failedScore,
  });

  final String code;
  final String title;
  final int units;
  final String failedTermLabel;
  final int failedScore;

  @override
  List<Object?> get props => [code, title, units, failedTermLabel, failedScore];
}

/// A resit the student has registered for.
class ResitRegistration extends Equatable {
  const ResitRegistration({
    required this.code,
    required this.title,
    required this.units,
    required this.termLabel,
    required this.feeMinorUnits,
    required this.invoiceReference,
    this.payment = ResitPaymentStatus.awaitingPayment,
  });

  final String code;
  final String title;
  final int units;
  final String termLabel;
  final int feeMinorUnits;
  final String invoiceReference;
  final ResitPaymentStatus payment;

  @override
  List<Object?> get props => [
    code,
    title,
    units,
    termLabel,
    feeMinorUnits,
    invoiceReference,
    payment,
  ];
}

/// The resit window, the student's failures and what they have registered.
class ResitsRecord extends Equatable {
  const ResitsRecord({
    required this.windowStatus,
    required this.windowLabel,
    required this.windowDate,
    required this.feePerUnitMinorUnits,
    required this.unitCap,
    this.failures = const [],
    this.registrations = const [],
  });

  final ResitWindowStatus windowStatus;

  /// `25/26 • 2nd Sem`.
  final String windowLabel;

  /// When the window closes (open) or closed (closed).
  final DateTime windowDate;
  final int feePerUnitMinorUnits;
  final int unitCap;
  final List<ResitFailure> failures;
  final List<ResitRegistration> registrations;

  bool get isOpen => windowStatus == ResitWindowStatus.open;

  int get unitsUsed =>
      registrations.fold(0, (total, entry) => total + entry.units);

  int get unitsLeft => unitCap - unitsUsed;

  int feeFor(ResitFailure failure) => failure.units * feePerUnitMinorUnits;

  /// Everything the student would owe if they resat every listed failure.
  int get estimatedObligationMinorUnits =>
      failures.fold(0, (total, entry) => total + feeFor(entry));

  bool canRegister(ResitFailure failure) =>
      isOpen && failure.units <= unitsLeft;

  ResitFailure? failureFor(String code) {
    for (final failure in failures) {
      if (failure.code == code) return failure;
    }
    return null;
  }

  ResitsRecord copyWith({
    List<ResitFailure>? failures,
    List<ResitRegistration>? registrations,
  }) {
    return ResitsRecord(
      windowStatus: windowStatus,
      windowLabel: windowLabel,
      windowDate: windowDate,
      feePerUnitMinorUnits: feePerUnitMinorUnits,
      unitCap: unitCap,
      failures: failures ?? this.failures,
      registrations: registrations ?? this.registrations,
    );
  }

  @override
  List<Object?> get props => [
    windowStatus,
    windowLabel,
    windowDate,
    feePerUnitMinorUnits,
    unitCap,
    failures,
    registrations,
  ];
}

// ------------------------------------------------------------------ ledger

/// Everything the student's examinations screens draw, in one snapshot.
class ExaminationsLedger extends Equatable {
  const ExaminationsLedger({
    required this.student,
    required this.sessionLabel,
    required this.results,
    required this.card,
    required this.resits,
  });

  final ExamStudent student;

  /// The session pill's label, e.g. `2025/2026 • 2nd Sem`.
  final String sessionLabel;
  final ResultsRecord results;
  final ExaminationCard card;
  final ResitsRecord resits;

  ExaminationsLedger copyWith({
    ResultsRecord? results,
    ExaminationCard? card,
    ResitsRecord? resits,
  }) {
    return ExaminationsLedger(
      student: student,
      sessionLabel: sessionLabel,
      results: results ?? this.results,
      card: card ?? this.card,
      resits: resits ?? this.resits,
    );
  }

  @override
  List<Object?> get props => [student, sessionLabel, results, card, resits];
}

// ------------------------------------------------------------ verification

/// Length of an examination card's check code.
const int examCardCodeLength = 12;

/// What the hall-door check reports.
enum ExamCardCheckStatus { idle, valid, withdrawn, standingBlocked, notFound }

/// The result of checking a code at the hall door.
///
/// A valid card carries five facts and never a photo.
class ExamCardCheckResult extends Equatable {
  const ExamCardCheckResult({
    required this.status,
    this.name = '',
    this.matricNumber = '',
    this.programme = '',
    this.cardNumber = '',
    this.sessionLabel = '',
    this.eligiblePapers = 0,
    this.withdrawnReason,
  });

  const ExamCardCheckResult.idle() : this(status: ExamCardCheckStatus.idle);

  final ExamCardCheckStatus status;
  final String name;
  final String matricNumber;
  final String programme;
  final String cardNumber;
  final String sessionLabel;
  final int eligiblePapers;
  final CardRevokedReason? withdrawnReason;

  @override
  List<Object?> get props => [
    status,
    name,
    matricNumber,
    programme,
    cardNumber,
    sessionLabel,
    eligiblePapers,
    withdrawnReason,
  ];
}
