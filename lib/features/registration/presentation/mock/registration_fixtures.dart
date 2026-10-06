import '../models/registration_models.dart';

/// Sample content for the Registration & Records student screens.
///
/// Presentation-only placeholders drawn from
/// `ui-designs/registration-records/course-registration/`. Delete once the
/// registry endpoints feed the models from a repository.
abstract final class RegistrationFixtures {
  static const String session = '2026/2027';

  static const RegistrationStudent student = RegistrationStudent(
    name: 'Amaka Bello',
    matricNumber: '25/CSC/0101',
    level: 300,
    programme: 'B.Sc. Computer Science',
    faculty: 'Faculty of Science',
    department: 'Computer Science',
  );

  static const RegistrationWindow window = RegistrationWindow(
    session: session,
    termLabel: 'First semester',
    state: WindowState.open,
    scheduleLine:
        'Opens 5 Oct, 08:00 · late registration from 23 Nov · closes 12 Dec, '
        '23:59 · add/drop until 20 Dec',
  );

  static const ResourceGate gate = ResourceGate(kind: ResourceGateKind.allowed);

  /// Alternate gate: bursary / records cannot be checked yet (amber, non-blocking).
  static const ResourceGate notTrackedGate = ResourceGate(
    kind: ResourceGateKind.unverified,
    unverifiedDetail:
        'Bursary and records cannot be checked yet. You may still choose '
        'courses; clearance will be verified before the form is accepted.',
  );

  /// Alternate gate: fees block registration.
  static const ResourceGate feesBlockedGate = ResourceGate(
    kind: ResourceGateKind.blocked,
    blockingReason:
        'Pay at least ₦24,000.00 of your outstanding fees to unlock course '
        'registration.',
  );

  static const int minimumUnits = 15;
  static const int maximumUnits = 24;

  static final List<RegisteredCourse> courses = [
    const RegisteredCourse(
      id: 'reg-csc301',
      code: 'CSC301',
      title: 'Algorithms and Complexity',
      section: 'A',
      units: 3,
      status: CourseApprovalStatus.approved,
      canDrop: false,
    ),
    const RegisteredCourse(
      id: 'reg-csc311',
      code: 'CSC311',
      title: 'Software Engineering',
      section: 'A',
      units: 3,
      status: CourseApprovalStatus.pending,
    ),
    const RegisteredCourse(
      id: 'reg-mth301',
      code: 'MTH301',
      title: 'Advanced Mathematics',
      section: 'A',
      units: 3,
      status: CourseApprovalStatus.pending,
    ),
    const RegisteredCourse(
      id: 'reg-csc315',
      code: 'CSC315',
      title: 'Introduction to Machine Learning',
      section: 'A',
      units: 3,
      status: CourseApprovalStatus.approved,
      canDrop: true,
    ),
    const RegisteredCourse(
      id: 'reg-csc307',
      code: 'CSC307',
      title: 'Human-Computer Interaction',
      section: 'A',
      units: 3,
      status: CourseApprovalStatus.clashAccepted,
    ),
    const RegisteredCourse(
      id: 'reg-csc405',
      code: 'CSC405',
      title: 'Computer Graphics',
      section: 'A',
      units: 3,
      status: CourseApprovalStatus.rejected,
      rejectReason:
          'CSC405 needs CSC203, which is not on your record. Request the '
          'prerequisite to be waived if you believe you have taken it.',
      canDrop: false,
    ),
    const RegisteredCourse(
      id: 'reg-csc305',
      code: 'CSC305',
      title: 'Operating Systems',
      section: 'A',
      units: 3,
      status: CourseApprovalStatus.dropped,
      canDrop: false,
    ),
  ];

