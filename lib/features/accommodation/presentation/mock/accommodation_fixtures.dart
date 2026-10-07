import '../models/accommodation_models.dart';

/// Sample content for the student Accommodation screens.
///
/// Presentation-only placeholders: delete this file once the housing
/// endpoints exist and feed the models from a repository. The student, the
/// beds and the invoices are invented for the mock, in the shapes the designs
/// under `ui-designs/accommodation/` draw. The default [ledger] is Amaka Bello
/// holding a bed in the first term (awaiting payment) and holding a waitlist
/// offer for the second.
abstract final class AccommodationFixtures {
  static const String session = '2026/2027';
  static const String firstTermLabel = '2026/2027-1';
  static const String secondTermLabel = '2026/2027-2';

  /// The moment the screens count down from: 41 hours and 20 minutes before
  /// the held bed's payment deadline.
  static final DateTime now = DateTime(2026, 10, 8, 6, 39);

  static const AccommodationStudent student = AccommodationStudent(
    name: 'Amaka Bello',
    matricNumber: '25/CSC/0101',
    level: 200,
    programme: 'Computer Science',
  );

  static const int bedFeeMinorUnits = 7500000;

  static const BedLocation heldBed = BedLocation(
    hostel: 'Amina Hall',
    block: 'Block A',
    room: '104',
    bed: 2,
    roomType: '2-Bed Room',
    floor: 'Ground floor',
    wing: 'East Wing',
  );

  static const BedLocation offeredBed = BedLocation(
    hostel: 'Amina Hall',
    block: 'Block A',
    room: '106',
    bed: 3,
    roomType: '4-Bed Room',
    floor: 'Ground floor',
    wing: 'East Wing',
  );

  static const BedLocation swapProposerBed = BedLocation(
    hostel: 'Amina Hall',
    block: 'Block A',
    room: '104',
    bed: 1,
    roomType: '2-Bed Room',
    floor: 'Ground floor',
    wing: 'East Wing',
  );

  static const List<SwapTarget> swapTargets = [
    SwapTarget(
      name: 'Bello, Fatima O.',
      matricNumber: '25/CSC/0202',
      location: BedLocation(
        hostel: 'Amina Hall',
        block: 'Block B',
        room: '201',
        bed: 1,
        roomType: '4-Bed Room',
        floor: 'First floor',
      ),
    ),
  ];

  static const List<AgreementClause> clauses = [
    AgreementClause(
      title: 'Exclusive personal tenancy',
      body:
          'The room is for your personal use only for the semester you book. '
          'You may not sublet it, move rooms or let anyone else stay in it.',
    ),
    AgreementClause(
      title: 'Lapse condition and payment window',
      body:
          'Your booking holds the bed until the accommodation fee is paid. If '
          "it isn't paid by the deadline shown, the bed is released and the "
          'booking lapses.',
      isLoadBearing: true,
    ),
    AgreementClause(
      title: 'Inventory and asset custody',
      body:
          'You are responsible for the room and its fittings. Damage beyond '
          'fair wear is charged to you.',
    ),
    AgreementClause(
      title: 'Safety prohibitions and guest conduct',
      body:
          'Cooking appliances, candles and open flames are not allowed in '
          'rooms. Visitors of the opposite sex are not allowed in rooms.',
    ),
    AgreementClause(
      title: 'Right of entry and safeguarding',
      body:
          'Hall officers may inspect rooms with notice, and at any time in an '
          'emergency.',
    ),
    AgreementClause(
      title: 'Disciplinary sanctions and forfeiture',
      body:
          'Breaking hostel rules may lead to loss of accommodation and '
          'disciplinary action, without refund of the fee.',
    ),
  ];

  static const AccommodationAgreement agreement = AccommodationAgreement(
    version: '2026.1',
    clauses: clauses,
    reference: '2026-TERMS-D1',
  );

