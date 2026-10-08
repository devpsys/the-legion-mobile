import '../../models/examinations_models.dart';
import '../../models/staff/exam_office_models.dart';

/// Sample content for the examinations office screens.
///
/// Presentation-only placeholders: delete this file once the examinations
/// endpoints exist. The shapes follow the designs under
/// `ui-designs/examinations-results/` (`staff_results_*`, `admin_exams_*`,
/// `admin_grading_*`, `admin_incidents_*`, `admin_resits_*` and
/// `admin_broadsheets_*`).
abstract final class ExamOfficeFixtures {
  static const String officer = 'Segun Adeyemi';
  static const String examiner = 'Dr. Amina Bello';
  static const String term = '25/26 • 2nd Sem';
  static const String emptyTerm = '2026/2027-1';
  static const String earlierTerm = '25/26 • 1st Sem';

  // ----------------------------------------------------------------- scales

  static const GradingScale undergraduateScale = GradingScale(
    id: 'undergraduate',
    name: 'Undergraduate scale',
    isDefault: true,
    appliesTo: 'Every programme that has not been given its own scale.',
    bands: [
      GradeBand(letter: 'A', from: 70, points: 5),
      GradeBand(letter: 'B', from: 60, points: 4),
      GradeBand(letter: 'C', from: 50, points: 3),
      GradeBand(letter: 'D', from: 45, points: 2),
      GradeBand(letter: 'E', from: 40, points: 1),
      GradeBand(letter: 'F', from: 0, points: 0, isPass: false),
    ],
    degreeClasses: [
      ClassificationBand(name: 'First Class Honours', from: 4.5, to: 5),
      ClassificationBand(name: 'Second Class Upper', from: 3.5, to: 4.49),
      ClassificationBand(name: 'Second Class Lower', from: 2.4, to: 3.49),
      ClassificationBand(name: 'Third Class', from: 1.5, to: 2.39),
      ClassificationBand(name: 'Pass', from: 1, to: 1.49),
    ],
  );

  /// Broken on purpose: its lowest band starts at 47, so marks 0 to 46 have
  /// no grade and results cannot be worked out.
  static const GradingScale postgraduateScale = GradingScale(
    id: 'postgraduate',
    name: 'Postgraduate scale',
    appliesTo: 'M.Sc. Computer Science, M.Eng. Electrical',
    bands: [
      GradeBand(letter: 'A', from: 70, points: 5),
      GradeBand(letter: 'B', from: 60, points: 4),
      GradeBand(letter: 'C', from: 50, points: 3),
      GradeBand(letter: 'D', from: 47, points: 2),
    ],
    degreeClasses: [
      ClassificationBand(name: 'Distinction', from: 4.5, to: 5),
      ClassificationBand(name: 'Merit', from: 3.5, to: 4.49),
      ClassificationBand(name: 'Pass', from: 2.4, to: 3.49),
    ],
  );

  // ---------------------------------------------------------------- results

  static const List<StudentMark> _beingMarkedEntries = [
    StudentMark(
      matric: '25/CSC/0104',
      name: 'Chidi Musa',
      coursework: 24,
      exam: 44,
    ),
    StudentMark(
      matric: '25/CSC/0101',
      name: 'Amaka Bello',
      coursework: 26,
      exam: 48,
    ),
    StudentMark(matric: '25/CSC/0112', name: 'Babafemi Alabi', coursework: 18),
    StudentMark(matric: '25/CSC/0115', name: 'Chioma Egwu'),
    StudentMark(
      matric: '25/CSC/0120',
      name: 'Danjuma Garba',
      holdReason: 'Absent from the examination.',
    ),
    StudentMark(matric: '25/CSC/0122', name: 'Emeka Okafor'),
    StudentMark(
      matric: '25/CSC/0128',
      name: 'Fatima Abubakar',
      coursework: 28,
      exam: 56,
    ),
    StudentMark(matric: '25/CSC/0135', name: 'Grace Danladi'),
  ];