  static final List<CatalogueCourse> catalogue = [
    const CatalogueCourse(
      id: 'cat-mth301b',
      code: 'MTH301',
      title: 'Advanced Mathematics',
      section: 'B',
      units: 3,
      seatsLabel: '18 seats',
    ),
    const CatalogueCourse(
      id: 'cat-csc405a',
      code: 'CSC405',
      title: 'Computer Graphics',
      section: 'A',
      units: 3,
      block: CatalogueBlock.timetableClash,
      clashDetail: 'Overlaps CSC307 [A] on Wed 10:00–12:00.',
      seatsLabel: '12 seats',
    ),
    const CatalogueCourse(
      id: 'cat-csc409',
      code: 'CSC409',
      title: 'Cryptography and Network Security',
      section: 'A',
      units: 3,
      block: CatalogueBlock.full,
      seatsLabel: 'Full',
    ),
    const CatalogueCourse(
      id: 'cat-csc401',
      code: 'CSC401',
      title: 'Compiler Construction',
      section: 'A',
      units: 3,
      block: CatalogueBlock.missingPrerequisite,
      prerequisiteCode: 'CSC305',
      seatsLabel: '22 seats',
    ),
    const CatalogueCourse(
      id: 'cat-csc305b',
      code: 'CSC305',
      title: 'Operating Systems',
      section: 'B',
      units: 3,
      block: CatalogueBlock.notOpenYet,
    ),
    const CatalogueCourse(
      id: 'cat-gns401',
      code: 'GNS401',
      title: 'Peace and Conflict Resolution',
      section: 'A',
      units: 2,
      block: CatalogueBlock.outsidePlan,
      seatsLabel: '40 seats',
    ),
  ];

  static final List<WeekMeeting> week = [
    const WeekMeeting(
      weekday: 1,
      startLabel: '09:00',
      endLabel: '11:00',
      courseCode: 'CSC301',
      venue: 'LT1',
    ),
    const WeekMeeting(
      weekday: 1,
      startLabel: '14:00',
      endLabel: '16:00',
      courseCode: 'CSC311',
      venue: 'Lab B',
    ),
    const WeekMeeting(
      weekday: 2,
      startLabel: '10:00',
      endLabel: '12:00',
      courseCode: 'MTH301',
      venue: 'Hall 3',
    ),
    const WeekMeeting(
      weekday: 2,
      startLabel: '12:00',
      endLabel: '14:00',
      courseCode: 'CSC307',
      venue: 'Lab A',
    ),
    const WeekMeeting(
      weekday: 3,
      startLabel: '11:00',
      endLabel: '13:00',
      courseCode: 'CSC315',
      venue: 'LT2',
    ),
    const WeekMeeting(
      weekday: 4,
      startLabel: '08:00',
      endLabel: '10:00',
      courseCode: 'CSC301',
      venue: 'LT1',
    ),
    const WeekMeeting(
      weekday: 4,
      startLabel: '14:00',
      endLabel: '16:00',
      courseCode: 'MTH301',
      venue: 'Hall 3',
    ),
    const WeekMeeting(
      weekday: 5,
      startLabel: '10:00',
      endLabel: '12:00',
      courseCode: 'CSC315 Lab',
      venue: 'Comp Centre',
    ),
  ];

  static final CourseFormRecord sampleForm = CourseFormRecord(
    id: 'form-v1',
    versionLabel: 'v1',
    submittedOn: DateTime(2026, 10, 3, 14, 22),
    status: CourseFormStatus.submitted,
    courses: courses
        .where((c) => c.status.countsTowardUnits)
        .toList(growable: false),
    documentId: 'TL-26-883491',
    formId: '2026-B1-CSC-0101 · COPY 1 (REGISTRY)',
  );

