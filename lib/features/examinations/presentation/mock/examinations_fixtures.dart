import '../models/examinations_models.dart';

/// Sample content for the student Examinations & Results screens.
///
/// Presentation-only placeholders: delete this file once the examinations
/// endpoints exist and feed the models from a repository. The default
/// [ledger] is Amaka Bello in good standing with one published term; the
/// other ledgers put each screen in each state the designs under
/// `ui-designs/examinations-results/` draw.
abstract final class ExaminationsFixtures {
  static const String sessionLabel = '2025/2026';

  /// App bar pill: the full session and the current semester.
  static const String appBarSessionLabel = '2025/2026 • 2nd Sem';

  /// Semester label used inside the page, shorter than [appBarSessionLabel].
  static const String currentTermLabel = '25/26 • 2nd Sem';
  static const String examinationName = 'End of semester examinations';

  static const ExamStudent student = ExamStudent(
    name: 'Amaka Bello',
    matricNumber: '25/CSC/0101',
    programme: 'B.Sc. Computer Science',
    level: 200,
    department: 'Computing',
  );

  static const List<ClassificationBand> classificationScale = [
    ClassificationBand(name: 'First Class Honours', from: 4.5, to: 5),
    ClassificationBand(name: 'Second Class Upper', from: 3.5, to: 4.49),
    ClassificationBand(name: 'Second Class Lower', from: 2.4, to: 3.49),
    ClassificationBand(name: 'Third Class', from: 1.5, to: 2.39),
  ];

  static const LevelAdviser adviser = LevelAdviser(
    name: 'Dr. Ibrahim Sani',
    office: 'Rm 204 FNAS',
  );

  // ----------------------------------------------------------- results

  /// Amaka's published second semester: one resit, one held-back mark and one
  /// course not marked yet.
  static const TermResult goodStandingTerm = TermResult(
    label: currentTermLabel,
    levelLabel: '200 level',
    gpa: 3.88,
    unitsTaken: 15,
    unitsPassed: 12,
    courses: [
      CourseResult(
        code: 'CSC 301',
        title: 'Structured Programming',
        units: 3,
        score: 74,
        grade: 'A',
      ),
      CourseResult(
        code: 'CSC 307',
        title: 'Human-Computer Interaction',
        units: 3,
        score: 68,
        grade: 'B',
      ),
      CourseResult(
        code: 'CSC 201',
        title: 'Computer Programming I',
        units: 3,
        score: 61,
        grade: 'B',
        resit: ResitAnnotation(
          previousScore: 22,
          previousTermLabel: '25/26 • 1st Sem',
        ),
      ),
      CourseResult(
        code: 'CSC 305',
        title: 'Database Systems',
        units: 3,
        isHeldBack: true,
      ),
      CourseResult(code: 'CSC 311', title: 'Operating Systems I', units: 3),
    ],
  );

  static const ResultsRecord goodStandingResults = ResultsRecord(
    status: ResultsStatus.published,
    sessionLabel: '2025/2026',
    cgpa: 3.62,
    standing: StandingKind.good,
    terms: [goodStandingTerm],
    scale: classificationScale,
    unitsTaken: 15,
    unitsPassed: 12,
  );

  static const TermResult probationTerm = TermResult(
    label: '2024/2025-1',
    levelLabel: '100 level',
    gpa: 1.84,
    unitsTaken: 8,
    unitsPassed: 5,
    courses: [
      CourseResult(
        code: 'CSC 201',
        title: 'Computer Programming II',
        units: 3,
        score: 38,
        grade: 'F',
      ),
      CourseResult(
        code: 'MTH 201',
        title: 'Mathematical Methods I',
        units: 3,
        score: 41,
        grade: 'E',
      ),
      CourseResult(
        code: 'GST 222',
        title: 'Peace Studies and Conflict',
        units: 2,
        score: 54,
        grade: 'C',
      ),
    ],
  );

  static const ResultsRecord probationResults = ResultsRecord(
    status: ResultsStatus.published,
    sessionLabel: '2024/2025',
    cgpa: 1.84,
    standing: StandingKind.probation,
    terms: [probationTerm],
    scale: classificationScale,
    unitsTaken: 18,
    unitsPassed: 8,
    adviser: adviser,
  );

  static const ResultsRecord unpublishedResults = ResultsRecord(
    status: ResultsStatus.unpublished,
    sessionLabel: '2025/2026',
  );