  static const List<StudentMark> _fullEntries = [
    StudentMark(
      matric: '25/CSC/0101',
      name: 'Amaka Bello',
      coursework: 26,
      exam: 48,
    ),
    StudentMark(
      matric: '25/CSC/0104',
      name: 'Chidi Musa',
      coursework: 24,
      exam: 44,
    ),
    StudentMark(
      matric: '25/CSC/0112',
      name: 'Babafemi Alabi',
      coursework: 18,
      exam: 34,
    ),
    StudentMark(
      matric: '25/CSC/0115',
      name: 'Chioma Egwu',
      coursework: 21,
      exam: 40,
    ),
    StudentMark(
      matric: '25/CSC/0128',
      name: 'Fatima Abubakar',
      coursework: 28,
      exam: 56,
    ),
  ];

  static const MarkingBatch beingMarkedBatch = MarkingBatch(
    id: 'RB-2026-00412',
    courseCode: 'CSC 301',
    title: 'Introduction to Algorithms',
    units: 3,
    termLabel: term,
    stage: ResultsStage.beingMarked,
    entries: _beingMarkedEntries,
  );

  static final MarkingBatch sentBackBatch = MarkingBatch(
    id: 'RB-2026-00389',
    courseCode: 'CSC 205',
    title: 'Operating Systems I',
    units: 3,
    termLabel: term,
    stage: ResultsStage.sentBack,
    entries: const [
      StudentMark(
        matric: '25/CSC/0187',
        name: 'Ibrahim Garba',
        coursework: 20,
        exam: 38,
        isFlagged: true,
        previousTotal: 68,
      ),
      StudentMark(
        matric: '25/CSC/0233',
        name: 'Ngozi Okonjo',
        coursework: 17,
        exam: 32,
        isFlagged: true,
        previousTotal: 54,
      ),
      StudentMark(
        matric: '25/CSC/0104',
        name: 'Chidi Musa',
        coursework: 24,
        exam: 44,
        previousTotal: 68,
      ),
      StudentMark(
        matric: '25/CSC/0101',
        name: 'Amaka Bello',
        coursework: 26,
        exam: 48,
        previousTotal: 74,
      ),
    ],
    hodNote: HodNote(
      author: 'Prof. K. Adebayo',
      sentOn: DateTime(2026, 3, 11, 16, 40),
      note:
          'These totals do not agree with the scripts submitted to the '
          'department. Please check 25/CSC/0187 and 25/CSC/0233.',
    ),
  );

  static final MarkingBatch withApproversBatch = MarkingBatch(
    id: 'RB-2026-00405',
    courseCode: 'CSC 315',
    title: 'Database Systems',
    units: 3,
    termLabel: term,
    stage: ResultsStage.withApprovers,
    entries: _fullEntries,
    approvalDesk: 'Senate Examination Committee',
    approvalDue: DateTime(2026, 3, 18),
  );

  static const MarkingBatch secondBeingMarkedBatch = MarkingBatch(
    id: 'RB-2026-00440',
    courseCode: 'CSC 401',
    title: 'Artificial Intelligence',
    units: 3,
    termLabel: term,
    stage: ResultsStage.beingMarked,
    entries: [
      StudentMark(
        matric: '25/CSC/0201',
        name: 'Tolu Adeyemi',
        coursework: 22,
        exam: 41,
      ),
      StudentMark(
        matric: '25/CSC/0202',
        name: 'Uche Nwosu',
        coursework: 19,
        exam: 37,
      ),
      StudentMark(matric: '25/CSC/0203', name: 'Vivian Eze'),
      StudentMark(matric: '25/CSC/0204', name: 'Wale Ogundipe'),
    ],
  );

  static final MarkingBatch publishedBatch = MarkingBatch(
    id: 'RB-2026-00301',
    courseCode: 'CSC 101',
    title: 'Introduction to Computing',
    units: 3,
    termLabel: term,
    stage: ResultsStage.published,
    entries: const [
      StudentMark(
        matric: '25/CSC/0101',
        name: 'Amaka Bello',
        coursework: 26,
        exam: 48,
      ),
      StudentMark(
        matric: '25/CSC/0104',
        name: 'Chidi Musa',
        coursework: 24,
        exam: 44,
      ),
      StudentMark(
        matric: '25/CSC/0112',
        name: 'Babafemi Alabi',
        coursework: 18,
        exam: 34,
      ),
      StudentMark(
        matric: '25/CSC/0115',
        name: 'Chioma Egwu',
        coursework: 21,
        exam: 40,
      ),
      StudentMark(
        matric: '25/CSC/0120',
        name: 'Danjuma Garba',
        holdReason: 'Absent from the examination.',
      ),
      StudentMark(
        matric: '25/CSC/0128',
        name: 'Fatima Abubakar',
        coursework: 28,
        exam: 56,
      ),
    ],
    publishedOn: DateTime(2026, 3, 19),
    gazetteRef: 'SR-2026-041B',
  );

