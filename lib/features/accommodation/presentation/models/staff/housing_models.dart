import 'package:equatable/equatable.dart';

import '../accommodation_models.dart';

/// Where one allocation stands, as the housing office sees it.
enum StaffAllocationState { held, offered, confirmed, checkedIn, cancelled }

/// How an allocation came to exist.
enum AllocationMethod {
  student,
  byHand,
  spreadsheet,
  automatic,
  draw,
  keepMyRoom,
}

/// Filters of the allocations queue.
enum AllocationQueueFilter { all, held, offered, confirmed, cancelled }

/// Who a hostel is open to.
enum HostelGender { female, male, mixed }

/// What one bed on the grid is doing.
enum BedState { free, held, taken, blocked }

/// Whether a room can be booked.
enum RoomStatus { open, maintenance, closed }

/// How a term's beds are given out.
enum BookingMethod { firstCome, draw, priority }

/// Where a term's booking window stands.
enum OpeningStatus { scheduled, open, closed }

/// The kind of problem a spreadsheet row can carry.
enum UploadIssueKind {
  bedUnknown,
  matricUnknown,
  bedTaken,
  duplicateStudent,
  genderMismatch,
}

/// What the spreadsheet upload has done so far.
enum UploadStatus { none, headerError, rowErrors, success }

/// The three sample files the demo upload can pick from.
enum UploadSample { valid, badHeader, badRows }

/// What allocating one student by hand came to.
enum HandAllocationStatus {
  none,
  allocated,
  unknownStudent,
  bedTaken,
  studentBanned,
}

/// How a draw picks its winners.
enum DrawMethod { ballot, priority }

/// One entry on the allocations queue.
class AllocationRecord extends Equatable {
  const AllocationRecord({
    required this.id,
    required this.studentName,
    required this.matricNumber,
    required this.level,
    required this.programme,
    required this.bed,
    required this.termLabel,
    required this.state,
    required this.feeMinorUnits,
    required this.method,
    required this.createdOn,
    this.invoiceReference,
  });

  final String id;
  final String studentName;
  final String matricNumber;
  final int level;
  final String programme;
  final BedLocation bed;

  /// `2026/2027-1`.
  final String termLabel;
  final StaffAllocationState state;

  /// Kobo; zero for a scholarship bed.
  final int feeMinorUnits;
  final AllocationMethod method;
  final DateTime createdOn;
  final String? invoiceReference;

  AllocationRecord copyWith({StaffAllocationState? state}) {
    return AllocationRecord(
      id: id,
      studentName: studentName,
      matricNumber: matricNumber,
      level: level,
      programme: programme,
      bed: bed,
      termLabel: termLabel,
      state: state ?? this.state,
      feeMinorUnits: feeMinorUnits,
      method: method,
      createdOn: createdOn,
      invoiceReference: invoiceReference,
    );
  }

  @override
  List<Object?> get props => [
    id,
    studentName,
    matricNumber,
    level,
    programme,
    bed,
    termLabel,
    state,
    feeMinorUnits,
    method,
    createdOn,
    invoiceReference,
  ];
}

/// One bed in a room.
class HousingBed extends Equatable {
  const HousingBed({required this.number, required this.state, this.occupant});

  final int number;
  final BedState state;

  /// The student's name when the bed is held or taken.
  final String? occupant;

  @override
  List<Object?> get props => [number, state, occupant];
}

/// One room of a block.
class HousingRoom extends Equatable {
  const HousingRoom({
    required this.id,
    required this.blockId,
    required this.number,
    required this.floor,
    required this.roomType,
    required this.status,
    required this.beds,
  });

  final String id;
  final String blockId;
  final String number;
  final String floor;
  final String roomType;
  final RoomStatus status;
  final List<HousingBed> beds;

  int get freeBeds => status == RoomStatus.open
      ? beds.where((bed) => bed.state == BedState.free).length
      : 0;

  HousingRoom copyWith({RoomStatus? status, String? roomType, String? floor}) {
    return HousingRoom(
      id: id,
      blockId: blockId,
      number: number,
      floor: floor ?? this.floor,
      roomType: roomType ?? this.roomType,
      status: status ?? this.status,
      beds: beds,
    );
  }

  @override
  List<Object?> get props => [
    id,
    blockId,
    number,
    floor,
    roomType,
    status,
    beds,
  ];
}

