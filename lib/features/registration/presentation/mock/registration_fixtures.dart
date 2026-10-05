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

  /// The default ledger the cubit serves: open window, cleared gate, courses
  /// chosen but the form not yet submitted.
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
      declarationAccepted: true,
    );
  }
}
