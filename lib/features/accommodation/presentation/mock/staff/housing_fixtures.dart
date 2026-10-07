import '../../models/accommodation_models.dart';
import '../../models/staff/housing_models.dart';

/// Sample content for the housing office screens.
///
/// Presentation-only placeholders: delete this file once the housing
/// endpoints exist. Amina Hall is the busy hostel (occupants, held beds,
/// a room under maintenance); Tafawa Hall is new and still empty, so the
/// occupant list shows both its populated and its empty form.
abstract final class HousingFixtures {
  static const String amina = 'amina';
  static const String tafawa = 'tafawa';
  static const String firstTerm = '2026/2027-1';
  static const String secondTerm = '2026/2027-2';
  static const int bedFee = 7500000;

  /// A student the ban list already holds, for the by-hand refusal.
  static const String bannedMatric = '24/CSC/0440';

  static final DateTime now = DateTime(2026, 10, 8, 6, 39);

  static const List<DirectoryStudent> directory = [
    DirectoryStudent(
      name: 'Amaka Bello',
      matricNumber: '25/CSC/0101',
      level: 200,
      programme: 'Computer Science',
    ),
    DirectoryStudent(
      name: 'Zainab Yusuf',
      matricNumber: '25/CSC/0202',
      level: 200,
      programme: 'Computer Science',
    ),
    DirectoryStudent(
      name: 'Ifeoma Nwosu',
      matricNumber: '24/LAW/0310',
      level: 300,
      programme: 'Law',
    ),
    DirectoryStudent(
      name: 'Chinedu Okafor',
      matricNumber: '24/ENG/0128',
      level: 300,
      programme: 'Mechanical Engineering',
    ),
    DirectoryStudent(
      name: 'Tunde Bakare',
      matricNumber: bannedMatric,
      level: 300,
      programme: 'Computer Science',
    ),
    DirectoryStudent(
      name: 'Halima Danjuma',
      matricNumber: '26/MED/0017',
      level: 100,
      programme: 'Medicine',
    ),
  ];

  static HousingRoom _room({
    required String block,
    required String number,
    required String floor,
    required String roomType,
    required int beds,
    RoomStatus status = RoomStatus.open,
    Map<int, BedState> states = const {},
    Map<int, String> occupants = const {},
  }) {
    return HousingRoom(
      id: '$block-$number',
      blockId: block,
      number: number,
      floor: floor,
      roomType: roomType,
      status: status,
      beds: [
        for (var bed = 1; bed <= beds; bed++)
          HousingBed(
            number: bed,
            state: status == RoomStatus.open
                ? states[bed] ?? BedState.free
                : BedState.blocked,
            occupant: occupants[bed],
          ),
      ],
    );
  }

  static final Hostel aminaHall = Hostel(
    id: amina,
    name: 'Amina Hall',
    gender: HostelGender.female,
    blocks: const [
      HostelBlock(id: 'a', name: 'Block A'),
      HostelBlock(id: 'b', name: 'Block B'),
    ],
    rooms: [
      _room(
        block: 'a',
        number: '101',
        floor: 'Ground floor',
        roomType: '2-Bed Room',
        beds: 2,
        states: {1: BedState.taken, 2: BedState.taken},
        occupants: {1: 'Ifeoma Nwosu', 2: 'Halima Danjuma'},
      ),
      _room(
        block: 'a',
        number: '104',
        floor: 'Ground floor',
        roomType: '2-Bed Room',
        beds: 2,
        states: {1: BedState.taken, 2: BedState.held},
        occupants: {1: 'Zainab Yusuf', 2: 'Amaka Bello'},
      ),
      _room(
        block: 'a',
        number: '106',
        floor: 'Ground floor',
        roomType: '4-Bed Room',
        beds: 4,
        states: {1: BedState.taken, 2: BedState.taken},
        occupants: {1: 'Ngozi Eze', 2: 'Bisi Adeyemi'},
      ),
      _room(
        block: 'a',
        number: '201',
        floor: 'First floor',
        roomType: '2-Bed Room',
        beds: 2,
        status: RoomStatus.maintenance,
      ),
      _room(
        block: 'b',
        number: '101',
        floor: 'Ground floor',
        roomType: '4-Bed Room',
        beds: 4,
      ),
      _room(
        block: 'b',
        number: '102',
        floor: 'Ground floor',
        roomType: '4-Bed Room',
        beds: 4,
        states: {1: BedState.taken},
        occupants: {1: 'Fatima Sani'},
      ),
    ],
  );

  static final Hostel tafawaHall = Hostel(
    id: tafawa,
    name: 'Tafawa Hall',
    gender: HostelGender.male,
    blocks: const [HostelBlock(id: 'a', name: 'Block A')],
    rooms: [
      _room(
        block: 'a',
        number: '001',
        floor: 'Ground floor',
        roomType: '4-Bed Room',
        beds: 4,
      ),
      _room(
        block: 'a',
        number: '002',
        floor: 'Ground floor',
        roomType: '4-Bed Room',
        beds: 4,
      ),
    ],
  );