/// A block inside a hostel.
class HostelBlock extends Equatable {
  const HostelBlock({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

/// A hostel with its blocks and rooms.
class Hostel extends Equatable {
  const Hostel({
    required this.id,
    required this.name,
    required this.gender,
    required this.blocks,
    required this.rooms,
  });

  final String id;
  final String name;
  final HostelGender gender;
  final List<HostelBlock> blocks;
  final List<HousingRoom> rooms;

  int get totalBeds => rooms.fold(0, (sum, room) => sum + room.beds.length);

  int get freeBeds => rooms.fold(0, (sum, room) => sum + room.freeBeds);

  int get takenBeds => rooms.fold(
    0,
    (sum, room) =>
        sum + room.beds.where((bed) => bed.state == BedState.taken).length,
  );

  List<HousingRoom> roomsOf(String blockId) =>
      rooms.where((room) => room.blockId == blockId).toList();

  HousingRoom? roomById(String roomId) {
    for (final room in rooms) {
      if (room.id == roomId) return room;
    }
    return null;
  }

  HostelBlock? blockById(String blockId) {
    for (final block in blocks) {
      if (block.id == blockId) return block;
    }
    return null;
  }

  Hostel copyWith({List<HousingRoom>? rooms}) {
    return Hostel(
      id: id,
      name: name,
      gender: gender,
      blocks: blocks,
      rooms: rooms ?? this.rooms,
    );
  }

  @override
  List<Object?> get props => [id, name, gender, blocks, rooms];
}

/// One term's booking window.
class TermOpening extends Equatable {
  const TermOpening({
    required this.termLabel,
    required this.opensOn,
    required this.closesOn,
    required this.method,
    required this.status,
    required this.holdHours,
    required this.graceHours,
    required this.freeQuota,
    required this.closedDays,
  });

  final String termLabel;
  final DateTime opensOn;
  final DateTime closesOn;
  final BookingMethod method;
  final OpeningStatus status;

  /// How long a held bed waits for its fee.
  final int holdHours;

  /// Grace after the deadline during which a late fee still confirms.
  final int graceHours;

  /// Scholarship beds that carry no fee.
  final int freeQuota;

  /// Days the booking window pauses (public holidays, exams).
  final List<DateTime> closedDays;

  TermOpening copyWith({BookingMethod? method, OpeningStatus? status}) {
    return TermOpening(
      termLabel: termLabel,
      opensOn: opensOn,
      closesOn: closesOn,
      method: method ?? this.method,
      status: status ?? this.status,
      holdHours: holdHours,
      graceHours: graceHours,
      freeQuota: freeQuota,
      closedDays: closedDays,
    );
  }

  @override
  List<Object?> get props => [
    termLabel,
    opensOn,
    closesOn,
    method,
    status,
    holdHours,
    graceHours,
    freeQuota,
    closedDays,
  ];
}

/// What one room type costs for a term.
class RoomPrice extends Equatable {
  const RoomPrice({required this.roomType, required this.minorUnits});

  final String roomType;
  final int minorUnits;

  @override
  List<Object?> get props => [roomType, minorUnits];
}

/// The share of a paid fee that a cancellation hands back.
class RefundPolicy extends Equatable {
  const RefundPolicy({required this.sharePercent, required this.windowDays});

  /// 0–100.
  final int sharePercent;

  /// Days before check-in after which no refund is made.
  final int windowDays;

  RefundPolicy copyWith({int? sharePercent, int? windowDays}) {
    return RefundPolicy(
      sharePercent: sharePercent ?? this.sharePercent,
      windowDays: windowDays ?? this.windowDays,
    );
  }

  @override
  List<Object?> get props => [sharePercent, windowDays];
}

/// What a sample cancellation would hand back.
class RefundSimulation extends Equatable {
  const RefundSimulation({
    required this.paidMinorUnits,
    required this.daysBeforeCheckIn,
    required this.refundMinorUnits,
  });

  final int paidMinorUnits;
  final int daysBeforeCheckIn;
  final int refundMinorUnits;

  int get chargeMinorUnits => paidMinorUnits - refundMinorUnits;

  @override
  List<Object?> get props => [
    paidMinorUnits,
    daysBeforeCheckIn,
    refundMinorUnits,
  ];
}

/// One problem found on a spreadsheet row.
class UploadIssue extends Equatable {
  const UploadIssue({required this.row, required this.kind, this.value = ''});

  /// 1-based spreadsheet row.
  final int row;
  final UploadIssueKind kind;

  /// The offending cell.
  final String value;

  @override
  List<Object?> get props => [row, kind, value];
}

/// What the spreadsheet upload came to.
class UploadOutcome extends Equatable {
  const UploadOutcome({
    this.status = UploadStatus.none,
    this.fileName = '',
    this.rowCount = 0,
    this.issues = const [],
    this.missingColumn = '',
    this.batchReference = '',
  });

  final UploadStatus status;
  final String fileName;
  final int rowCount;
  final List<UploadIssue> issues;

  /// The header the sheet lacks, when [status] is headerError.
  final String missingColumn;

  /// `BATCH-2026-0042`, when [status] is success.
  final String batchReference;

  @override
  List<Object?> get props => [
    status,
    fileName,
    rowCount,
    issues,
    missingColumn,
    batchReference,
  ];
}

/// What allocating one student by hand came to.
class HandAllocationOutcome extends Equatable {
  const HandAllocationOutcome({
    this.status = HandAllocationStatus.none,
    this.studentName = '',
    this.bed,
  });

  final HandAllocationStatus status;
  final String studentName;
  final BedLocation? bed;

  @override
  List<Object?> get props => [status, studentName, bed];
}

/// What an automatic allocation run did.
class AutoAllocationOutcome extends Equatable {
  const AutoAllocationOutcome({
    required this.placed,
    required this.unplaced,
    required this.freeBedsLeft,
  });

  final int placed;
  final int unplaced;
  final int freeBedsLeft;

  @override
  List<Object?> get props => [placed, unplaced, freeBedsLeft];
}

/// What a draw did.
class DrawOutcome extends Equatable {
  const DrawOutcome({
    required this.method,
    required this.applicants,
    required this.seats,
    required this.winners,
    required this.reference,
  });

  final DrawMethod method;
  final int applicants;
  final int seats;
  final int winners;

  /// `DRAW-2026-0007`.
  final String reference;

  int get waitlisted => applicants - winners;

  @override
  List<Object?> get props => [method, applicants, seats, winners, reference];
}

/// A student skipped by the keep-my-room run, and why.
class KeepSkip extends Equatable {
  const KeepSkip({required this.studentName, required this.reason});

  final String studentName;
  final KeepSkipReason reason;

  @override
  List<Object?> get props => [studentName, reason];
}

/// Why a resident did not get their room offered back.
enum KeepSkipReason { banned, unpaidFees, roomClosed }

/// What the keep-my-room run did.
class KeepMyRoomOutcome extends Equatable {
  const KeepMyRoomOutcome({
    required this.offered,
    required this.skipped,
    required this.windowDays,
  });

  final int offered;
  final List<KeepSkip> skipped;
  final int windowDays;

  @override
  List<Object?> get props => [offered, skipped, windowDays];
}

/// A published version of the accommodation agreement.
class AgreementVersion extends Equatable {
  const AgreementVersion({
    required this.version,
    required this.publishedOn,
    required this.summary,
    this.isCurrent = false,
  });

  final int version;
  final DateTime publishedOn;
  final String summary;
  final bool isCurrent;

  @override
  List<Object?> get props => [version, publishedOn, summary, isCurrent];
}

/// The messages the housing office can reword.
enum NoticeKey { offerMade, deadlineNear, bedReleased, welcome }

/// The wording of one housing notice.
class HousingNoticeText extends Equatable {
  const HousingNoticeText({required this.key, required this.body});

  final NoticeKey key;
  final String body;

  @override
  List<Object?> get props => [key, body];
}

/// A housing category and the weight it carries in a priority draw.
class HousingCategory extends Equatable {
  const HousingCategory({
    required this.id,
    required this.name,
    required this.weight,
    required this.studentCount,
  });

  final String id;
  final String name;
  final int weight;
  final int studentCount;

  @override
  List<Object?> get props => [id, name, weight, studentCount];
}

/// A student barred from booking a bed.
class HousingBan extends Equatable {
  const HousingBan({
    required this.id,
    required this.studentName,
    required this.matricNumber,
    required this.reason,
    required this.since,
  });

  final String id;
  final String studentName;
  final String matricNumber;
  final String reason;
  final DateTime since;

  @override
  List<Object?> get props => [id, studentName, matricNumber, reason, since];
}

/// A student living in a hostel.
class Occupant extends Equatable {
  const Occupant({
    required this.hostelId,
    required this.studentName,
    required this.matricNumber,
    required this.roomLabel,
    required this.bedNumber,
    required this.state,
  });

  final String hostelId;
  final String studentName;
  final String matricNumber;
  final String roomLabel;
  final int bedNumber;
  final StaffAllocationState state;

  @override
  List<Object?> get props => [
    hostelId,
    studentName,
    matricNumber,
    roomLabel,
    bedNumber,
    state,
  ];
}

/// A student the housing office can look up by matric number.
class DirectoryStudent extends Equatable {
  const DirectoryStudent({
    required this.name,
    required this.matricNumber,
    required this.level,
    required this.programme,
  });

  final String name;
  final String matricNumber;
  final int level;
  final String programme;

  @override
  List<Object?> get props => [name, matricNumber, level, programme];
}

/// Everything the housing office screens start from.
class HousingLedger extends Equatable {
  const HousingLedger({
    required this.allocations,
    required this.hostels,
    required this.openings,
    required this.prices,
    required this.refundPolicy,
    required this.agreements,
    required this.notices,
    required this.categories,
    required this.bans,
    required this.occupants,
    required this.directory,
    required this.waitlistCount,
    required this.drawApplicants,
    required this.keepEligible,
  });

  final List<AllocationRecord> allocations;
  final List<Hostel> hostels;
  final List<TermOpening> openings;
  final List<RoomPrice> prices;
  final RefundPolicy refundPolicy;
  final List<AgreementVersion> agreements;
  final List<HousingNoticeText> notices;
  final List<HousingCategory> categories;
  final List<HousingBan> bans;
  final List<Occupant> occupants;
  final List<DirectoryStudent> directory;

  /// Students waiting for a bed.
  final int waitlistCount;

  /// Students entered in the draw.
  final int drawApplicants;

  /// Last term's residents who could be offered their own bed.
  final int keepEligible;

  @override
  List<Object?> get props => [
    allocations,
    hostels,
    openings,
    prices,
    refundPolicy,
    agreements,
    notices,
    categories,
    bans,
    occupants,
    directory,
    waitlistCount,
    drawApplicants,
    keepEligible,
  ];
}