  static final StudyPlan studyPlan = StudyPlan(
    unitsPassed: 96,
    unitsPlanned: 15,
    awardUnits: 180,
    coursesStillToPass: 7,
    programmeConclusion: '2027/2028, Second semester',
    warningsIntro:
        'None of this stops you planning. It is what registration would say '
        'if the terms below opened today.',
    warnings: const [
      StudyPlanWarning(
        detail:
            '2 courses you still have to pass are in no term yet: CSC305, '
            'CSC409.',
        emphasis: ['CSC305', 'CSC409'],
      ),
      StudyPlanWarning(
        detail:
            '2027/2028 First semester has 27 units planned. The most you may '
            'register is 24, so something will have to move.',
      ),
      StudyPlanWarning(
        detail:
            'CSC401 is planned for 2027/2028 First semester, but CSC305, '
            'which it needs, is in no term at all.',
        emphasis: ['CSC401', 'CSC305'],
      ),
    ],
    adviserName: 'Dr Ibrahim Sani',
    adviserRole: 'Academic Adviser',
    adviserNote:
        'CSC315 has no laboratory this semester, so keep CSC307 if you can. '
        'It is the only 300-level project course before you go on industrial '
        'training.',
    adviserNotedOn: DateTime(2026, 9, 18),
    terms: const [
      PlannedTerm(
        id: 'term-now',
        label: '2026/2027 First semester',
        eyebrow: 'Now',
        isCurrent: true,
        courses: [
          RegisteredCourse(
            id: 'plan-csc301',
            code: 'CSC301',
            title: 'Structured Programming',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.approved,
            canDrop: false,
          ),
          RegisteredCourse(
            id: 'plan-csc307',
            code: 'CSC307',
            title: 'Software Engineering',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.approved,
            canDrop: false,
          ),
          RegisteredCourse(
            id: 'plan-csc311',
            code: 'CSC311',
            title: 'Operating Systems I',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.approved,
            canDrop: false,
          ),
          RegisteredCourse(
            id: 'plan-csc315',
            code: 'CSC315',
            title: 'Database Design',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.approved,
            canDrop: false,
          ),
          RegisteredCourse(
            id: 'plan-mth301',
            code: 'MTH301',
            title: 'Numerical Analysis I',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.approved,
            canDrop: false,
          ),
        ],
      ),
      PlannedTerm(
        id: 'term-siwes',
        label: '2026/2027 Second semester',
        eyebrow: '',
        subtitle: 'SIWES / Industrial Training',
        unitsOverride: 18,
        courses: [],
      ),
      PlannedTerm(
        id: 'term-next',
        label: '2027/2028 First semester',
        eyebrow: '',
        subtitle: 'Final year thesis and core electives',
        unitsOverride: 27,
        overLimit: true,
        note: 'Over unit ceiling. 3 units must be reassigned.',
        courses: [],
      ),
    ],
    auditRows: const [
      DegreeAuditRow(
        label: '100 Level',
        detail: 'All 11 courses completed',
        isComplete: true,
      ),
      DegreeAuditRow(
        label: '200 Level',
        detail: 'All 12 courses completed',
        isComplete: true,
      ),
      DegreeAuditRow(
        label: '300 Level',
        detail: '7 total courses registered or remaining',
        isComplete: false,
        kind: DegreeAuditKind.current,
        takingNow: ['CSC301', 'CSC307', 'CSC311', 'CSC315'],
        stillToTake: ['CSC305', 'CSC321', 'CSC409'],
      ),
      DegreeAuditRow(
        label: 'Electives',
        detail: 'Departmental options requirement',
        isComplete: false,
        kind: DegreeAuditKind.electives,
        progressLabel: '6 of 9 units passed',
      ),
    ],
    planOptions: const [
      StudyPlanCourseOption(
        code: 'CSC305',
        title: 'Operating Systems II',
        units: 3,
      ),
      StudyPlanCourseOption(
        code: 'CSC321',
        title: 'Artificial Intelligence Foundations',
        units: 3,
      ),
      StudyPlanCourseOption(
        code: 'CSC401',
        title: 'Organisation of Programming Languages',
        units: 3,
      ),
      StudyPlanCourseOption(
        code: 'CSC409',
        title: 'Research Methodology in Computing',
        units: 2,
      ),
    ],
    targetTerms: const [
      '2026/2027 Second semester',
      '2027/2028 First semester',
      '2027/2028 Second semester',
    ],
    howThisWorksSecondary:
        'Nothing here is a registration. When a term opens you still register '
        'for the sections you want, and the rules are checked then.',
  );

  /// Replacement levy in kobo (₦5,000.00).
  static const int idCardReplacementFeeMinorUnits = 500000;

  /// Default ID card record: unpaid replacement in progress (Amaka).
  static final IdCardRecord idCard = IdCardRecord(
    photoStatus: IdCardPhotoStatus.approved,
    replacementFeeMinorUnits: idCardReplacementFeeMinorUnits,
    hasEverHeldCard: true,
    activeRequest: IdCardActiveRequest(
      serial: 'LG/ID/2026/00892',
      status: IdCardStatus.requested,
      reason: IdCardReason.lostOrStolen,
      requestedOn: DateTime(2026, 9, 14),
      feePayment: IdCardFeePayment.unpaid,
      feeMinorUnits: idCardReplacementFeeMinorUnits,
      canCancel: true,
    ),
    history: [
      IdCardHistoryEntry(
        serial: 'LG/ID/2025/00417',
        status: IdCardHistoryStatus.collected,
        reason: IdCardReason.lostOrStolen,
        requestedOn: DateTime(2025, 10, 12),
        expiresOn: DateTime(2029, 9, 1),
      ),
    ],
  );

  /// Photo not approved — request form locked.
  static final IdCardRecord idCardPhotoLocked = IdCardRecord(
    photoStatus: IdCardPhotoStatus.missing,
    replacementFeeMinorUnits: idCardReplacementFeeMinorUnits,
    hasEverHeldCard: true,
    history: idCard.history,
  );

