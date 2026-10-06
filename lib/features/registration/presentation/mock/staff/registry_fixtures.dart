import '../../models/registration_models.dart';
import '../../models/staff/registry_models.dart';

/// Sample registry content from
/// `ui-designs/registration-records/registry/`.
abstract final class RegistryFixtures {
  static const String officerName = 'Mrs Ifeoma Okonkwo';
  static const String officerDesk = 'Officer Desk · Mrs. Ifeoma Okonkwo';
  static const String officerRegId = 'REG-ID: 4098';

  static const RegistryDirectoryStats stats = RegistryDirectoryStats(
    matriculated: 2184,
    suspended: 41,
    withdrawn: 18,
    expelled: 6,
    graduated: 96,
  );

  static final List<RegistryDirectoryStudent> students = [
    const RegistryDirectoryStudent(
      id: 'stu-amaka',
      name: 'Amaka Bello',
      matricNumber: '25/CSC/0101',
      email: 'a.bello@legion.edu.ng',
      programmeCode: 'BSC-CSC',
      level: 300,
      status: RegistryDirectoryStatus.active,
    ),
    const RegistryDirectoryStudent(
      id: 'stu-chinedu',
      name: 'Chinedu Okafor',
      matricNumber: '25/CSC/0104',
      email: 'c.okafor@legion.edu.ng',
      programmeCode: 'BSC-CSC',
      level: 300,
      status: RegistryDirectoryStatus.active,
    ),
    const RegistryDirectoryStudent(
      id: 'stu-fatima',
      name: 'Fatima Abdullah',
      matricNumber: '25/MTH/0208',
      email: 'f.abdullah@legion.edu.ng',
      programmeCode: 'BSC-MTH',
      level: 200,
      status: RegistryDirectoryStatus.suspended,
    ),
    const RegistryDirectoryStudent(
      id: 'stu-emeka',
      name: 'Emeka Nwosu',
      matricNumber: '25/CSC/0111',
      email: 'e.nwosu@legion.edu.ng',
      programmeCode: 'BSC-CSC',
      level: 100,
      status: RegistryDirectoryStatus.withdrawn,
    ),
    const RegistryDirectoryStudent(
      id: 'stu-halima',
      name: 'Halima Yusuf',
      matricNumber: '25/CSC/0109',
      email: 'h.yusuf@legion.edu.ng',
      programmeCode: 'BSC-CSC',
      level: 400,
      status: RegistryDirectoryStatus.graduated,
    ),
    const RegistryDirectoryStudent(
      id: 'stu-ibrahim',
      name: 'Ibrahim Musa',
      matricNumber: '25/ACC/0311',
      email: 'i.musa@legion.edu.ng',
      programmeCode: 'BSC-ACC',
      level: 300,
      status: RegistryDirectoryStatus.expelled,
    ),
  ];

  static final RegistryStudentRecord amakaRecord = RegistryStudentRecord(
    id: 'stu-amaka',
    name: 'Amaka Bello',
    matricNumber: '25/CSC/0101',
    email: 'amaka.bello@example.com',
    programme: 'B.Sc. Computer Science',
    department: 'Department of Computer Science',
    level: 300,
    standing: StudentStanding.active,
    degreePlanLabel: 'B.Sc. Computer Science (2024 curriculum)',
    entryLabel: '2025/2026 First semester · 300 Level · UTME',
    jambNumber: '202630112234CD',
    matriculatedOn: DateTime(2025, 10, 3),
    photoVerified: true,
    idReplacementFeeOwing: true,
    registrationTerms: const [
      RegistryRegistrationTerm(
        label: '2026/2027 First semester',
        level: 300,
        totalUnits: 18,
        confirmed: false,
        note:
            'Registration started for the term but the course form isn\'t '
            'submitted',
        courses: [
          RegistryTermCourse(
            code: 'CSC301',
            section: 'A',
            title: 'Algorithms and Complexity',
            units: 3,
            status: CourseApprovalStatus.approved,
          ),
          RegistryTermCourse(
            code: 'CSC311',
            section: 'A',
            title: 'Software Engineering',
            units: 3,
            status: CourseApprovalStatus.pending,
          ),
          RegistryTermCourse(
            code: 'MTH301',
            section: 'A',
            title: 'Advanced Mathematics',
            units: 3,
            status: CourseApprovalStatus.pending,
          ),
        ],
      ),
      RegistryRegistrationTerm(
        label: '2025/2026 Second semester',
        level: 300,
        totalUnits: 11,
        confirmed: true,
        courses: [
          RegistryTermCourse(
            code: 'CSC305',
            section: 'A',
            title: 'Operating Systems',
            units: 3,
            status: CourseApprovalStatus.approved,
          ),
          RegistryTermCourse(
            code: 'CSC301',
            section: 'A',
            title: 'Algorithms and Complexity',
            units: 3,
            status: CourseApprovalStatus.approved,
          ),
        ],
      ),
    ],
  );