  static const List<BookableRoom> rooms = [
    BookableRoom(
      id: 'room-a-104',
      hostel: 'Amina Hall',
      block: 'Block A',
      room: '104',
      floor: 'Ground floor',
      freeBeds: 3,
      totalBeds: 4,
      priceMinorUnits: bedFeeMinorUnits,
      roomType: '4-Bed Room',
    ),
    BookableRoom(
      id: 'room-a-105',
      hostel: 'Amina Hall',
      block: 'Block A',
      room: '105',
      floor: 'First floor',
      freeBeds: 1,
      totalBeds: 4,
      priceMinorUnits: bedFeeMinorUnits,
      availability: RoomAvailability.singleSlot,
      roomType: '4-Bed Room',
    ),
    BookableRoom(
      id: 'room-a-108',
      hostel: 'Amina Hall',
      block: 'Block A',
      room: '108',
      floor: 'First floor',
      freeBeds: 0,
      totalBeds: 4,
      priceMinorUnits: bedFeeMinorUnits,
      availability: RoomAvailability.kept,
      reason: 'Kept for Choir members',
      roomType: '4-Bed Room',
    ),
    BookableRoom(
      id: 'room-a-112',
      hostel: 'Amina Hall',
      block: 'Block A',
      room: '112',
      floor: 'Ground floor',
      freeBeds: 0,
      totalBeds: 4,
      priceMinorUnits: bedFeeMinorUnits,
      availability: RoomAvailability.maintenance,
      reason: 'Closed: rewiring',
      roomType: '4-Bed Room',
    ),
  ];

  static final List<HistoryRecord> history = [
    const HistoryRecord(
      id: 'hist-2025-2',
      location: BedLocation(
        hostel: 'Amina Hall',
        block: 'Block A',
        room: '104',
        bed: 2,
      ),
      sessionLabel: '2025/2026-2',
      outcome: HistoryOutcome.checkedOut,
      note: 'Checked out, for the end of 2025/2026-2',
    ),
    const HistoryRecord(
      id: 'hist-2025-1',
      location: BedLocation(
        hostel: 'Amina Hall',
        block: 'Block A',
        room: '104',
        bed: 2,
      ),
      sessionLabel: '2025/2026-1',
      outcome: HistoryOutcome.checkedOut,
      note: 'Checked out, for the end of 2025/2026-1',
    ),
    const HistoryRecord(
      id: 'hist-2024-2',
      location: BedLocation(
        hostel: 'Kofo Hall',
        block: 'Block B',
        room: '208',
        bed: 1,
      ),
      sessionLabel: '2024/2025-2',
      outcome: HistoryOutcome.cancelledWithCharge,
      note: 'The accommodation fee was not paid in time.',
    ),
    const HistoryRecord(
      id: 'hist-2024-1',
      location: BedLocation(
        hostel: 'Kofo Hall',
        block: 'Block B',
        room: '208',
        bed: 1,
      ),
      sessionLabel: '2024/2025-1',
      outcome: HistoryOutcome.cancelled,
      note: 'Accommodation cancelled: student requested',
    ),
    const HistoryRecord(
      id: 'hist-2023-2',
      location: BedLocation(
        hostel: 'Moremi Hall',
        block: 'Block C',
        room: '112',
        bed: 4,
      ),
      sessionLabel: '2023/2024-2',
      outcome: HistoryOutcome.expired,
      note: 'Invoice AC/2026/00142 was cancelled.',
      invoiceReference: 'AC/2026/00142',
    ),
    const HistoryRecord(
      id: 'hist-2023-1',
      location: BedLocation(
        hostel: 'Moremi Hall',
        block: 'Block C',
        room: '112',
        bed: 4,
      ),
      sessionLabel: '2023/2024-1',
      outcome: HistoryOutcome.checkedOut,
      note: 'Checked out, for the end of 2023/2024-1',
    ),
  ];

  // --- Terms ---------------------------------------------------------------