  // -------------------------------------------------------------- card

  static const List<ClearanceGate> blockedGates = [
    ClearanceGate(id: ClearanceGateId.fees, state: GateState.blocked),
    ClearanceGate(id: ClearanceGateId.standing, state: GateState.passed),
    ClearanceGate(id: ClearanceGateId.papers, state: GateState.passed),
    ClearanceGate(id: ClearanceGateId.schedule, state: GateState.passed),
    ClearanceGate(id: ClearanceGateId.seats, state: GateState.waiting),
  ];

  static const List<ClearanceGate> clearedGates = [
    ClearanceGate(id: ClearanceGateId.fees, state: GateState.passed),
    ClearanceGate(id: ClearanceGateId.standing, state: GateState.passed),
    ClearanceGate(id: ClearanceGateId.papers, state: GateState.passed),
    ClearanceGate(id: ClearanceGateId.schedule, state: GateState.passed),
    ClearanceGate(id: ClearanceGateId.seats, state: GateState.passed),
  ];

  static const String cardNumber = 'EC2026-000123';

  /// Check code the public hall-door check reads as valid.
  static const String validCheckCode = 'K7Q2M4XB9PTR';

  /// Check code of the withdrawn card.
  static const String withdrawnCheckCode = 'R3V0K3D7HQ5N';

  /// Check code of a card whose holder is no longer in good standing.
  static const String standingCheckCode = 'S7ND1NGBL0CK';

  static final List<CardPaper> papers = [
    CardPaper(
      courseCode: 'MTH 201',
      title: 'Linear Algebra II',
      startsAt: DateTime(2026, 12, 8, 14),
      venue: 'Block B, Room 12',
      seat: 3,
    ),
    CardPaper(
      courseCode: 'CSC 301',
      title: 'Structured Programming',
      startsAt: DateTime(2026, 12, 9, 9),
      venue: 'Main Hall, Hall A',
      seat: 47,
    ),
    CardPaper(
      courseCode: 'CSC 305',
      title: 'Database Systems',
      startsAt: DateTime(2026, 12, 10, 9),
      venue: 'Block B, Room 12',
      seat: 8,
    ),
    CardPaper(
      courseCode: 'PHY 201',
      title: 'General Physics III',
      startsAt: DateTime(2026, 12, 11, 9),
    ),
    CardPaper(
      courseCode: 'CSC 307',
      title: 'Human-Computer Interaction',
      startsAt: DateTime(2026, 12, 12, 9),
      venue: 'Main Hall, Hall A',
      seat: 112,
    ),
  ];

  static const ExaminationCard notIssuedCard = ExaminationCard(
    status: CardStatus.notIssued,
    examinationName: examinationName,
    sessionLabel: sessionLabel,
    gates: blockedGates,
    minimumToPayMinorUnits: 2400000,
    outstandingMinorUnits: 5850000,
  );

  static final ExaminationCard issuedCard = ExaminationCard(
    status: CardStatus.issued,
    examinationName: examinationName,
    sessionLabel: sessionLabel,
    cardNumber: cardNumber,
    checkCode: validCheckCode,
    papers: papers,
    issuedOn: DateTime(2026, 12, 1),
    gates: clearedGates,
  );

  static final ExaminationCard revokedCard = ExaminationCard(
    status: CardStatus.revoked,
    examinationName: examinationName,
    sessionLabel: sessionLabel,
    cardNumber: cardNumber,
    checkCode: withdrawnCheckCode,
    papers: papers,
    issuedOn: DateTime(2026, 12, 1),
    revokedReason: CardRevokedReason.feeReversed,
    gates: blockedGates,
    minimumToPayMinorUnits: 2400000,
    outstandingMinorUnits: 5850000,
  );

  // ------------------------------------------------------------ resits

  static const int resitFeePerUnitMinorUnits = 200000;
  static const int resitUnitCap = 6;

  static final DateTime resitWindowDate = DateTime(2027, 1, 23);

  static const List<ResitFailure> resitFailures = [
    ResitFailure(
      code: 'CSC 211',
      title: 'Introduction to Algorithms',
      units: 3,
      failedTermLabel: '25/26 • 1st Sem',
      failedScore: 22,
    ),
    ResitFailure(
      code: 'PHY 201',
      title: 'General Physics III',
      units: 3,
      failedTermLabel: '25/26 • 1st Sem',
      failedScore: 38,
    ),
  ];

