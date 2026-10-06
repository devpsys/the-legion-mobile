import '../../models/registration_models.dart';
import '../../models/staff/approvals_models.dart';

/// Sample HoD approvals content from
/// `ui-designs/registration-records/approvals-decisions/`.
abstract final class ApprovalsFixtures {
  static const String session = '2026/2027';
  static const String termLabel = 'First semester';
  static const String staffName = 'Dr Ibrahim Sani';
  static const String staffRole = 'Head of Department · CS';
  static const String department = 'Dept of Computer Science';

  static final List<ApprovalQueueItem> queue = [
    const ApprovalQueueItem(
      studentId: 'stu-chinedu',
      name: 'Chinedu Okafor',
      matricNumber: '25/CSC/0104',
      programmeCode: 'BSC-CSC',
      level: 300,
      pendingCourseCount: 3,
      processed: false,
      atMinimum: true,
    ),
    const ApprovalQueueItem(
      studentId: 'stu-amaka',
      name: 'Amaka Bello',
      matricNumber: '25/CSC/0101',
      programmeCode: 'BSC-CSC',
      level: 300,
      pendingCourseCount: 2,
      processed: false,
      hasClash: true,
    ),
    const ApprovalQueueItem(
      studentId: 'stu-tunde',
      name: 'Tunde Okafor',
      matricNumber: '25/ELE/0201',
      programmeCode: 'BENG-EEE',
      level: 200,
      pendingCourseCount: 4,
      processed: false,
    ),
    const ApprovalQueueItem(
      studentId: 'stu-fatima',
      name: 'Fatima Abdullah',
      matricNumber: '25/MTH/0208',
      programmeCode: 'BSC-MTH',
      level: 200,
      pendingCourseCount: 1,
      processed: false,
    ),
    const ApprovalQueueItem(
      studentId: 'stu-emeka',
      name: 'Emeka Nwosu',
      matricNumber: '25/CSC/0111',
      programmeCode: 'BSC-CSC',
      level: 100,
      pendingCourseCount: 2,
      processed: false,
    ),
    const ApprovalQueueItem(
      studentId: 'stu-halima',
      name: 'Halima Yusuf',
      matricNumber: '25/CSC/0109',
      programmeCode: 'BSC-CSC',
      level: 400,
      pendingCourseCount: 0,
      processed: true,
    ),
  ];

  static final StudentRegistrationReview chineduReview =
      StudentRegistrationReview(
        studentId: 'stu-chinedu',
        name: 'Chinedu Okafor',
        matricNumber: '25/CSC/0104',
        programme: 'B.Sc. Computer Science',
        level: 300,
        sessionLabel: '$session $termLabel',
        registeredUnits: 15,
        maximumUnits: 24,
        minimumUnits: 15,
        courses: [
          const ApprovalCourseLine(
            id: 'c-csc401',
            code: 'CSC401',
            title: 'Artificial Intelligence',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.pending,
          ),
          const ApprovalCourseLine(
            id: 'c-csc405',
            code: 'CSC405',
            title: 'Computer Graphics',
            section: 'B',
            units: 3,
            status: CourseApprovalStatus.pending,
          ),
          const ApprovalCourseLine(
            id: 'c-csc407',
            code: 'CSC407',
            title: 'Distributed Systems',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.pending,
          ),
          const ApprovalCourseLine(
            id: 'c-mth301',
            code: 'MTH301',
            title: 'Advanced Mathematics',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.pending,
            clashAccepted: true,
          ),
          ApprovalCourseLine(
            id: 'c-csc301',
            code: 'CSC301',
            title: 'Algorithms and Complexity',
            section: 'A',
            units: 3,
            status: CourseApprovalStatus.approved,
            decidedBy: staffName,
            decidedOn: DateTime(2026, 10, 3),
          ),
        ],
      );

  /// Alternate: department registers courses directly (no approve actions).
  static final StudentRegistrationReview directDepartmentReview =
      chineduReview.copyWith(
        directDepartment: true,
        courses: chineduReview.courses
            .map(
              (c) => c.copyWith(
                status: CourseApprovalStatus.approved,
                decidedBy: staffName,
                decidedOn: DateTime(2026, 10, 3),
              ),
            )
            .toList(growable: false),
      );