  // --------------------------------------------------------------- sessions

  static final ExamSession liveSession = ExamSession(
    id: 'ses-2025-2',
    name: 'End of semester examinations',
    termLabel: term,
    startsOn: DateTime(2026, 12, 8),
    endsOn: DateTime(2026, 12, 19),
    cardsOpenOn: DateTime(2026, 12, 1, 8),
    status: SessionStatus.live,
    papers: [
      ExamPaper(
        id: 'p-csc301',
        courseCode: 'CSC 301',
        title: 'Introduction to Algorithms',
        startsAt: DateTime(2026, 12, 9, 9),
        minutes: 120,
        enrolled: 60,
        rooms: const [PaperRoom(name: 'Main Hall · Hall A', seated: 60)],
      ),
      ExamPaper(
        id: 'p-csc307',
        courseCode: 'CSC 307',
        title: 'Human-Computer Interaction',
        startsAt: DateTime(2026, 12, 10, 14),
        minutes: 120,
        enrolled: 60,
        rooms: const [
          PaperRoom(name: 'Main Hall · Hall B', seated: 40),
          PaperRoom(name: 'Main Hall · Room 102', seated: 20),
        ],
        status: PaperStatus.inProgress,
      ),
      ExamPaper(
        id: 'p-mth201',
        courseCode: 'MTH 201',
        title: 'Linear Algebra II',
        startsAt: DateTime(2026, 12, 9, 9),
        minutes: 120,
        enrolled: 40,
      ),
      ExamPaper(
        id: 'p-csc305',
        courseCode: 'CSC 305',
        title: 'Database Systems',
        startsAt: DateTime(2026, 12, 11, 9),
        minutes: 180,
        enrolled: 68,
        rooms: const [PaperRoom(name: 'Main Hall · Hall A', seated: 60)],
      ),
      ExamPaper(
        id: 'p-phy201',
        courseCode: 'PHY 201',
        title: 'General Physics III',
        startsAt: DateTime(2026, 12, 8, 9),
        minutes: 120,
        enrolled: 30,
        rooms: const [PaperRoom(name: 'Faculty LT-1', seated: 30)],
        status: PaperStatus.sat,
      ),
    ],
    clashes: const [
      ExamClash(
        matric: '25/CSC/0104',
        firstCourse: 'CSC 301',
        secondCourse: 'MTH 201',
      ),
      ExamClash(
        matric: '25/ELE/0203',
        firstCourse: 'CSC 301',
        secondCourse: 'MTH 201',
      ),
    ],
    issuedCards: const [
      IssuedCard(
        matric: '25/CSC/0101',
        name: 'Amaka Bello',
        cardNumber: 'EC2026-000123',
        checkCode: 'K7Q2M4XB9PTR',
      ),
      IssuedCard(
        matric: '25/CSC/0104',
        name: 'Chidi Musa',
        cardNumber: 'EC2026-000124',
        checkCode: 'C41D1M05A124',
      ),
    ],
  );

  static final ExamSession closedSession = ExamSession(
    id: 'ses-2025-1',
    name: 'End of semester examinations',
    termLabel: earlierTerm,
    startsOn: DateTime(2026, 5, 4),
    endsOn: DateTime(2026, 5, 15),
    cardsOpenOn: DateTime(2026, 4, 27, 8),
    status: SessionStatus.closed,
    papers: [
      ExamPaper(
        id: 'p-csc211',
        courseCode: 'CSC 211',
        title: 'Introduction to Algorithms',
        startsAt: DateTime(2026, 5, 5, 9),
        minutes: 120,
        enrolled: 52,
        rooms: const [PaperRoom(name: 'Main Hall · Hall A', seated: 52)],
        status: PaperStatus.sat,
      ),
    ],
  );