  /// Printed card waiting at the registry.
  static final IdCardRecord idCardReadyForCollection = IdCardRecord(
    photoStatus: IdCardPhotoStatus.approved,
    replacementFeeMinorUnits: idCardReplacementFeeMinorUnits,
    hasEverHeldCard: true,
    activeRequest: IdCardActiveRequest(
      serial: 'LG/ID/2026/00892',
      status: IdCardStatus.printed,
      reason: IdCardReason.lostOrStolen,
      requestedOn: DateTime(2026, 9, 14),
      feePayment: IdCardFeePayment.paid,
      feeMinorUnits: idCardReplacementFeeMinorUnits,
      collectionDeadline: DateTime(2027, 9, 14),
    ),
    history: idCard.history,
  );

  /// First-ever free card (Tunde-style empty history).
  static const IdCardRecord idCardFirstIssue = IdCardRecord(
    photoStatus: IdCardPhotoStatus.approved,
    replacementFeeMinorUnits: idCardReplacementFeeMinorUnits,
    hasEverHeldCard: false,
    draftReason: IdCardReason.firstCard,
    history: [],
  );

  static final List<AcademicRequest> academicRequests = [
    AcademicRequest(
      id: 'req-waive-csc405',
      type: AcademicRequestType.waivePrerequisite,
      title: 'Waive a prerequisite',
      summary: 'Take CSC405 without CSC203',
      filedOn: DateTime(2026, 10, 2),
      status: AcademicRequestStatus.pending,
      canWithdraw: true,
      emphasis: const ['CSC405', 'CSC203'],
    ),
    AcademicRequest(
      id: 'req-overload-30',
      type: AcademicRequestType.overload,
      title: 'Register more units than allowed',
      summary: '30 units in 2026/2027 First semester (limit 24)',
      filedOn: DateTime(2026, 9, 24),
      status: AcademicRequestStatus.rejected,
      decisionNote:
          'Your level adviser has asked you to see the head of department. '
          'Twenty-four units is already the ceiling for 300 Level.',
      emphasis: const ['30', '24'],
    ),
  ];

  /// Portal clock for discipline appeal windows (Amaka default visit).
  static final DateTime disciplineAsOf = DateTime(2026, 10, 6);

  static final DisciplineSanction sanctionProbation00031 = DisciplineSanction(
    caseId: 'case-dc-2026-00031',
    type: SanctionType.probation,
    summary:
        '2 semesters from 2026/2027 First semester, ends when 2026/2027 '
        'Second semester begins',
    lifecycle: SanctionLifecycle.active,
    statusNote:
        'Probation does not change your student status. You can register '
        'and sit examinations as normal. Your result carries the probation '
        'for that period.',
  );

  /// Open harassment case with a scheduled hearing (DC-2026-00044).
  static final DisciplineCase caseUnderInvestigation = DisciplineCase(
    id: 'case-dc-2026-00044',
    reference: 'DC-2026-00044',
    summary:
        'Repeated messages to a fellow student after a rejected invitation',
    status: DisciplineCaseStatus.underInvestigation,
    severity: DisciplineSeverity.minor,
    category: DisciplineCategory.harassment,
    openedOn: DateTime(2026, 10, 12),
    narrative:
        'On three occasions between 2 and 9 October, the same student sent '
        'messages to a fellow student in the Main Hostel after an invitation '
        'to a group chat was declined. No further contact has been recorded '
        'since 9 October.',
    incidentOn: DateTime(2026, 10, 9),
    incidentVenue: 'Main Hostel corridor',
    sessionLabel: '2026/2027 First semester',
    reportedBy: 'Student Affairs',
    reportedOn: DateTime(2026, 10, 12),
    evidence: const [
      DisciplineEvidence(
        title: 'Written statement',
        kind: EvidenceKind.writtenStatement,
        detail: 'Submitted 12 October 2026',
      ),
    ],
    hearing: DisciplineHearing(
      heldOn: DateTime(2026, 10, 17, 10),
      venue: 'Disciplinary Office, Room 2',
      note:
          'You may bring a written statement and witnesses. Contact the '
          'disciplinary office if you can\'t attend.',
      scheduled: true,
    ),
    listDetail: 'Student Affairs Panel · Next session 24 Oct 2026',
  );

