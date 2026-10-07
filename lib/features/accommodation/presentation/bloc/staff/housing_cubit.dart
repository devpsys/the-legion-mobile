import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mock/staff/housing_fixtures.dart';
import '../../models/accommodation_models.dart';
import '../../models/staff/housing_models.dart';
import 'housing_state.dart';

/// Drives the housing office screens: the allocations queue, hostels and
/// rooms, openings and prices, the allocation tools (spreadsheet, by hand,
/// automatic, draw, keep-my-room) and the agreement, notices, categories,
/// bans and refunds.
///
/// Presentation only — fixtures until the housing endpoints land. The ledger
/// is injected so tests can start the office from any shape of data.
class HousingCubit extends Cubit<HousingState> {
  HousingCubit({HousingLedger? ledger})
    : _ledger = ledger ?? HousingFixtures.ledger,
      super(const HousingState());

  final HousingLedger _ledger;

  /// Residents the keep-my-room run cannot offer their own bed back.
  static const List<KeepSkip> keepSkips = [
    KeepSkip(studentName: 'Tunde Bakare', reason: KeepSkipReason.banned),
    KeepSkip(studentName: 'Kelechi Obi', reason: KeepSkipReason.unpaidFees),
    KeepSkip(studentName: 'Maryam Lawal', reason: KeepSkipReason.roomClosed),
  ];

  int _batches = 42;
  int _draws = 7;

  void load() {
    if (state.status == HousingStatus.ready) return;
    emit(state.copyWith(status: HousingStatus.loading, clearFailure: true));
    emit(
      state.copyWith(
        status: HousingStatus.ready,
        allocations: _ledger.allocations,
        hostels: _ledger.hostels,
        openings: _ledger.openings,
        prices: _ledger.prices,
        refundPolicy: _ledger.refundPolicy,
        agreements: _ledger.agreements,
        notices: _ledger.notices,
        categories: _ledger.categories,
        bans: _ledger.bans,
        occupants: _ledger.occupants,
        directory: _ledger.directory,
        waitlistCount: _ledger.waitlistCount,
        drawApplicants: _ledger.drawApplicants,
        keepEligible: _ledger.keepEligible,
        clearFailure: true,
      ),
    );
  }

  void clearNotice() => emit(state.copyWith(clearNotice: true));

  void setFilter(AllocationQueueFilter filter) {
    if (state.filter == filter) return;
    emit(state.copyWith(filter: filter));
  }

  /// Cancels a held, offered or confirmed allocation and frees its bed.
  void cancelAllocation(String id) {
    final record = state.allocationById(id);
    if (record == null || record.state == StaffAllocationState.cancelled) {
      return;
    }
    emit(
      state.copyWith(
        allocations: [
          for (final entry in state.allocations)
            entry.id == id
                ? entry.copyWith(state: StaffAllocationState.cancelled)
                : entry,
        ],
        hostels: [
          for (final hostel in state.hostels)
            hostel.name == record.bed.hostel
                ? _setBed(hostel, record.bed, BedState.free, null)
                : hostel,
        ],
        notice: HousingNotice.allocationCancelled,
      ),
    );
  }

  Hostel _setBed(
    Hostel hostel,
    BedLocation location,
    BedState bedState,
    String? occupant,
  ) {
    return hostel.copyWith(
      rooms: [
        for (final room in hostel.rooms)
          room.number == location.room &&
                  hostel.blockById(room.blockId)?.name == location.block
              ? HousingRoom(
                  id: room.id,
                  blockId: room.blockId,
                  number: room.number,
                  floor: room.floor,
                  roomType: room.roomType,
                  status: room.status,
                  beds: [
                    for (final bed in room.beds)
                      bed.number == location.bed
                          ? HousingBed(
                              number: bed.number,
                              state: bedState,
                              occupant: occupant,
                            )
                          : bed,
                  ],
                )
              : room,
      ],
    );
  }