  static const List<OverflowRoom> overflowRooms = [
    OverflowRoom(name: 'Faculty LT-1', capacity: 45),
    OverflowRoom(name: 'Faculty LT-2', capacity: 80),
    OverflowRoom(name: 'Lab 3', capacity: 25),
  ];

  // -------------------------------------------------------------- incidents

  static final List<ExamIncident> incidents = [
    ExamIncident(
      id: 'EI-2026-00042',
      kind: IncidentKind.malpractice,
      status: IncidentStatus.referred,
      courseCode: 'CSC 301',
      sittingAt: DateTime(2026, 12, 9, 9),
      hall: 'Hall B, desk 42',
      matric: '25/CSC/0104',
      description:
          "Answer sheet found in the washroom with another candidate's name "
          'on the cover.',
      holdsMark: true,
      disciplineRef: 'DCM-2026-0018',
      hearingOn: DateTime(2027, 1, 18),
    ),
    ExamIncident(
      id: 'EI-2026-00045',
      kind: IncidentKind.malpractice,
      status: IncidentStatus.underReview,
      courseCode: 'CSC 301',
      sittingAt: DateTime(2026, 12, 9, 9),
      hall: 'Auditorium North',
      matric: '25/CSC/0187',
      description:
          'Unauthorised formulas written on palms and a ruler casing seized '
          'at the desk.',
      holdsMark: true,
    ),
    ExamIncident(
      id: 'EI-2026-00049',
      kind: IncidentKind.malpractice,
      status: IncidentStatus.underReview,
      courseCode: 'CSC 315',
      sittingAt: DateTime(2026, 12, 11, 9),
      hall: 'Block C, Room 12',
      matric: '25/CSC/0115',
      description:
          'Second script found in the candidate\'s bag after the paper.',
      holdsMark: true,
    ),
    ExamIncident(
      id: 'EI-2026-00118',
      kind: IncidentKind.absence,
      status: IncidentStatus.underReview,
      courseCode: 'MTH 201',
      sittingAt: DateTime(2026, 12, 9, 9),
      hall: 'Block C, Room 12',
      matric: '25/MTH/0208',
      description:
          'Candidate did not present at roll call or desk verification.',
      holdsMark: true,
    ),
    ExamIncident(
      id: 'EI-2026-00120',
      kind: IncidentKind.illness,
      status: IncidentStatus.reported,
      courseCode: 'CSC 307',
      sittingAt: DateTime(2026, 12, 10, 14),
      hall: 'Hall B, Room 102',
      matric: '25/CSC/0119',
      description:
          'Candidate taken ill during the paper and attended by the clinic.',
    ),
    ExamIncident(
      id: 'EI-2026-00130',
      kind: IncidentKind.illness,
      status: IncidentStatus.closed,
      courseCode: 'CSC 301',
      sittingAt: DateTime(2026, 12, 9, 9),
      hall: 'Hall A',
      matric: '25/CSC/0101',
      description: 'Candidate felt faint and was seated near the door.',
    ),
  ];

  static const List<ImportRow> importRows = [
    ImportRow(
      courseCode: 'CSC 301',
      subject: '25/CSC/0115',
      kindText: 'malpractice',
      time: '09:15',
      description: '',
    ),
    ImportRow(
      courseCode: 'CSC 301',
      subject: '25/CSC/0140',
      kindText: 'malpracitce',
      time: '09:20',
      description: 'Phone seen in the candidate\'s lap.',
    ),
    ImportRow(
      courseCode: 'CSC 301',
      subject: '25/CSC/0104',
      kindText: 'absence',
      time: '09:00',
      description: 'Did not present at roll call.',
    ),
    ImportRow(
      courseCode: 'CSC 301',
      subject: '25/CSC/0104',
      kindText: 'absence',
      time: '09:00',
      description: 'Did not present at roll call.',
    ),
    ImportRow(
      courseCode: 'CSC 301',
      subject: '25/CSC/0101',
      kindText: 'illness',
      time: '09:45',
      description: 'Candidate felt faint and was seated near the door.',
    ),
    ImportRow(
      courseCode: 'CSC307',
      subject: '25/CSC/0122',
      kindText: 'disruption',
      time: '10:00',
      description: 'Fire alarm test interrupted the paper.',
    ),
    ImportRow(
      courseCode: 'CSC 301',
      subject: '',
      kindText: 'disruption',
      time: '10:15',
      description: 'Generator failure in the hall for ten minutes.',
    ),
    ImportRow(
      courseCode: 'CSC 301',
      subject: 'OKAFOR SAMUEL',
      kindText: 'absence',
      time: '09:00',
      description: 'Absent. Name taken from the attendance sheet.',
    ),
    ImportRow(
      courseCode: 'CSC 301',
      subject: '25/CSC/0104',
      kindText: 'malpractice',
      time: '09:30',
      description: 'Notes found under the desk.',
    ),
  ];

