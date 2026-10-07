import 'package:equatable/equatable.dart';

/// The two terms a student books one at a time.
enum AccommodationTerm { first, second }

/// Where a student stands with the bed of one term.
///
/// The hub body switches on this, so a term is always in exactly one phase:
/// nothing scheduled yet, the agreement still to accept, rooms to choose
/// from, a bed held for payment, a waitlist offer, a confirmed bed, or a
/// resident checked in.
enum AllocationPhase {
  notScheduled,
  needsTerms,
  roomList,
  held,
  offered,
  confirmed,
  checkedIn,
}

/// How a past bed record ended.
enum HistoryOutcome { checkedOut, cancelledWithCharge, cancelled, expired }

/// Whether a room on the list can be booked.
enum RoomAvailability { open, singleSlot, kept, maintenance }

/// Result of looking a matric number up for a bed swap.
enum SwapLookupStatus { idle, found, notFound }

/// The signed-in student as the accommodation screens print them.
class AccommodationStudent extends Equatable {
  const AccommodationStudent({
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

/// One bed, down to the bed number.
class BedLocation extends Equatable {
  const BedLocation({
    required this.hostel,
    required this.block,
    required this.room,
    required this.bed,
    this.roomType = '',
    this.floor = '',
    this.wing = '',
  });

  final String hostel;
  final String block;
  final String room;
  final int bed;

  /// `2-Bed Room`; empty when the record does not say.
  final String roomType;

  /// `Ground floor`; empty when the record does not say.
  final String floor;

  /// `East Wing`; empty when the record does not say.
  final String wing;

  /// `Amina Hall · Block A`; the hostel and block names as recorded.
  String get hostelBlock => '$hostel · $block';

  BedLocation copyWith({String? room, int? bed}) {
    return BedLocation(
      hostel: hostel,
      block: block,
      room: room ?? this.room,
      bed: bed ?? this.bed,
      roomType: roomType,
      floor: floor,
      wing: wing,
    );
  }

  @override
  List<Object?> get props => [hostel, block, room, bed, roomType, floor, wing];
}

/// What a bed costs and how the invoice for it is referenced.
class AccommodationFee extends Equatable {
  const AccommodationFee({
    required this.amountMinorUnits,
    this.invoiceReference,
    this.isFree = false,
    this.coversSession = false,
  });

  /// Kobo.
  final int amountMinorUnits;

  /// `AC/2026/00142`; null until an invoice has been raised.
  final String? invoiceReference;

  /// A scholarship or quota bed that carries no fee.
  final bool isFree;

  /// One fee covers both terms of the session.
  final bool coversSession;

  @override
  List<Object?> get props => [
    amountMinorUnits,
    invoiceReference,
    isFree,
    coversSession,
  ];
}

/// A swap another student has proposed.
class SwapProposal extends Equatable {
  const SwapProposal({required this.location, required this.expiresOn});

  /// The bed the proposer holds, and would give up.
  final BedLocation location;
  final DateTime expiresOn;

  @override
  List<Object?> get props => [location, expiresOn];
}

/// A student found by matric number for a swap.
class SwapTarget extends Equatable {
  const SwapTarget({
    required this.name,
    required this.matricNumber,
    required this.location,
  });

  final String name;
  final String matricNumber;
  final BedLocation location;

  @override
  List<Object?> get props => [name, matricNumber, location];
}

/// The swap lookup the student has typed into the composer.
class SwapLookup extends Equatable {
  const SwapLookup({this.status = SwapLookupStatus.idle, this.target});

  final SwapLookupStatus status;
  final SwapTarget? target;

  @override
  List<Object?> get props => [status, target];
}

/// One room on the bookable list.
class BookableRoom extends Equatable {
  const BookableRoom({
    required this.id,
    required this.hostel,
    required this.block,
    required this.room,
    required this.floor,
    required this.freeBeds,
    required this.totalBeds,
    required this.priceMinorUnits,
    this.availability = RoomAvailability.open,
    this.reason = '',
    this.roomType = '',
  });

  final String id;
  final String hostel;
  final String block;
  final String room;
  final String floor;
  final int freeBeds;
  final int totalBeds;
  final int priceMinorUnits;
  final RoomAvailability availability;

  /// `Kept for Choir members` / `Closed: rewiring`.
  final String reason;
  final String roomType;

  bool get isBookable =>
      freeBeds > 0 &&
      (availability == RoomAvailability.open ||
          availability == RoomAvailability.singleSlot);

  String get hostelBlock => '$hostel · $block';

  /// The bed a booking is given: the first free one.
  BedLocation get nextBed => BedLocation(
    hostel: hostel,
    block: block,
    room: room,
    bed: totalBeds - freeBeds + 1,
    roomType: roomType,
    floor: floor,
  );

  @override
  List<Object?> get props => [
    id,
    hostel,
    block,
    room,
    floor,
    freeBeds,
    totalBeds,
    priceMinorUnits,
    availability,
    reason,
    roomType,
  ];
}

/// The bed (or the lack of one) a student has for one term.
class TermAccommodation extends Equatable {
  const TermAccommodation({
    required this.term,
    required this.label,
    required this.phase,
    this.bed,
    this.fee,
    this.deadline,
    this.graceUntil,
    this.bookedOn,
    this.checkInFrom,
    this.checkedInOn,
    this.termEndsOn,
    this.slipCode,
    this.keyTag,
    this.locker,
    this.offerReference,
    this.swap,
    this.rooms = const [],
    this.source = '',
  });

  final AccommodationTerm term;

  /// `2026/2027-1`.
  final String label;
  final AllocationPhase phase;
  final BedLocation? bed;
  final AccommodationFee? fee;

  /// Pay-by (held) or answer-by (offered).
  final DateTime? deadline;

  /// A late fee still confirms the bed until this moment.
  final DateTime? graceUntil;
  final DateTime? bookedOn;
  final DateTime? checkInFrom;
  final DateTime? checkedInOn;
  final DateTime? termEndsOn;
  final String? slipCode;
  final String? keyTag;
  final String? locker;
  final String? offerReference;
  final SwapProposal? swap;
  final List<BookableRoom> rooms;

  /// How the bed came to the student: `Allocated via ballot`.
  final String source;

  bool get hasBed => bed != null;

  bool get isFree => fee?.isFree ?? false;

  TermAccommodation copyWith({
    AllocationPhase? phase,
    BedLocation? bed,
    bool clearBed = false,
    AccommodationFee? fee,
    bool clearFee = false,
    DateTime? deadline,
    bool clearDeadline = false,
    DateTime? graceUntil,
    bool clearGrace = false,
    DateTime? bookedOn,
    bool clearBookedOn = false,
    SwapProposal? swap,
    bool clearSwap = false,
    List<BookableRoom>? rooms,
    String? offerReference,
    bool clearOfferReference = false,
  }) {
    return TermAccommodation(
      term: term,
      label: label,
      phase: phase ?? this.phase,
      bed: clearBed ? null : bed ?? this.bed,
      fee: clearFee ? null : fee ?? this.fee,
      deadline: clearDeadline ? null : deadline ?? this.deadline,
      graceUntil: clearGrace ? null : graceUntil ?? this.graceUntil,
      bookedOn: clearBookedOn ? null : bookedOn ?? this.bookedOn,
      checkInFrom: checkInFrom,
      checkedInOn: checkedInOn,
      termEndsOn: termEndsOn,
      slipCode: slipCode,
      keyTag: keyTag,
      locker: locker,
      offerReference: clearOfferReference
          ? null
          : offerReference ?? this.offerReference,
      swap: clearSwap ? null : swap ?? this.swap,
      rooms: rooms ?? this.rooms,
      source: source,
    );
  }

  @override
  List<Object?> get props => [
    term,
    label,
    phase,
    bed,
    fee,
    deadline,
    graceUntil,
    bookedOn,
    checkInFrom,
    checkedInOn,
    termEndsOn,
    slipCode,
    keyTag,
    locker,
    offerReference,
    swap,
    rooms,
    source,
  ];
}

/// One numbered covenant of the accommodation agreement.
class AgreementClause extends Equatable {
  const AgreementClause({
    required this.title,
    required this.body,
    this.isLoadBearing = false,
  });

  final String title;
  final String body;

  /// The clause that triggers forfeiture; drawn with a warning.
  final bool isLoadBearing;

  @override
  List<Object?> get props => [title, body, isLoadBearing];
}

/// The agreement version a student accepts before booking.
class AccommodationAgreement extends Equatable {
  const AccommodationAgreement({
    required this.version,
    required this.clauses,
    required this.reference,
  });

  final String version;
  final List<AgreementClause> clauses;

  /// `2026-TERMS-D1`.
  final String reference;

  @override
  List<Object?> get props => [version, clauses, reference];
}

/// One past bed record.
class HistoryRecord extends Equatable {
  const HistoryRecord({
    required this.id,
    required this.location,
    required this.sessionLabel,
    required this.outcome,
    required this.note,
    this.invoiceReference,
  });

  final String id;
  final BedLocation location;

  /// `2025/2026-2`.
  final String sessionLabel;
  final HistoryOutcome outcome;
  final String note;
  final String? invoiceReference;

  @override
  List<Object?> get props => [
    id,
    location,
    sessionLabel,
    outcome,
    note,
    invoiceReference,
  ];
}

/// Everything the accommodation portal reads for one student.
class AccommodationLedger extends Equatable {
  const AccommodationLedger({
    required this.student,
    required this.sessionLabel,
    required this.now,
    required this.terms,
    required this.agreement,
    required this.history,
    this.swapTargets = const [],
  });

  final AccommodationStudent student;

  /// `2026/2027`.
  final String sessionLabel;

  /// The clock the screens count down against.
  final DateTime now;
  final List<TermAccommodation> terms;
  final AccommodationAgreement agreement;
  final List<HistoryRecord> history;

  /// Students a swap lookup can find.
  final List<SwapTarget> swapTargets;

  @override
  List<Object?> get props => [
    student,
    sessionLabel,
    now,
    terms,
    agreement,
    history,
    swapTargets,
  ];
}