  /// Decided examination case with an open appeal window (DC-2026-00031).
  static final DisciplineCase caseDecidedAppealOpen = DisciplineCase(
    id: 'case-dc-2026-00031',
    reference: 'DC-2026-00031',
    summary:
        'Alleged collusion with another candidate in the CSC301 examination',
    status: DisciplineCaseStatus.decided,
    severity: DisciplineSeverity.major,
    category: DisciplineCategory.examinationMisconduct,
    openedOn: DateTime(2026, 10, 1),
    narrative:
        'Two candidates were found to have signed the same attendance sheet '
        'for the CSC301 practical. Neither has previously been reported.',
    incidentOn: DateTime(2026, 9, 30),
    incidentVenue: 'CBT Room 3, Lab One',
    sessionLabel: '2026/2027 First semester',
    reportedBy: 'Chidinma Eze, invigilator',
    reportedOn: DateTime(2026, 10, 1),
    evidence: const [
      DisciplineEvidence(
        title: 'Attendance sheet, 30 September',
        kind: EvidenceKind.document,
      ),
      DisciplineEvidence(
        title: 'Written statement from the invigilator',
        kind: EvidenceKind.writtenStatement,
      ),
    ],
    finding: DisciplineFinding.foundLiable,
    decidedOn: DateTime(2026, 10, 5),
    decisionReason:
        'Your attendance was recorded for a practical you did not attend, '
        'and the same sheet carried another candidate\'s signature. Collusion '
        'in an examination is a grave matter under the undergraduate '
        'regulations, but in mitigation your record before this examination '
        'was clean.',
    hearing: DisciplineHearing(
      heldOn: DateTime(2026, 10, 3, 10),
      venue: 'Disciplinary Office, Room 2',
      note:
          'Panel convened under Statute 14. Candidate and invigilator '
          'statements received.',
    ),
    sanction: sanctionProbation00031,
    appealWindowClosesOn: DateTime(2026, 10, 19),
    listDetail: 'Finding: Found liable · Sanction: Probation (Active)',
  );

  /// Default Amaka discipline: open case + decided case with active probation.
  static final DisciplineRecord discipline = DisciplineRecord(
    standing: StudentStanding.active,
    asOf: disciplineAsOf,
    cases: [caseUnderInvestigation, caseDecidedAppealOpen],
    sanctions: [sanctionProbation00031],
  );

  /// Clean record — empty list state.
  static final DisciplineRecord disciplineEmpty = DisciplineRecord(
    standing: StudentStanding.active,
    asOf: disciplineAsOf,
    cases: const [],
    sanctions: const [],
  );

  /// Decided case after the appeal was lodged (status under appeal).
  static final DisciplineCase caseAppealLodged = caseDecidedAppealOpen.copyWith(
    status: DisciplineCaseStatus.underAppeal,
    appeal: DisciplineAppeal(
      grounds:
          'The attendance sheet for the 6 October practical lists '
          'twenty-eight names. Twenty-eight students signed in a room with '
          'twenty-four seats, so somebody was recorded who was not there. I '
          'did not know this until after the hearing and I have asked the '
          'invigilator for the register. If another candidate was recorded '
          'in my place, finding that out now matters more than what I did '
          'or did not do.',
      lodgedOn: DateTime(2026, 10, 18),
    ),
  );

  static final DisciplineRecord disciplineAppealLodged = DisciplineRecord(
    standing: StudentStanding.active,
    asOf: DateTime(2026, 10, 18),
    cases: [caseUnderInvestigation, caseAppealLodged],
    sanctions: [sanctionProbation00031],
  );

  /// Decided case after the appeal window closed with no appeal.
  static final DisciplineCase caseAppealWindowClosed =
      caseDecidedAppealOpen.copyWith();

  static final DisciplineRecord disciplineAppealWindowClosed = DisciplineRecord(
    standing: StudentStanding.active,
    asOf: DateTime(2026, 10, 20),
    cases: [caseUnderInvestigation, caseAppealWindowClosed],
    sanctions: [sanctionProbation00031],
  );

  /// Suspended student with an appealable major case (Fatima persona).
  static final DisciplineSanction sanctionSuspension00038 = DisciplineSanction(
    caseId: 'case-dc-2026-00038',
    type: SanctionType.suspension,
    summary: '2 semesters from 2026/2027 First semester',
    lifecycle: SanctionLifecycle.active,
    statusNote:
        'Effective date: 4 October 2026. Student privileges, campus '
        'residential tenancy, portal access, and statutory rights are '
        'de-activated through 2026/2027 Academic Session Second Semester.',
  );