  /// Gives [matricNumber] the bed [bedNumber] of [roomId] in [hostelId].
  ///
  /// The outcome is reported through [HousingState.handOutcome]: an unknown
  /// matric number, a banned student and a bed that is not free are each
  /// refused without changing anything.
  void allocateByHand({
    required String matricNumber,
    required String hostelId,
    required String roomId,
    required int bedNumber,
  }) {
    final matric = matricNumber.trim().toUpperCase();
    DirectoryStudent? student;
    for (final entry in state.directory) {
      if (entry.matricNumber.toUpperCase() == matric) student = entry;
    }
    if (student == null) {
      emit(
        state.copyWith(
          handOutcome: const HandAllocationOutcome(
            status: HandAllocationStatus.unknownStudent,
          ),
        ),
      );
      return;
    }
    if (state.bans.any((ban) => ban.matricNumber.toUpperCase() == matric)) {
      emit(
        state.copyWith(
          handOutcome: HandAllocationOutcome(
            status: HandAllocationStatus.studentBanned,
            studentName: student.name,
          ),
        ),
      );
      return;
    }
    final hostel = state.hostelById(hostelId);
    final room = hostel?.roomById(roomId);
    HousingBed? bed;
    for (final entry in room?.beds ?? const <HousingBed>[]) {
      if (entry.number == bedNumber) bed = entry;
    }
    if (hostel == null ||
        room == null ||
        room.status != RoomStatus.open ||
        bed == null ||
        bed.state != BedState.free) {
      emit(
        state.copyWith(
          handOutcome: HandAllocationOutcome(
            status: HandAllocationStatus.bedTaken,
            studentName: student.name,
          ),
        ),
      );
      return;
    }
    final block = hostel.blockById(room.blockId);
    final location = BedLocation(
      hostel: hostel.name,
      block: block?.name ?? '',
      room: room.number,
      bed: bedNumber,
      roomType: room.roomType,
      floor: room.floor,
    );
    final price = state.prices.where((p) => p.roomType == room.roomType);
    final record = AllocationRecord(
      id: 'al-${1000 + state.allocations.length + 1}',
      studentName: student.name,
      matricNumber: student.matricNumber,
      level: student.level,
      programme: student.programme,
      bed: location,
      termLabel: HousingFixtures.firstTerm,
      state: StaffAllocationState.confirmed,
      feeMinorUnits: price.isEmpty ? 0 : price.first.minorUnits,
      method: AllocationMethod.byHand,
      createdOn: HousingFixtures.now,
    );
    emit(
      state.copyWith(
        allocations: [record, ...state.allocations],
        hostels: [
          for (final entry in state.hostels)
            entry.id == hostelId
                ? _setBed(entry, location, BedState.taken, student.name)
                : entry,
        ],
        occupants: [
          ...state.occupants,
          Occupant(
            hostelId: hostelId,
            studentName: student.name,
            matricNumber: student.matricNumber,
            roomLabel: '${location.block} · ${room.number}',
            bedNumber: bedNumber,
            state: StaffAllocationState.confirmed,
          ),
        ],
        handOutcome: HandAllocationOutcome(
          status: HandAllocationStatus.allocated,
          studentName: student.name,
          bed: location,
        ),
      ),
    );
  }

  void resetHandOutcome() =>
      emit(state.copyWith(handOutcome: const HandAllocationOutcome()));

  /// Places the waitlist into the beds that are free.
  void runAutoAllocation() {
    final free = state.freeBedTotal;
    final placed = state.waitlistCount < free ? state.waitlistCount : free;
    emit(
      state.copyWith(
        waitlistCount: state.waitlistCount - placed,
        autoOutcome: AutoAllocationOutcome(
          placed: placed,
          unplaced: state.waitlistCount - placed,
          freeBedsLeft: free - placed,
        ),
        notice: HousingNotice.autoRun,
      ),
    );
  }