  static final TermAccommodation heldFirstTerm = TermAccommodation(
    term: AccommodationTerm.first,
    label: firstTermLabel,
    phase: AllocationPhase.held,
    bed: heldBed,
    fee: const AccommodationFee(
      amountMinorUnits: bedFeeMinorUnits,
      invoiceReference: 'AC/2026/00142',
    ),
    deadline: DateTime(2026, 10, 9, 23, 59),
    graceUntil: DateTime(2026, 10, 12, 23, 59),
    bookedOn: DateTime(2026, 10, 6),
    checkInFrom: DateTime(2026, 10, 20),
    termEndsOn: DateTime(2027, 2, 28),
    swap: SwapProposal(
      location: swapProposerBed,
      expiresOn: DateTime(2026, 10, 8, 9, 14),
    ),
    source: 'Student selection',
  );

  static final TermAccommodation offeredSecondTerm = TermAccommodation(
    term: AccommodationTerm.second,
    label: secondTermLabel,
    phase: AllocationPhase.offered,
    bed: offeredBed,
    fee: const AccommodationFee(amountMinorUnits: bedFeeMinorUnits),
    deadline: DateTime(2026, 10, 10, 5, 51),
    offerReference: 'WL-8921',
    source: 'Waitlist',
  );

  static TermAccommodation notScheduled(AccommodationTerm term, String label) =>
      TermAccommodation(
        term: term,
        label: label,
        phase: AllocationPhase.notScheduled,
      );

  static TermAccommodation needsTerms(AccommodationTerm term, String label) =>
      TermAccommodation(
        term: term,
        label: label,
        phase: AllocationPhase.needsTerms,
      );

  static TermAccommodation roomList(AccommodationTerm term, String label) =>
      TermAccommodation(
        term: term,
        label: label,
        phase: AllocationPhase.roomList,
        rooms: rooms,
      );

  static final TermAccommodation confirmedFirstTerm = TermAccommodation(
    term: AccommodationTerm.first,
    label: firstTermLabel,
    phase: AllocationPhase.confirmed,
    bed: heldBed,
    fee: const AccommodationFee(
      amountMinorUnits: bedFeeMinorUnits,
      invoiceReference: 'AC/2026/00142',
    ),
    bookedOn: DateTime(2026, 10, 6),
    checkInFrom: DateTime(2026, 10, 20),
    termEndsOn: DateTime(2027, 2, 28),
    slipCode: '7KQ2M4XB9PTRWCDN',
    source: 'Student selection',
  );

  static final TermAccommodation freeFirstTerm = TermAccommodation(
    term: AccommodationTerm.first,
    label: firstTermLabel,
    phase: AllocationPhase.confirmed,
    bed: heldBed,
    fee: const AccommodationFee(amountMinorUnits: 0, isFree: true),
    bookedOn: DateTime(2026, 10, 6),
    checkInFrom: DateTime(2026, 10, 20),
    termEndsOn: DateTime(2027, 2, 28),
    slipCode: '7KQ2M4XB9PTRWCDN',
    source: 'Scholarship quota',
  );

  static final TermAccommodation checkedInFirstTerm = TermAccommodation(
    term: AccommodationTerm.first,
    label: firstTermLabel,
    phase: AllocationPhase.checkedIn,
    bed: heldBed,
    fee: const AccommodationFee(
      amountMinorUnits: bedFeeMinorUnits,
      invoiceReference: 'AC/2026/00142',
    ),
    bookedOn: DateTime(2026, 10, 6),
    checkInFrom: DateTime(2026, 10, 8),
    checkedInOn: DateTime(2026, 10, 8, 11, 20),
    termEndsOn: DateTime(2027, 2, 28),
    slipCode: '7KQ2M4XB9PTRWCDN',
    keyTag: '#A-104-B2',
    locker: 'Wardrobe #2',
    source: 'Student selection',
  );

  // --- Ledgers --------------------------------------------------------------