  static final DisciplineCase caseSuspendedAppealOpen = DisciplineCase(
    id: 'case-dc-2026-00038',
    reference: 'DC-2026-00038',
    summary:
        'Unauthorised possession of examination material in MTH302 hall',
    status: DisciplineCaseStatus.decided,
    severity: DisciplineSeverity.major,
    category: DisciplineCategory.examinationMisconduct,
    openedOn: DateTime(2026, 9, 28),
    narrative:
        'The candidate was reported by Chief Invigilator Dr. K. O. Adeleke '
        'for possessing handwritten mathematical annotations and formulary '
        'sheets concealed beneath standard test booklet answering script '
        'during the continuous assessment session for Real Analysis II '
        '(MTH302).',
    incidentOn: DateTime(2026, 9, 28),
    incidentVenue: 'Hall 4, Faculty of Science',
    sessionLabel: '2025/2026',
    reportedBy: 'Dr. K. O. Adeleke, chief invigilator',
    reportedOn: DateTime(2026, 9, 28),
    evidence: const [],
    finding: DisciplineFinding.foundLiable,
    decidedOn: DateTime(2026, 10, 5),
    decisionReason:
        'Unauthorised possession of examination material in MTH302 hall.',
    hearing: DisciplineHearing(
      heldOn: DateTime(2026, 10, 3, 10),
      venue: 'Senate Disciplinary Panel',
    ),
    sanction: sanctionSuspension00038,
    appealWindowClosesOn: DateTime(2026, 10, 19),
  );

  static final DisciplineRecord disciplineSuspended = DisciplineRecord(
    standing: StudentStanding.suspended,
    asOf: disciplineAsOf,
    cases: [caseSuspendedAppealOpen],
    sanctions: [sanctionSuspension00038],
  );

  /// Sanction list with expulsion (Ibrahim persona — sanctions section).
  static final DisciplineRecord disciplineWithExpulsion = DisciplineRecord(
    standing: StudentStanding.expelled,
    asOf: disciplineAsOf,
    cases: const [],
    sanctions: [
      DisciplineSanction(
        caseId: 'case-dc-2026-00012',
        type: SanctionType.expulsion,
        summary: 'Permanent',
        lifecycle: SanctionLifecycle.active,
        statusNote:
            'Expulsion is permanent. To return to the university you would '
            'need a fresh admission.',
      ),
      DisciplineSanction(
        caseId: 'case-dc-2026-00021',
        type: SanctionType.suspension,
        summary:
            '2 semesters from 2025/2026 Second semester, ends when '
            '2026/2027 First semester begins',
        lifecycle: SanctionLifecycle.served,
      ),
      DisciplineSanction(
        caseId: 'case-dc-2026-00044',
        type: SanctionType.probation,
        summary: '1 semester from 2026/2027 First semester',
        lifecycle: SanctionLifecycle.lifted,
      ),
    ],
  );

  /// The default ledger the cubit serves: open window, cleared gate, courses
  /// chosen but the form not yet submitted; ID card replacement unpaid.
  static final RegistrationLedger ledger = RegistrationLedger(
    student: student,
    window: window,
    gate: gate,
    minimumUnits: minimumUnits,
    maximumUnits: maximumUnits,
    courses: courses,
    catalogue: catalogue,
    week: week,
    formStatus: CourseFormStatus.notSubmitted,
    forms: const [],
    studyPlan: studyPlan,
    idCard: idCard,
    academicRequests: academicRequests,
    discipline: discipline,
  );

  /// After a successful mock submit: form on record, window still open.
  static RegistrationLedger afterSubmit(RegistrationLedger current) {
    final form = CourseFormRecord(
      id: 'form-v1',
      versionLabel: 'v1',
      submittedOn: DateTime(2026, 10, 3, 14, 22),
      status: CourseFormStatus.submitted,
      courses: current.courses
          .where((c) => c.status.countsTowardUnits)
          .toList(growable: false),
      documentId: sampleForm.documentId,
      formId: sampleForm.formId,
    );
    return RegistrationLedger(
      student: current.student,
      window: current.window,
      gate: current.gate,
      minimumUnits: current.minimumUnits,
      maximumUnits: current.maximumUnits,
      courses: current.courses,
      catalogue: current.catalogue,
      week: current.week,
      formStatus: CourseFormStatus.submitted,
      forms: [form, ...current.forms],
      studyPlan: current.studyPlan,
      idCard: current.idCard,
      academicRequests: current.academicRequests,
      discipline: current.discipline,
      declarationAccepted: true,
    );
  }
}