  // ----------------------------------------------------------------- resits

  static final List<ResitWindow> windows = [
    ResitWindow(
      id: 'rw-2025-2',
      name: 'Resit window 25/26 • 2nd Sem',
      opensOn: DateTime(2027, 1, 5, 8),
      closesOn: DateTime(2027, 1, 23, 23, 59),
      feePerUnitMinorUnits: 200000,
      unitCap: 6,
      isOpen: true,
      registeredCount: 84,
      signups: const [
        ResitSignup(
          id: 'rs-1',
          courseCode: 'CSC 211',
          matric: '25/CSC/0101',
          title: 'Introduction to Algorithms',
          units: 3,
          feeMinorUnits: 600000,
        ),
        ResitSignup(
          id: 'rs-2',
          courseCode: 'MTH 203',
          matric: '25/CSC/0144',
          title: 'Linear Algebra and Vector Analysis',
          units: 3,
          feeMinorUnits: 600000,
        ),
        ResitSignup(
          id: 'rs-3',
          courseCode: 'PHY 102',
          matric: '25/ENG/0082',
          title: 'Electricity and Magnetism',
          units: 2,
          feeMinorUnits: 400000,
        ),
      ],
    ),
    ResitWindow(
      id: 'rw-2025-1',
      name: 'Resit window 25/26 • 1st Sem',
      opensOn: DateTime(2026, 8, 12, 8),
      closesOn: DateTime(2026, 8, 28, 23, 59),
      feePerUnitMinorUnits: 200000,
      unitCap: 6,
      isOpen: false,
      registeredCount: 112,
    ),
  ];

  // ------------------------------------------------------------- broadsheet

  static BroadsheetRow _row(
    String matric,
    String name,
    int score, {
    bool hasDossier = false,
  }) {
    final band = undergraduateScale.bandFor(score);
    final verdict = switch (band?.letter) {
      'F' || null => ScoreVerdict.notAPass,
      'E' => ScoreVerdict.marginal,
      _ => ScoreVerdict.cleared,
    };
    return BroadsheetRow(
      matric: matric,
      name: name,
      units: 3,
      score: score,
      grade: band?.letter,
      verdict: verdict,
      hasDossier: hasDossier,
    );
  }

  static final List<CourseBroadsheet> broadsheets = [
    CourseBroadsheet(
      courseCode: 'CSC 301',
      enrolled: 65,
      mean: 61.58,
      passed: 58,
      rows: [
        _row('25/CSC/0104', 'Chidi Musa', 68, hasDossier: true),
        const BroadsheetRow(
          matric: '25/CSC/0115',
          name: 'Bello Aminu',
          units: 3,
          score: 74,
          grade: 'A',
          verdict: ScoreVerdict.heldBack,
        ),
        _row('25/CSC/0122', 'Emeka Nnamdi', 34),
        _row('25/CSC/0128', 'Fatima Garba', 55),
        _row('25/CSC/0135', 'Gbenga Alabi', 46),
        _row('25/CSC/0140', 'Hassan Lawal', 42),
        _row('25/CSC/0101', 'Amaka Bello', 74, hasDossier: true),
      ],
    ),
    CourseBroadsheet(
      courseCode: 'CSC 305',
      enrolled: 68,
      mean: 58.2,
      passed: 60,
      rows: [
        _row('25/CSC/0101', 'Amaka Bello', 72, hasDossier: true),
        _row('25/CSC/0104', 'Chidi Musa', 66, hasDossier: true),
        _row('25/CSC/0122', 'Emeka Nnamdi', 38),
      ],
    ),
    CourseBroadsheet(
      courseCode: 'CSC 307',
      enrolled: 60,
      mean: 63.4,
      passed: 56,
      rows: [
        _row('25/CSC/0101', 'Amaka Bello', 68, hasDossier: true),
        _row('25/CSC/0104', 'Chidi Musa', 61, hasDossier: true),
      ],
    ),
    CourseBroadsheet(
      courseCode: 'MTH 201',
      enrolled: 40,
      mean: 55.9,
      passed: 33,
      rows: [
        _row('25/CSC/0104', 'Chidi Musa', 54, hasDossier: true),
        _row('25/CSC/0122', 'Emeka Nnamdi', 36),
      ],
    ),
    CourseBroadsheet(
      courseCode: 'PHY 201',
      enrolled: 30,
      mean: 49.7,
      passed: 21,
      rows: [
        _row('25/CSC/0104', 'Chidi Musa', 38, hasDossier: true),
        _row('25/CSC/0128', 'Fatima Garba', 57),
      ],
    ),
  ];