  static const BedLocation _aminaA104 = BedLocation(
    hostel: 'Amina Hall',
    block: 'Block A',
    room: '104',
    bed: 2,
    roomType: '2-Bed Room',
    floor: 'Ground floor',
  );

  static BedLocation _bed(
    String room,
    int bed, {
    String roomType = '2-Bed Room',
  }) {
    return BedLocation(
      hostel: 'Amina Hall',
      block: 'Block A',
      room: room,
      bed: bed,
      roomType: roomType,
      floor: 'Ground floor',
    );
  }

  static final List<AllocationRecord> allocations = [
    AllocationRecord(
      id: 'al-1001',
      studentName: 'Amaka Bello',
      matricNumber: '25/CSC/0101',
      level: 200,
      programme: 'Computer Science',
      bed: _aminaA104,
      termLabel: firstTerm,
      state: StaffAllocationState.held,
      feeMinorUnits: bedFee,
      method: AllocationMethod.student,
      createdOn: DateTime(2026, 10, 7, 12, 59),
      invoiceReference: 'AC/2026/00142',
    ),
    AllocationRecord(
      id: 'al-1002',
      studentName: 'Zainab Yusuf',
      matricNumber: '25/CSC/0202',
      level: 200,
      programme: 'Computer Science',
      bed: _bed('104', 1),
      termLabel: firstTerm,
      state: StaffAllocationState.confirmed,
      feeMinorUnits: bedFee,
      method: AllocationMethod.student,
      createdOn: DateTime(2026, 10, 5, 9, 12),
      invoiceReference: 'AC/2026/00131',
    ),
    AllocationRecord(
      id: 'al-1003',
      studentName: 'Ifeoma Nwosu',
      matricNumber: '24/LAW/0310',
      level: 300,
      programme: 'Law',
      bed: _bed('101', 1),
      termLabel: firstTerm,
      state: StaffAllocationState.checkedIn,
      feeMinorUnits: bedFee,
      method: AllocationMethod.keepMyRoom,
      createdOn: DateTime(2026, 9, 28, 15, 40),
      invoiceReference: 'AC/2026/00098',
    ),
    AllocationRecord(
      id: 'al-1004',
      studentName: 'Halima Danjuma',
      matricNumber: '26/MED/0017',
      level: 100,
      programme: 'Medicine',
      bed: _bed('101', 2),
      termLabel: firstTerm,
      state: StaffAllocationState.confirmed,
      feeMinorUnits: 0,
      method: AllocationMethod.byHand,
      createdOn: DateTime(2026, 10, 1, 11, 5),
    ),
    AllocationRecord(
      id: 'al-1005',
      studentName: 'Ngozi Eze',
      matricNumber: '25/BIO/0087',
      level: 200,
      programme: 'Biochemistry',
      bed: _bed('106', 3, roomType: '4-Bed Room'),
      termLabel: firstTerm,
      state: StaffAllocationState.offered,
      feeMinorUnits: bedFee,
      method: AllocationMethod.automatic,
      createdOn: DateTime(2026, 10, 6, 17, 20),
    ),
    AllocationRecord(
      id: 'al-1006',
      studentName: 'Bisi Adeyemi',
      matricNumber: '25/ECO/0210',
      level: 200,
      programme: 'Economics',
      bed: _bed('106', 4, roomType: '4-Bed Room'),
      termLabel: secondTerm,
      state: StaffAllocationState.cancelled,
      feeMinorUnits: bedFee,
      method: AllocationMethod.spreadsheet,
      createdOn: DateTime(2026, 9, 30, 8, 45),
      invoiceReference: 'AC/2026/00110',
    ),
  ];

  static final List<TermOpening> openings = [
    TermOpening(
      termLabel: firstTerm,
      opensOn: DateTime(2026, 9, 21),
      closesOn: DateTime(2026, 10, 30),
      method: BookingMethod.firstCome,
      status: OpeningStatus.open,
      holdHours: 2,
      graceHours: 72,
      freeQuota: 12,
      closedDays: [DateTime(2026, 10, 1)],
    ),
    TermOpening(
      termLabel: secondTerm,
      opensOn: DateTime(2027, 2, 1),
      closesOn: DateTime(2027, 2, 28),
      method: BookingMethod.draw,
      status: OpeningStatus.scheduled,
      holdHours: 2,
      graceHours: 72,
      freeQuota: 12,
      closedDays: const [],
    ),
  ];

  static const List<RoomPrice> prices = [
    RoomPrice(roomType: '2-Bed Room', minorUnits: bedFee),
    RoomPrice(roomType: '4-Bed Room', minorUnits: 5500000),
    RoomPrice(roomType: '6-Bed Room', minorUnits: 4200000),
  ];

  static const RefundPolicy refundPolicy = RefundPolicy(
    sharePercent: 70,
    windowDays: 14,
  );

  static final List<AgreementVersion> agreements = [
    AgreementVersion(
      version: 3,
      publishedOn: DateTime(2026, 8, 24),
      summary: 'Late fees release the bed. Keys are returned at check-out. Cancellation refunds go to the wallet.',
      isCurrent: true,
    ),
    AgreementVersion(
      version: 2,
      publishedOn: DateTime(2025, 8, 18),
      summary: 'Added the visitors policy and quiet hours.',
    ),
    AgreementVersion(
      version: 1,
      publishedOn: DateTime(2024, 8, 12),
      summary: 'First published agreement.',
    ),
  ];

