import 'package:equatable/equatable.dart';

import '../../models/staff/housing_models.dart';

/// Loading status of the housing office screens.
enum HousingStatus { initial, loading, ready, failure }

/// One-off outcome the screen tells the officer about, then clears.
enum HousingNotice {
  allocationCancelled,
  roomSaved,
  roomsAdded,
  agreementPublished,
  noticeSaved,
  categorySaved,
  categoryRemoved,
  banAdded,
  banLifted,
  refundSaved,
  priceSaved,
  openingSaved,
  drawRun,
  autoRun,
  keepSent,
  uploadDone,
}

/// State of the housing office screens.
class HousingState extends Equatable {
  const HousingState({
    this.status = HousingStatus.initial,
    this.allocations = const [],
    this.filter = AllocationQueueFilter.all,
    this.hostels = const [],
    this.openings = const [],
    this.prices = const [],
    this.refundPolicy = const RefundPolicy(sharePercent: 0, windowDays: 0),
    this.refundSimulation,
    this.agreements = const [],
    this.notices = const [],
    this.categories = const [],
    this.bans = const [],
    this.occupants = const [],
    this.directory = const [],
    this.waitlistCount = 0,
    this.drawApplicants = 0,
    this.keepEligible = 0,
    this.upload = const UploadOutcome(),
    this.handOutcome = const HandAllocationOutcome(),
    this.autoOutcome,
    this.drawOutcome,
    this.keepOutcome,
    this.notice,
    this.failureMessage,
  });

  final HousingStatus status;
  final List<AllocationRecord> allocations;
  final AllocationQueueFilter filter;
  final List<Hostel> hostels;
  final List<TermOpening> openings;
  final List<RoomPrice> prices;
  final RefundPolicy refundPolicy;
  final RefundSimulation? refundSimulation;
  final List<AgreementVersion> agreements;
  final List<HousingNoticeText> notices;
  final List<HousingCategory> categories;
  final List<HousingBan> bans;
  final List<Occupant> occupants;
  final List<DirectoryStudent> directory;
  final int waitlistCount;
  final int drawApplicants;
  final int keepEligible;
  final UploadOutcome upload;
  final HandAllocationOutcome handOutcome;
  final AutoAllocationOutcome? autoOutcome;
  final DrawOutcome? drawOutcome;
  final KeepMyRoomOutcome? keepOutcome;
  final HousingNotice? notice;
  final String? failureMessage;

  /// The queue under the active filter, newest first.
  List<AllocationRecord> get visibleAllocations {
    final matching = allocations.where((record) {
      return switch (filter) {
        AllocationQueueFilter.all => true,
        AllocationQueueFilter.held => record.state == StaffAllocationState.held,
        AllocationQueueFilter.offered =>
          record.state == StaffAllocationState.offered,
        AllocationQueueFilter.confirmed =>
          record.state == StaffAllocationState.confirmed ||
              record.state == StaffAllocationState.checkedIn,
        AllocationQueueFilter.cancelled =>
          record.state == StaffAllocationState.cancelled,
      };
    }).toList();
    matching.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    return matching;
  }

  AllocationRecord? allocationById(String id) {
    for (final record in allocations) {
      if (record.id == id) return record;
    }
    return null;
  }

  Hostel? hostelById(String id) {
    for (final hostel in hostels) {
      if (hostel.id == id) return hostel;
    }
    return null;
  }

  List<Occupant> occupantsOf(String hostelId) =>
      occupants.where((entry) => entry.hostelId == hostelId).toList();

  int get freeBedTotal =>
      hostels.fold(0, (sum, hostel) => sum + hostel.freeBeds);

  HousingNoticeText? noticeText(NoticeKey key) {
    for (final entry in notices) {
      if (entry.key == key) return entry;
    }
    return null;
  }

  AgreementVersion? get currentAgreement {
    for (final entry in agreements) {
      if (entry.isCurrent) return entry;
    }
    return null;
  }

  HousingState copyWith({
    HousingStatus? status,
    List<AllocationRecord>? allocations,
    AllocationQueueFilter? filter,
    List<Hostel>? hostels,
    List<TermOpening>? openings,
    List<RoomPrice>? prices,
    RefundPolicy? refundPolicy,
    RefundSimulation? refundSimulation,
    List<AgreementVersion>? agreements,
    List<HousingNoticeText>? notices,
    List<HousingCategory>? categories,
    List<HousingBan>? bans,
    List<Occupant>? occupants,
    List<DirectoryStudent>? directory,
    int? waitlistCount,
    int? drawApplicants,
    int? keepEligible,
    UploadOutcome? upload,
    HandAllocationOutcome? handOutcome,
    AutoAllocationOutcome? autoOutcome,
    DrawOutcome? drawOutcome,
    KeepMyRoomOutcome? keepOutcome,
    HousingNotice? notice,
    bool clearNotice = false,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return HousingState(
      status: status ?? this.status,
      allocations: allocations ?? this.allocations,
      filter: filter ?? this.filter,
      hostels: hostels ?? this.hostels,
      openings: openings ?? this.openings,
      prices: prices ?? this.prices,
      refundPolicy: refundPolicy ?? this.refundPolicy,
      refundSimulation: refundSimulation ?? this.refundSimulation,
      agreements: agreements ?? this.agreements,
      notices: notices ?? this.notices,
      categories: categories ?? this.categories,
      bans: bans ?? this.bans,
      occupants: occupants ?? this.occupants,
      directory: directory ?? this.directory,
      waitlistCount: waitlistCount ?? this.waitlistCount,
      drawApplicants: drawApplicants ?? this.drawApplicants,
      keepEligible: keepEligible ?? this.keepEligible,
      upload: upload ?? this.upload,
      handOutcome: handOutcome ?? this.handOutcome,
      autoOutcome: autoOutcome ?? this.autoOutcome,
      drawOutcome: drawOutcome ?? this.drawOutcome,
      keepOutcome: keepOutcome ?? this.keepOutcome,
      notice: clearNotice ? null : (notice ?? this.notice),
      failureMessage: clearFailure
          ? null
          : (failureMessage ?? this.failureMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    allocations,
    filter,
    hostels,
    openings,
    prices,
    refundPolicy,
    refundSimulation,
    agreements,
    notices,
    categories,
    bans,
    occupants,
    directory,
    waitlistCount,
    drawApplicants,
    keepEligible,
    upload,
    handOutcome,
    autoOutcome,
    drawOutcome,
    keepOutcome,
    notice,
    failureMessage,
  ];
}