  static final RegistryStudentRecord fatimaRecord = RegistryStudentRecord(
    id: 'stu-fatima',
    name: 'Fatima Abdullah',
    matricNumber: '25/MTH/0208',
    email: 'f.abdullah@legion.edu.ng',
    programme: 'B.Sc. Mathematics',
    department: 'Department of Mathematics',
    level: 300,
    standing: StudentStanding.suspended,
    degreePlanLabel: 'B.Sc. Mathematics (2024 curriculum)',
    entryLabel: '2024/2025 First semester · 200 Level · UTME',
    jambNumber: '202520098765AB',
    matriculatedOn: DateTime(2024, 10, 5),
    photoVerified: true,
    registrationTerms: const [],
  );

  static final RegistryStudentRecord ibrahimNoPlan = RegistryStudentRecord(
    id: 'stu-ibrahim',
    name: 'Ibrahim Musa',
    matricNumber: '25/ACC/0311',
    email: 'i.musa@legion.edu.ng',
    programme: 'B.Sc. Accounting',
    department: 'Department of Accounting',
    level: 300,
    standing: StudentStanding.expelled,
    degreePlanLabel: '',
    entryLabel: '2024/2025 First semester · 200 Level · UTME',
    jambNumber: '202520011122CD',
    matriculatedOn: DateTime(2024, 10, 1),
    photoVerified: false,
    registrationTerms: const [],
  );

  static RegistryStudentRecord recordFor(String id) {
    return switch (id) {
      'stu-fatima' => fatimaRecord,
      'stu-ibrahim' => ibrahimNoPlan,
      _ => amakaRecord,
    };
  }

  static final List<IdCardProductionItem> idCards = [
    IdCardProductionItem(
      serial: 'LG/ID/2026/00892',
      studentName: 'Amaka Bello',
      matricNumber: '25/CSC/0101',
      programmeCode: 'BSC-CSC',
      reason: IdCardReason.lostOrStolen,
      status: IdCardStatus.requested,
      requestedOn: DateTime(2026, 9, 14),
      feePayment: IdCardFeePayment.unpaid,
      feeMinorUnits: 500000,
    ),
    IdCardProductionItem(
      serial: 'LG/ID/2026/00895',
      studentName: 'Chinedu Okafor',
      matricNumber: '25/CSC/0104',
      programmeCode: 'BSC-CSC',
      reason: IdCardReason.firstCard,
      status: IdCardStatus.requested,
      requestedOn: DateTime(2026, 9, 18),
      feePayment: IdCardFeePayment.notRequired,
      feeMinorUnits: 0,
    ),
    IdCardProductionItem(
      serial: 'LG/ID/2026/00880',
      studentName: 'Fatima Abdullah',
      matricNumber: '25/MTH/0208',
      programmeCode: 'BSC-MTH',
      reason: IdCardReason.lostOrStolen,
      status: IdCardStatus.printed,
      requestedOn: DateTime(2026, 9, 2),
      feePayment: IdCardFeePayment.paid,
      feeMinorUnits: 500000,
      printedOn: DateTime(2026, 9, 4),
    ),
  ];

  static IdCardPrintPreview previewFor(String serial) {
    final item = idCards.firstWhere(
      (c) => c.serial == serial,
      orElse: () => idCards.first,
    );
    final printed = item.status == IdCardStatus.printed;
    return IdCardPrintPreview(
      serial: item.serial,
      studentName: item.studentName,
      matricNumber: item.matricNumber,
      programme: item.programmeCode == 'BSC-MTH'
          ? 'B.Sc. Mathematics'
          : 'B.Sc. Computer Science',
      department: item.programmeCode == 'BSC-MTH'
          ? 'Department of Mathematics'
          : 'Department of Computer Science',
      status: item.status,
      expiresOn: printed ? DateTime(2030, 9, 14) : null,
      verificationCode: printed ? 'A1B2C3D4E5F6G7H8' : null,
      hasPhoto: item.hasPhoto,
    );
  }

  static const String validVerificationCode = 'A1B2C3D4E5F6G7H8';
  static const String invalidVerificationCode = 'INVALIDCARD00001';

  static IdCardVerificationResult verifyCode(String raw) {
    final code = raw.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    if (code.isEmpty) {
      return const IdCardVerificationResult(
        outcome: IdCardVerificationOutcome.idle,
      );
    }
    if (code == validVerificationCode) {
      return IdCardVerificationResult(
        outcome: IdCardVerificationOutcome.valid,
        name: 'Amaka Bello',
        matricNumber: '25/CSC/0101',
        programme: 'B.Sc. Computer Science',
        cardSerial: 'LG/ID/2026/00892',
        expiresOn: DateTime(2030, 9, 14),
      );
    }
    if (code == invalidVerificationCode) {
      return const IdCardVerificationResult(
        outcome: IdCardVerificationOutcome.invalid,
      );
    }
    return const IdCardVerificationResult(
      outcome: IdCardVerificationOutcome.notFound,
    );
  }
}
