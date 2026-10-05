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
    versionLabel: 'v1.0',
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
    warnings: const [
      StudyPlanWarning(
        title: 'Required courses still unplanned',
        detail:
            'CSC401 and CSC409 sit on your degree plan but are not on any '
            'term yet.',
      ),
      StudyPlanWarning(
        title: 'Next Harmattan is over the ceiling',
        detail:
            'The 2027/2028 Harmattan term is planned for 27 units; the degree '
            'plan allows 24.',
      ),
    ],
    adviserName: 'Dr Ibrahim Sani',
    adviserNote:
        'Keep the machine-learning elective this Harmattan and leave '
        'compiler construction for after SIWES — the prerequisite clears then.',
    adviserNotedOn: DateTime(2026, 9, 28),
    terms: [
      PlannedTerm(
        id: 'term-now',
        label: '2026/2027 · First semester',
        eyebrow: 'Now',
        isCurrent: true,
        courses: courses
            .where((c) => c.status.countsTowardUnits)
            .toList(growable: false),
      ),
      const PlannedTerm(
        id: 'term-siwes',
        label: '2026/2027 · SIWES',
        eyebrow: 'Industrial training',
        courses: [
          RegisteredCourse(
            id: 'plan-siwes',
            code: 'CSC399',
            title: 'Student Industrial Work Experience',
            section: 'A',
            units: 6,
            status: CourseApprovalStatus.approved,
            canDrop: false,
          ),
        ],
      ),
      const PlannedTerm(
        id: 'term-next',
        label: '2027/2028 · First semester',
        eyebrow: 'Over ceiling',
        note: '27 units planned against a 24-unit limit.',
        courses: [
          RegisteredCourse(
            id: 'plan-csc401',
            code: 'CSC401',
            title: 'Compiler Construction',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.approved,
            canDrop: false,
          ),
          RegisteredCourse(
            id: 'plan-csc409',
            code: 'CSC409',
            title: 'Distributed Systems',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.approved,
            canDrop: false,
          ),
        ],
      ),
    ],
    auditRows: const [
      DegreeAuditRow(
        label: '100 Level',
        detail: 'All required courses passed',
        isComplete: true,
      ),
      DegreeAuditRow(
        label: '200 Level',
        detail: 'All required courses passed',
        isComplete: true,
      ),
      DegreeAuditRow(
        label: '300 Level',
        detail: '2 required courses still open',
        isComplete: false,
      ),
      DegreeAuditRow(
        label: 'Electives',
        detail: '4 of 6 elective units planned',
        isComplete: false,
      ),
    ],
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
      versionLabel: 'v1.0',
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
