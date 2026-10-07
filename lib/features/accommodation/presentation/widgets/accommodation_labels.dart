import 'package:flutter/material.dart';

import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_tone.dart';
import '../models/accommodation_models.dart';

/// Localised labels, tones and glyphs for the accommodation enums.
///
/// One home for the status vocabulary — "Reserved, awaiting payment",
/// "Offered, awaiting the student" — so the hub, the history and the staff
/// screens say the same words for the same state.
abstract final class AccommodationLabels {
  /// `Room 104 · Bed 2`.
  static String roomBed(AppLocalizations l10n, BedLocation bed) =>
      l10n.accommodationRoomBed(bed.room, bed.bed);

  /// `Amina Hall · Block A · Room 104 · Bed 2`.
  static String bedFull(AppLocalizations l10n, BedLocation bed) =>
      l10n.accommodationBedFull(bed.hostelBlock, bed.room, bed.bed);

  /// `Amina Hall · Block A · Room 104`.
  static String roomOnly(AppLocalizations l10n, BedLocation bed) =>
      l10n.accommodationRoomOnly(bed.hostelBlock, bed.room);

  static String phaseStatus(AppLocalizations l10n, AllocationPhase phase) {
    return switch (phase) {
      AllocationPhase.notScheduled => l10n.accommodationStatusNotScheduled,
      AllocationPhase.needsTerms => l10n.accommodationStatusNeedsTerms,
      AllocationPhase.roomList => l10n.accommodationStatusBookingOpen,
      AllocationPhase.held => l10n.accommodationStatusHeld,
      AllocationPhase.offered => l10n.accommodationStatusOffered,
      AllocationPhase.confirmed => l10n.accommodationStatusConfirmed,
      AllocationPhase.checkedIn => l10n.accommodationStatusCheckedIn,
    };
  }

  static AppTone phaseTone(AllocationPhase phase) {
    return switch (phase) {
      AllocationPhase.notScheduled => AppTone.neutral,
      AllocationPhase.needsTerms => AppTone.info,
      AllocationPhase.roomList => AppTone.info,
      AllocationPhase.held => AppTone.warning,
      AllocationPhase.offered => AppTone.warning,
      AllocationPhase.confirmed => AppTone.success,
      AllocationPhase.checkedIn => AppTone.success,
    };
  }

  static String historyOutcome(AppLocalizations l10n, HistoryOutcome outcome) {
    return switch (outcome) {
      HistoryOutcome.checkedOut => l10n.accommodationHistoryCheckedOut,
      HistoryOutcome.cancelledWithCharge =>
        l10n.accommodationHistoryCancelledCharge,
      HistoryOutcome.cancelled => l10n.accommodationHistoryCancelled,
      HistoryOutcome.expired => l10n.accommodationHistoryExpired,
    };
  }

  static AppTone historyTone(HistoryOutcome outcome) {
    return switch (outcome) {
      HistoryOutcome.checkedOut => AppTone.success,
      HistoryOutcome.cancelledWithCharge => AppTone.danger,
      HistoryOutcome.cancelled => AppTone.neutral,
      HistoryOutcome.expired => AppTone.warning,
    };
  }

  static IconData historyIcon(HistoryOutcome outcome) {
    return switch (outcome) {
      HistoryOutcome.checkedOut => Icons.done_all,
      HistoryOutcome.cancelledWithCharge => Icons.warning_amber_outlined,
      HistoryOutcome.cancelled => Icons.cancel_outlined,
      HistoryOutcome.expired => Icons.receipt_long_outlined,
    };
  }

  static String roomAvailability(
    AppLocalizations l10n,
    RoomAvailability availability,
  ) {
    return switch (availability) {
      RoomAvailability.open => l10n.accommodationRoomOpen,
      RoomAvailability.singleSlot => l10n.accommodationRoomSingleSlot,
      RoomAvailability.kept => l10n.accommodationRoomUnavailable,
      RoomAvailability.maintenance => l10n.accommodationRoomMaintenance,
    };
  }

  /// `41 hours and 20 minutes`.
  static String duration(AppLocalizations l10n, Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return l10n.accommodationDuration(hours, minutes);
  }
}