  static StudentRegistrationReview reviewFor(String studentId) {
    if (studentId == 'stu-chinedu-direct') return directDepartmentReview;
    return chineduReview;
  }

  static final List<RequestDecisionItem> requests = [
    RequestDecisionItem(
      id: 'req-overload-segun',
      type: AcademicRequestType.overload,
      title: 'Register more units than allowed',
      summary: '32 units in 2026/2027 First semester (limit 24)',
      studentName: 'Segun Adeyemi',
      matricNumber: '25/ELE/0203',
      programmeCode: 'BENG-EEE',
      level: 300,
      filedOn: DateTime(2026, 10, 1),
      status: AcademicRequestStatus.pending,
      effectNote:
          'If approved: Raises the student\'s unit limit for the term to '
          'the units requested.',
      studentNote:
          'EEE301 and EEE302 are both 4-unit courses and the laboratory for '
          'EEE301 clashes with EEE302. I have already written to my level '
          'adviser.',
    ),
    RequestDecisionItem(
      id: 'req-adddrop-tunde',
      type: AcademicRequestType.addDropAfterDeadline,
      title: 'Add or drop courses after the deadline',
      summary: '2026/2027 First semester: add EEE402, drop EEE301',
      studentName: 'Tunde Okafor',
      matricNumber: '25/ELE/0201',
      programmeCode: 'BENG-EEE',
      level: 200,
      filedOn: DateTime(2026, 10, 2),
      status: AcademicRequestStatus.pending,
      effectNote:
          'If approved: Opens course registration for the student alone '
          'for a few days.',
      studentNote:
          'I was in hospital for the add/drop week. The ward letter is '
          'attached.',
    ),
    RequestDecisionItem(
      id: 'req-waive-amaka',
      type: AcademicRequestType.waivePrerequisite,
      title: 'Waive a prerequisite',
      summary: 'Take CSC405 without CSC203',
      studentName: 'Amaka Bello',
      matricNumber: '25/CSC/0101',
      programmeCode: 'BSC-CSC',
      level: 300,
      filedOn: DateTime(2026, 10, 2),
      status: AcademicRequestStatus.pending,
      effectNote:
          'If approved: Lets the student register for the course without '
          'the prerequisite.',
      studentNote: 'I completed an equivalent course at my previous university.',
    ),
    RequestDecisionItem(
      id: 'req-programme-emeka',
      type: AcademicRequestType.changeOfProgramme,
      title: 'Change of programme',
      summary: 'Move from BSC-CSC to BSC-MTH',
      studentName: 'Emeka Nwosu',
      matricNumber: '25/CSC/0111',
      programmeCode: 'BSC-CSC',
      level: 100,
      filedOn: DateTime(2026, 9, 28),
      status: AcademicRequestStatus.pending,
      effectNote:
          'If approved: Asks the faculty to move the student onto a '
          'different programme.',
      studentNote: 'I want to specialise in mathematics from 200 Level.',
    ),
  ];

  static final StudyPlanAdvice chineduAdvice = StudyPlanAdvice(
    studentId: 'stu-chinedu',
    name: 'Chinedu Okafor',
    matricNumber: '25/CSC/0104',
    programme: 'B.Sc. Computer Science',
    unitsPassed: 96,
    unitsPlanned: 15,
    awardThreshold: 180,
    coursesStillToPass: 7,
    terms: const [
      StudyPlanTermAdvice(
        label: '2026/2027 First semester',
        plannedUnits: 15,
        maximumUnits: 24,
        courseCodes: ['CSC401', 'CSC405', 'CSC407', 'MTH301'],
      ),
      StudyPlanTermAdvice(
        label: '2026/2027 Second semester',
        plannedUnits: 18,
        maximumUnits: 24,
        courseCodes: ['SIWES'],
      ),
      StudyPlanTermAdvice(
        label: '2027/2028 First semester',
        plannedUnits: 27,
        maximumUnits: 24,
        courseCodes: ['CSC411', 'CSC415', 'CSC421', 'CSC499'],
        overCeiling: true,
      ),
    ],
    warnings: const [
      '2 courses you still have to pass are in no term yet: CSC305, CSC409.',
      '2027/2028 First semester has 27 units planned. The most you may '
          'register is 24, so something will have to move.',
      'CSC401 has a prerequisite that is still outstanding.',
    ],
  );
}
