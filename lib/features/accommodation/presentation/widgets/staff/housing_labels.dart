import 'package:flutter/material.dart';

import '../../../../../core/l10n/gen/app_localizations.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../models/staff/housing_models.dart';

/// Words, tones and icons for the housing office enums, kept in one place so
/// the queue, the detail and the tools name a state the same way.
abstract final class HousingLabels {
  static String allocationState(
    AppLocalizations l10n,
    StaffAllocationState state,
  ) {
    return switch (state) {
      StaffAllocationState.held => l10n.housingStateHeld,
      StaffAllocationState.offered => l10n.housingStateOffered,
      StaffAllocationState.confirmed => l10n.housingStateConfirmed,
      StaffAllocationState.checkedIn => l10n.housingStateCheckedIn,
      StaffAllocationState.cancelled => l10n.housingStateCancelled,
    };
  }

  static AppTone allocationTone(StaffAllocationState state) {
    return switch (state) {
      StaffAllocationState.held => AppTone.warning,
      StaffAllocationState.offered => AppTone.info,
      StaffAllocationState.confirmed => AppTone.success,
      StaffAllocationState.checkedIn => AppTone.success,
      StaffAllocationState.cancelled => AppTone.neutral,
    };
  }

  static String method(AppLocalizations l10n, AllocationMethod method) {
    return switch (method) {
      AllocationMethod.student => l10n.housingMethodStudent,
      AllocationMethod.byHand => l10n.housingMethodByHand,
      AllocationMethod.spreadsheet => l10n.housingMethodSpreadsheet,
      AllocationMethod.automatic => l10n.housingMethodAutomatic,
      AllocationMethod.draw => l10n.housingMethodDraw,
      AllocationMethod.keepMyRoom => l10n.housingMethodKeepMyRoom,
    };
  }

  static String filter(AppLocalizations l10n, AllocationQueueFilter filter) {
    return switch (filter) {
      AllocationQueueFilter.all => l10n.housingFilterAll,
      AllocationQueueFilter.held => l10n.housingStateHeld,
      AllocationQueueFilter.offered => l10n.housingStateOffered,
      AllocationQueueFilter.confirmed => l10n.housingStateConfirmed,
      AllocationQueueFilter.cancelled => l10n.housingStateCancelled,
    };
  }

  static String gender(AppLocalizations l10n, HostelGender gender) {
    return switch (gender) {
      HostelGender.female => l10n.housingGenderFemale,
      HostelGender.male => l10n.housingGenderMale,
      HostelGender.mixed => l10n.housingGenderMixed,
    };
  }

  static String bedState(AppLocalizations l10n, BedState state) {
    return switch (state) {
      BedState.free => l10n.housingBedFree,
      BedState.held => l10n.housingBedHeld,
      BedState.taken => l10n.housingBedTaken,
      BedState.blocked => l10n.housingBedBlocked,
    };
  }

  static AppTone bedTone(BedState state) {
    return switch (state) {
      BedState.free => AppTone.success,
      BedState.held => AppTone.warning,
      BedState.taken => AppTone.info,
      BedState.blocked => AppTone.neutral,
    };
  }

  static String roomStatus(AppLocalizations l10n, RoomStatus status) {
    return switch (status) {
      RoomStatus.open => l10n.housingRoomOpen,
      RoomStatus.maintenance => l10n.housingRoomMaintenance,
      RoomStatus.closed => l10n.housingRoomClosed,
    };
  }

  static AppTone roomTone(RoomStatus status) {
    return switch (status) {
      RoomStatus.open => AppTone.success,
      RoomStatus.maintenance => AppTone.warning,
      RoomStatus.closed => AppTone.neutral,
    };
  }

  static String bookingMethod(AppLocalizations l10n, BookingMethod method) {
    return switch (method) {
      BookingMethod.firstCome => l10n.housingBookingFirstCome,
      BookingMethod.draw => l10n.housingBookingDraw,
      BookingMethod.priority => l10n.housingBookingPriority,
    };
  }

  static String openingStatus(AppLocalizations l10n, OpeningStatus status) {
    return switch (status) {
      OpeningStatus.scheduled => l10n.housingOpeningScheduled,
      OpeningStatus.open => l10n.housingOpeningOpen,
      OpeningStatus.closed => l10n.housingOpeningClosed,
    };
  }

  static AppTone openingTone(OpeningStatus status) {
    return switch (status) {
      OpeningStatus.scheduled => AppTone.info,
      OpeningStatus.open => AppTone.success,
      OpeningStatus.closed => AppTone.neutral,
    };
  }

  static String uploadIssue(AppLocalizations l10n, UploadIssueKind kind) {
    return switch (kind) {
      UploadIssueKind.bedUnknown => l10n.housingIssueBedUnknown,
      UploadIssueKind.matricUnknown => l10n.housingIssueMatricUnknown,
      UploadIssueKind.bedTaken => l10n.housingIssueBedTaken,
      UploadIssueKind.duplicateStudent => l10n.housingIssueDuplicate,
      UploadIssueKind.genderMismatch => l10n.housingIssueGender,
    };
  }

  static String noticeKey(AppLocalizations l10n, NoticeKey key) {
    return switch (key) {
      NoticeKey.offerMade => l10n.housingNoticeOfferMade,
      NoticeKey.deadlineNear => l10n.housingNoticeDeadlineNear,
      NoticeKey.bedReleased => l10n.housingNoticeBedReleased,
      NoticeKey.welcome => l10n.housingNoticeWelcome,
    };
  }

  static String skipReason(AppLocalizations l10n, KeepSkipReason reason) {
    return switch (reason) {
      KeepSkipReason.banned => l10n.housingSkipBanned,
      KeepSkipReason.unpaidFees => l10n.housingSkipUnpaid,
      KeepSkipReason.roomClosed => l10n.housingSkipRoomClosed,
    };
  }

  static String drawMethod(AppLocalizations l10n, DrawMethod method) {
    return switch (method) {
      DrawMethod.ballot => l10n.housingDrawBallot,
      DrawMethod.priority => l10n.housingDrawPriority,
    };
  }

  static IconData bedIcon(BedState state) {
    return switch (state) {
      BedState.free => Icons.bed_outlined,
      BedState.held => Icons.hourglass_top,
      BedState.taken => Icons.bed,
      BedState.blocked => Icons.block,
    };
  }
}