  static const List<HousingNoticeText> notices = [
    HousingNoticeText(
      key: NoticeKey.offerMade,
      body: 'A bed has been offered to you. Accept before the deadline or it goes to the next student.',
    ),
    HousingNoticeText(
      key: NoticeKey.deadlineNear,
      body: 'Your held bed lapses soon. Pay the fee to keep it.',
    ),
    HousingNoticeText(
      key: NoticeKey.bedReleased,
      body: 'Your bed has been released because the fee was not paid in time.',
    ),
    HousingNoticeText(
      key: NoticeKey.welcome,
      body: 'Welcome to the hostel. Collect your key at the hall office.',
    ),
  ];

  static const List<HousingCategory> categories = [
    HousingCategory(
      id: 'returning',
      name: 'Returning resident',
      weight: 5,
      studentCount: 412,
    ),
    HousingCategory(
      id: 'final-year',
      name: 'Final year',
      weight: 4,
      studentCount: 188,
    ),
    HousingCategory(
      id: 'scholar',
      name: 'Scholarship holder',
      weight: 3,
      studentCount: 64,
    ),
    HousingCategory(
      id: 'fresh',
      name: 'Fresh student',
      weight: 1,
      studentCount: 530,
    ),
  ];

  static final List<HousingBan> bans = [
    HousingBan(
      id: 'ban-1',
      studentName: 'Tunde Bakare',
      matricNumber: bannedMatric,
      reason: 'Damaged hostel property and unpaid levy.',
      since: DateTime(2026, 3, 12),
    ),
  ];

  static const List<Occupant> occupants = [
    Occupant(
      hostelId: amina,
      studentName: 'Ifeoma Nwosu',
      matricNumber: '24/LAW/0310',
      roomLabel: 'Block A · 101',
      bedNumber: 1,
      state: StaffAllocationState.checkedIn,
    ),
    Occupant(
      hostelId: amina,
      studentName: 'Halima Danjuma',
      matricNumber: '26/MED/0017',
      roomLabel: 'Block A · 101',
      bedNumber: 2,
      state: StaffAllocationState.confirmed,
    ),
    Occupant(
      hostelId: amina,
      studentName: 'Zainab Yusuf',
      matricNumber: '25/CSC/0202',
      roomLabel: 'Block A · 104',
      bedNumber: 1,
      state: StaffAllocationState.confirmed,
    ),
    Occupant(
      hostelId: amina,
      studentName: 'Amaka Bello',
      matricNumber: '25/CSC/0101',
      roomLabel: 'Block A · 104',
      bedNumber: 2,
      state: StaffAllocationState.held,
    ),
    Occupant(
      hostelId: amina,
      studentName: 'Fatima Sani',
      matricNumber: '25/PHY/0044',
      roomLabel: 'Block B · 102',
      bedNumber: 1,
      state: StaffAllocationState.checkedIn,
    ),
  ];

  static final HousingLedger ledger = HousingLedger(
    allocations: allocations,
    hostels: [aminaHall, tafawaHall],
    openings: openings,
    prices: prices,
    refundPolicy: refundPolicy,
    agreements: agreements,
    notices: notices,
    categories: categories,
    bans: bans,
    occupants: occupants,
    directory: directory,
    waitlistCount: 42,
    drawApplicants: 120,
    keepEligible: 96,
  );

  /// The sheet the upload demo reads for each sample file.
  static UploadOutcome upload(UploadSample sample, {required String batch}) {
    return switch (sample) {
      UploadSample.valid => UploadOutcome(
        status: UploadStatus.success,
        fileName: 'allocations-2026-1.csv',
        rowCount: 48,
        batchReference: batch,
      ),
      UploadSample.badHeader => const UploadOutcome(
        status: UploadStatus.headerError,
        fileName: 'allocations-old-format.csv',
        missingColumn: 'matric_number',
      ),
      UploadSample.badRows => const UploadOutcome(
        status: UploadStatus.rowErrors,
        fileName: 'allocations-2026-1-draft.csv',
        rowCount: 48,
        issues: [
          UploadIssue(
            row: 4,
            kind: UploadIssueKind.matricUnknown,
            value: '25/CSC/9999',
          ),
          UploadIssue(
            row: 9,
            kind: UploadIssueKind.bedTaken,
            value: 'Amina Hall · A · 104 · 2',
          ),
          UploadIssue(
            row: 15,
            kind: UploadIssueKind.bedUnknown,
            value: 'Amina Hall · A · 999 · 1',
          ),
          UploadIssue(
            row: 22,
            kind: UploadIssueKind.duplicateStudent,
            value: '25/CSC/0202',
          ),
          UploadIssue(
            row: 31,
            kind: UploadIssueKind.genderMismatch,
            value: 'Tafawa Hall · A · 001 · 1',
          ),
        ],
      ),
    };
  }
}