  /// Runs the draw for [seats] beds (never more than are free).
  void runDraw({required DrawMethod method, required int seats}) {
    final free = state.freeBedTotal;
    final usable = seats < free ? seats : free;
    final winners = state.drawApplicants < usable
        ? state.drawApplicants
        : usable;
    _draws += 1;
    emit(
      state.copyWith(
        drawOutcome: DrawOutcome(
          method: method,
          applicants: state.drawApplicants,
          seats: usable,
          winners: winners,
          reference: 'DRAW-2026-${_draws.toString().padLeft(4, '0')}',
        ),
        drawApplicants: state.drawApplicants - winners,
        notice: HousingNotice.drawRun,
      ),
    );
  }

  /// Offers last term's residents their own beds, for [windowDays] days.
  void sendKeepMyRoom({required int windowDays}) {
    emit(
      state.copyWith(
        keepOutcome: KeepMyRoomOutcome(
          offered: state.keepEligible - keepSkips.length,
          skipped: keepSkips,
          windowDays: windowDays,
        ),
        notice: HousingNotice.keepSent,
      ),
    );
  }

  /// Reads one of the demo sample files.
  void uploadSample(UploadSample sample) {
    _batches += 1;
    final outcome = HousingFixtures.upload(
      sample,
      batch: 'BATCH-2026-${_batches.toString().padLeft(4, '0')}',
    );
    emit(
      state.copyWith(
        upload: outcome,
        notice: outcome.status == UploadStatus.success
            ? HousingNotice.uploadDone
            : null,
        clearNotice: outcome.status != UploadStatus.success,
      ),
    );
  }

  void resetUpload() => emit(state.copyWith(upload: const UploadOutcome()));

  void updateRoom({
    required String hostelId,
    required String roomId,
    required RoomStatus status,
    required String roomType,
  }) {
    emit(
      state.copyWith(
        hostels: [
          for (final hostel in state.hostels)
            hostel.id == hostelId
                ? hostel.copyWith(
                    rooms: [
                      for (final room in hostel.rooms)
                        room.id == roomId
                            ? room.copyWith(status: status, roomType: roomType)
                            : room,
                    ],
                  )
                : hostel,
        ],
        notice: HousingNotice.roomSaved,
      ),
    );
  }

  /// Adds rooms numbered [from]..[to] to a block, skipping numbers it has.
  void addRooms({
    required String hostelId,
    required String blockId,
    required int from,
    required int to,
    required String roomType,
    required int bedsPerRoom,
  }) {
    if (to < from || bedsPerRoom < 1) return;
    emit(
      state.copyWith(
        hostels: [
          for (final hostel in state.hostels)
            hostel.id == hostelId
                ? hostel.copyWith(
                    rooms: [
                      ...hostel.rooms,
                      for (var n = from; n <= to; n++)
                        if (!hostel.rooms.any(
                          (room) =>
                              room.blockId == blockId &&
                              room.number == n.toString(),
                        ))
                          HousingRoom(
                            id: '$blockId-$n',
                            blockId: blockId,
                            number: n.toString(),
                            floor: '',
                            roomType: roomType,
                            status: RoomStatus.open,
                            beds: [
                              for (var bed = 1; bed <= bedsPerRoom; bed++)
                                HousingBed(number: bed, state: BedState.free),
                            ],
                          ),
                    ],
                  )
                : hostel,
        ],
        notice: HousingNotice.roomsAdded,
      ),
    );
  }

  void setOpeningMethod(String termLabel, BookingMethod method) {
    emit(
      state.copyWith(
        openings: [
          for (final opening in state.openings)
            opening.termLabel == termLabel
                ? opening.copyWith(method: method)
                : opening,
        ],
        notice: HousingNotice.openingSaved,
      ),
    );
  }