  static AccommodationLedger _ledger(
    TermAccommodation first,
    TermAccommodation second, {
    List<HistoryRecord>? records,
  }) => AccommodationLedger(
    student: student,
    sessionLabel: session,
    now: now,
    terms: [first, second],
    agreement: agreement,
    history: records ?? history,
    swapTargets: swapTargets,
  );

  /// The default: a held bed in term 1, a waitlist offer in term 2.
  static final AccommodationLedger ledger = _ledger(
    heldFirstTerm,
    offeredSecondTerm,
  );

  /// Nothing scheduled for either term.
  static final AccommodationLedger notScheduledLedger = _ledger(
    notScheduled(AccommodationTerm.first, firstTermLabel),
    notScheduled(AccommodationTerm.second, secondTermLabel),
  );

  /// Booking is open but the agreement has not been accepted.
  static final AccommodationLedger needsTermsLedger = _ledger(
    needsTerms(AccommodationTerm.first, firstTermLabel),
    notScheduled(AccommodationTerm.second, secondTermLabel),
  );

  /// Booking is open and the agreement is accepted.
  static final AccommodationLedger roomListLedger = _ledger(
    roomList(AccommodationTerm.first, firstTermLabel),
    notScheduled(AccommodationTerm.second, secondTermLabel),
  );

  /// A confirmed, paid bed.
  static final AccommodationLedger confirmedLedger = _ledger(
    confirmedFirstTerm,
    notScheduled(AccommodationTerm.second, secondTermLabel),
  );

  /// A confirmed bed with no fee (scholarship quota).
  static final AccommodationLedger freeBedLedger = _ledger(
    freeFirstTerm,
    notScheduled(AccommodationTerm.second, secondTermLabel),
  );

  /// A resident, checked in.
  static final AccommodationLedger checkedInLedger = _ledger(
    checkedInFirstTerm,
    notScheduled(AccommodationTerm.second, secondTermLabel),
  );

  /// A first-year student with no past beds.
  static final AccommodationLedger noHistoryLedger = _ledger(
    heldFirstTerm,
    offeredSecondTerm,
    records: const [],
  );

  /// Held bed whose fee covers both terms of the session.
  static final AccommodationLedger sessionHeldLedger = _ledger(
    heldFirstTerm.copyWith(
      fee: const AccommodationFee(
        amountMinorUnits: bedFeeMinorUnits,
        invoiceReference: 'AC/2026/00142',
        coversSession: true,
      ),
    ),
    notScheduled(AccommodationTerm.second, secondTermLabel),
  );

  /// Every student preview ledger the debug menu can load.
  static AccommodationLedger ledgerFor(AccommodationPreviewScenario scenario) {
    return switch (scenario) {
      AccommodationPreviewScenario.heldAndOffer => ledger,
      AccommodationPreviewScenario.notScheduled => notScheduledLedger,
      AccommodationPreviewScenario.needsTerms => needsTermsLedger,
      AccommodationPreviewScenario.roomList => roomListLedger,
      AccommodationPreviewScenario.confirmed => confirmedLedger,
      AccommodationPreviewScenario.freeBed => freeBedLedger,
      AccommodationPreviewScenario.checkedIn => checkedInLedger,
      AccommodationPreviewScenario.sessionHeld => sessionHeldLedger,
      AccommodationPreviewScenario.noHistory => noHistoryLedger,
    };
  }
}

/// Fixture ledgers the student Accommodation debug menu can switch between.
enum AccommodationPreviewScenario {
  /// Term 1 held (with swap); term 2 waitlist offer.
  heldAndOffer,

  /// Neither term is open for booking yet.
  notScheduled,

  /// Agreement still to accept before rooms open.
  needsTerms,

  /// Booking open; pick a room.
  roomList,

  /// Confirmed paid bed.
  confirmed,

  /// Confirmed scholarship / free bed.
  freeBed,

  /// Checked-in resident.
  checkedIn,

  /// Held bed with a session-wide fee.
  sessionHeld,

  /// Same as held, but the history tab is empty.
  noHistory,
}