  static const ResitRegistration registeredResit = ResitRegistration(
    code: 'MTH 203',
    title: 'Mathematical Analysis',
    units: 3,
    termLabel: '25/26 • 2nd Sem',
    feeMinorUnits: 600000,
    invoiceReference: 'RS-99214',
  );

  static final ResitsRecord openResits = ResitsRecord(
    windowStatus: ResitWindowStatus.open,
    windowLabel: currentTermLabel,
    windowDate: resitWindowDate,
    feePerUnitMinorUnits: resitFeePerUnitMinorUnits,
    unitCap: resitUnitCap,
    failures: resitFailures,
    registrations: const [registeredResit],
  );

  static final ResitsRecord closedResits = ResitsRecord(
    windowStatus: ResitWindowStatus.closed,
    windowLabel: currentTermLabel,
    windowDate: resitWindowDate,
    feePerUnitMinorUnits: resitFeePerUnitMinorUnits,
    unitCap: resitUnitCap,
    failures: resitFailures,
    registrations: const [registeredResit],
  );

  // ----------------------------------------------------------- ledgers

  /// Amaka in good standing, one published term, a held-back mark, a resit
  /// annotation, an open resit window and an issued card.
  static final ExaminationsLedger ledger = ExaminationsLedger(
    student: student,
    sessionLabel: appBarSessionLabel,
    results: goodStandingResults,
    card: issuedCard,
    resits: openResits,
  );

  static final ExaminationsLedger probationLedger = ledger.copyWith(
    results: probationResults,
  );

  static final ExaminationsLedger unpublishedLedger = ledger.copyWith(
    results: unpublishedResults,
  );

  static final ExaminationsLedger cardNotIssuedLedger = ledger.copyWith(
    card: notIssuedCard,
  );

  static final ExaminationsLedger cardIssuedLedger = ledger;

  static final ExaminationsLedger cardRevokedLedger = ledger.copyWith(
    card: revokedCard,
  );

  static final ExaminationsLedger resitsOpenLedger = ledger;

  static final ExaminationsLedger resitsClosedLedger = ledger.copyWith(
    resits: closedResits,
  );

  /// The ledger a preview [scenario] loads.
  static ExaminationsLedger ledgerFor(ExaminationsPreviewScenario scenario) {
    return switch (scenario) {
      ExaminationsPreviewScenario.publishedGood => ledger,
      ExaminationsPreviewScenario.unpublished => unpublishedLedger,
      ExaminationsPreviewScenario.probation => probationLedger,
      ExaminationsPreviewScenario.cardNotIssued => cardNotIssuedLedger,
      ExaminationsPreviewScenario.cardIssued => cardIssuedLedger,
      ExaminationsPreviewScenario.cardRevoked => cardRevokedLedger,
      ExaminationsPreviewScenario.resitsOpen => resitsOpenLedger,
      ExaminationsPreviewScenario.resitsClosed => resitsClosedLedger,
    };
  }

  // -------------------------------------------------------- verification

  /// Length of a check code.
  static const int checkCodeLength = examCardCodeLength;

  /// Looks [code] up the way the hall-door check does: a valid card, a
  /// withdrawn one, a holder who is no longer in good standing, or nothing.
  static ExamCardCheckResult verify(String code) {
    final normalised = code.trim().toUpperCase();
    return switch (normalised) {
      validCheckCode => const ExamCardCheckResult(
        status: ExamCardCheckStatus.valid,
        name: 'Amaka Bello',
        matricNumber: '25/CSC/0101',
        programme: 'B.Sc. Computer Science',
        cardNumber: cardNumber,
        sessionLabel: '2025/2026',
        eligiblePapers: 5,
      ),
      withdrawnCheckCode => const ExamCardCheckResult(
        status: ExamCardCheckStatus.withdrawn,
        cardNumber: cardNumber,
        withdrawnReason: CardRevokedReason.feeReversed,
      ),
      standingCheckCode => const ExamCardCheckResult(
        status: ExamCardCheckStatus.standingBlocked,
        cardNumber: 'EC2026-000207',
      ),
      _ => const ExamCardCheckResult(status: ExamCardCheckStatus.notFound),
    };
  }
}