  void setPrice(String roomType, int minorUnits) {
    emit(
      state.copyWith(
        prices: [
          for (final price in state.prices)
            price.roomType == roomType
                ? RoomPrice(roomType: roomType, minorUnits: minorUnits)
                : price,
        ],
        notice: HousingNotice.priceSaved,
      ),
    );
  }

  /// Publishes the next version of the agreement; students accept it afresh.
  void publishAgreement(String summary) {
    final latest = state.agreements.isEmpty
        ? 0
        : state.agreements.first.version;
    emit(
      state.copyWith(
        agreements: [
          AgreementVersion(
            version: latest + 1,
            publishedOn: HousingFixtures.now,
            summary: summary.trim(),
            isCurrent: true,
          ),
          for (final entry in state.agreements)
            AgreementVersion(
              version: entry.version,
              publishedOn: entry.publishedOn,
              summary: entry.summary,
            ),
        ],
        notice: HousingNotice.agreementPublished,
      ),
    );
  }

  void saveNotice(NoticeKey key, String body) {
    emit(
      state.copyWith(
        notices: [
          for (final entry in state.notices)
            entry.key == key
                ? HousingNoticeText(key: key, body: body.trim())
                : entry,
        ],
        notice: HousingNotice.noticeSaved,
      ),
    );
  }

  void addCategory({required String name, required int weight}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    emit(
      state.copyWith(
        categories: [
          ...state.categories,
          HousingCategory(
            id: 'cat-${state.categories.length + 1}',
            name: trimmed,
            weight: weight,
            studentCount: 0,
          ),
        ],
        notice: HousingNotice.categorySaved,
      ),
    );
  }

  void removeCategory(String id) {
    emit(
      state.copyWith(
        categories: [
          for (final entry in state.categories)
            if (entry.id != id) entry,
        ],
        notice: HousingNotice.categoryRemoved,
      ),
    );
  }

  /// Bans the student with [matricNumber]; false when they are unknown or
  /// already banned.
  bool addBan({required String matricNumber, required String reason}) {
    final matric = matricNumber.trim().toUpperCase();
    DirectoryStudent? student;
    for (final entry in state.directory) {
      if (entry.matricNumber.toUpperCase() == matric) student = entry;
    }
    if (student == null ||
        state.bans.any((ban) => ban.matricNumber.toUpperCase() == matric)) {
      return false;
    }
    emit(
      state.copyWith(
        bans: [
          HousingBan(
            id: 'ban-${state.bans.length + 1}',
            studentName: student.name,
            matricNumber: student.matricNumber,
            reason: reason.trim(),
            since: HousingFixtures.now,
          ),
          ...state.bans,
        ],
        notice: HousingNotice.banAdded,
      ),
    );
    return true;
  }

  void liftBan(String id) {
    emit(
      state.copyWith(
        bans: [
          for (final ban in state.bans)
            if (ban.id != id) ban,
        ],
        notice: HousingNotice.banLifted,
      ),
    );
  }

  void setRefundPolicy({required int sharePercent, required int windowDays}) {
    emit(
      state.copyWith(
        refundPolicy: RefundPolicy(
          sharePercent: sharePercent.clamp(0, 100),
          windowDays: windowDays < 0 ? 0 : windowDays,
        ),
        notice: HousingNotice.refundSaved,
      ),
    );
  }

  /// What cancelling [daysBeforeCheckIn] days out would hand back from a
  /// fee of [paidMinorUnits] under the current policy.
  void simulateRefund({
    required int paidMinorUnits,
    required int daysBeforeCheckIn,
  }) {
    final policy = state.refundPolicy;
    final refund = daysBeforeCheckIn >= policy.windowDays
        ? paidMinorUnits * policy.sharePercent ~/ 100
        : 0;
    emit(
      state.copyWith(
        refundSimulation: RefundSimulation(
          paidMinorUnits: paidMinorUnits,
          daysBeforeCheckIn: daysBeforeCheckIn,
          refundMinorUnits: refund,
        ),
      ),
    );
  }
}