  static const List<StudentDossier> dossiers = [
    StudentDossier(
      matric: '25/CSC/0104',
      name: 'Chidi Musa',
      programme: 'B.Sc. Computer Science · 300 level',
      termLabel: term,
      cgpa: 3.42,
      standing: StandingKind.good,
      classification: 'Second Class Lower',
      unitsTaken: 15,
      unitsPassed: 12,
      courses: [
        DossierCourse(
          code: 'CSC 301',
          title: 'Operating Systems',
          units: 3,
          verdict: ScoreVerdict.cleared,
          score: 68,
          points: 4,
          grade: 'B',
        ),
        DossierCourse(
          code: 'CSC 305',
          title: 'Software Engineering',
          units: 3,
          verdict: ScoreVerdict.cleared,
          score: 72,
          points: 5,
          grade: 'A',
        ),
        DossierCourse(
          code: 'CSC 307',
          title: 'Computer Architecture',
          units: 3,
          verdict: ScoreVerdict.heldBack,
          score: 61,
          grade: 'B',
          incidentId: 'EI-2026-00042',
        ),
        DossierCourse(
          code: 'MTH 201',
          title: 'Mathematical Analysis',
          units: 3,
          verdict: ScoreVerdict.cleared,
          score: 54,
          points: 3,
          grade: 'C',
        ),
        DossierCourse(
          code: 'PHY 201',
          title: 'General Physics III',
          units: 3,
          verdict: ScoreVerdict.notAPass,
          score: 38,
          points: 0,
          grade: 'F',
        ),
      ],
    ),
    StudentDossier(
      matric: '25/CSC/0101',
      name: 'Amaka Bello',
      programme: 'B.Sc. Computer Science · 200 level',
      termLabel: term,
      cgpa: 3.62,
      standing: StandingKind.good,
      classification: 'Second Class Upper',
      unitsTaken: 15,
      unitsPassed: 12,
      courses: [
        DossierCourse(
          code: 'CSC 301',
          title: 'Structured Programming',
          units: 3,
          verdict: ScoreVerdict.cleared,
          score: 74,
          points: 5,
          grade: 'A',
        ),
        DossierCourse(
          code: 'CSC 307',
          title: 'Human-Computer Interaction',
          units: 3,
          verdict: ScoreVerdict.cleared,
          score: 68,
          points: 4,
          grade: 'B',
        ),
        DossierCourse(
          code: 'CSC 305',
          title: 'Database Systems',
          units: 3,
          verdict: ScoreVerdict.cleared,
          score: 72,
          points: 5,
          grade: 'A',
        ),
      ],
    ),
  ];

  // ----------------------------------------------------------------- ledger

  static final ExamOfficeLedger ledger = ExamOfficeLedger(
    officerName: officer,
    termLabels: const [emptyTerm, term, earlierTerm],
    batches: [
      beingMarkedBatch,
      sentBackBatch,
      withApproversBatch,
      secondBeingMarkedBatch,
      publishedBatch,
    ],
    sessions: [liveSession, closedSession],
    scales: const [undergraduateScale, postgraduateScale],
    probationCgpa: 2.4,
    withdrawalCgpa: 1.5,
    overflowRooms: overflowRooms,
    incidents: incidents,
    importRows: importRows,
    windows: windows,
    broadsheets: broadsheets,
    dossiers: dossiers,
  );
}
