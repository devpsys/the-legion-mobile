import 'package:equatable/equatable.dart';

import '../../../../core/theme/app_tone.dart';

/// Lifecycle of an ID card credential the student can see.
///
/// [IdCardStatus.printed] is labelled "Ready for collection" in the UI —
/// never "Printed" (registration-records README rule 5).
enum IdCardStatus {
  none,
  requested,
  printed,
  collected,
}

/// Why a student is asking for a card (first issue or replacement).
enum IdCardReason {
  firstCard,
  lostOrStolen,
  damaged,
  nameOrProgrammeUpdate,
}

/// Whether the replacement levy has been settled.
enum IdCardFeePayment { notRequired, unpaid, paid }

/// Passport photo readiness for printing a card.
enum IdCardPhotoStatus { missing, pendingApproval, approved }

/// Status shown on a past card in history.
enum IdCardHistoryStatus { collected, replaced }

/// Types of academic exception / programme petition.
enum AcademicRequestType {
  lateRegistration,
  addDropAfterDeadline,
  overload,
  underload,
  waivePrerequisite,
  changeOfProgramme,
}

/// Approval state of an academic petition.
enum AcademicRequestStatus { pending, approved, rejected, withdrawn }

extension IdCardStatusX on IdCardStatus {
  AppTone get tone => switch (this) {
    IdCardStatus.none => AppTone.neutral,
    IdCardStatus.requested => AppTone.warning,
    IdCardStatus.printed => AppTone.info,
    IdCardStatus.collected => AppTone.success,
  };
}

extension AcademicRequestStatusX on AcademicRequestStatus {
  AppTone get tone => switch (this) {
    AcademicRequestStatus.pending => AppTone.warning,
    AcademicRequestStatus.approved => AppTone.success,
    AcademicRequestStatus.rejected => AppTone.danger,
    AcademicRequestStatus.withdrawn => AppTone.neutral,
  };
}

/// An in-flight or collectable ID card request.
class IdCardActiveRequest extends Equatable {
  const IdCardActiveRequest({
    required this.serial,
    required this.status,
    required this.reason,
    required this.requestedOn,
    required this.feePayment,
    required this.feeMinorUnits,
    this.collectionDeadline,
    this.canCancel = false,
  });

  final String serial;
  final IdCardStatus status;
  final IdCardReason reason;
  final DateTime requestedOn;
  final IdCardFeePayment feePayment;
  final int feeMinorUnits;
  final DateTime? collectionDeadline;
  final bool canCancel;

  bool get isReadyForCollection => status == IdCardStatus.printed;

  bool get isInProgress => status == IdCardStatus.requested;

  @override
  List<Object?> get props => [
    serial,
    status,
    reason,
    requestedOn,
    feePayment,
    feeMinorUnits,
    collectionDeadline,
    canCancel,
  ];
}

/// One row in card history.
class IdCardHistoryEntry extends Equatable {
  const IdCardHistoryEntry({
    required this.serial,
    required this.status,
    required this.reason,
    required this.requestedOn,
    required this.expiresOn,
    this.isFirstCard = false,
    this.expired = false,
  });

  final String serial;
  final IdCardHistoryStatus status;
  final IdCardReason reason;
  final DateTime requestedOn;
  final DateTime expiresOn;
  final bool isFirstCard;
  final bool expired;

  @override
  List<Object?> get props => [
    serial,
    status,
    reason,
    requestedOn,
    expiresOn,
    isFirstCard,
    expired,
  ];
}

/// Student ID card module state for one portal visit.
class IdCardRecord extends Equatable {
  const IdCardRecord({
    required this.photoStatus,
    required this.history,
    required this.replacementFeeMinorUnits,
    this.activeRequest,
    this.draftReason,
    this.hasEverHeldCard = true,
  });

  final IdCardPhotoStatus photoStatus;
  final IdCardActiveRequest? activeRequest;
  final List<IdCardHistoryEntry> history;
  final int replacementFeeMinorUnits;

  /// Selected reason on the request form (null until chosen).
  final IdCardReason? draftReason;

  /// False for a first-ever free card (state B).
  final bool hasEverHeldCard;

  bool get photoApproved => photoStatus == IdCardPhotoStatus.approved;

  bool get isFirstIssue => !hasEverHeldCard;

  bool get hasActiveRequest => activeRequest != null;

  /// Why the request button is locked; null when the form may be submitted.
  IdCardSubmitLock? get submitLock {
    if (hasActiveRequest) return IdCardSubmitLock.activeRequest;
    if (!photoApproved) return IdCardSubmitLock.photo;
    if (draftReason == null) return IdCardSubmitLock.reasonRequired;
    return null;
  }

  bool get canSubmitRequest => submitLock == null;

  IdCardRecord copyWith({
    IdCardPhotoStatus? photoStatus,
    IdCardActiveRequest? activeRequest,
    bool clearActiveRequest = false,
    List<IdCardHistoryEntry>? history,
    int? replacementFeeMinorUnits,
    IdCardReason? draftReason,
    bool clearDraftReason = false,
    bool? hasEverHeldCard,
  }) {
    return IdCardRecord(
      photoStatus: photoStatus ?? this.photoStatus,
      activeRequest: clearActiveRequest
          ? null
          : (activeRequest ?? this.activeRequest),
      history: history ?? this.history,
      replacementFeeMinorUnits:
          replacementFeeMinorUnits ?? this.replacementFeeMinorUnits,
      draftReason: clearDraftReason ? null : (draftReason ?? this.draftReason),
      hasEverHeldCard: hasEverHeldCard ?? this.hasEverHeldCard,
    );
  }

  @override
  List<Object?> get props => [
    photoStatus,
    activeRequest,
    history,
    replacementFeeMinorUnits,
    draftReason,
    hasEverHeldCard,
  ];
}

/// Why [IdCardRecord.canSubmitRequest] is false.
enum IdCardSubmitLock { activeRequest, photo, reasonRequired }

/// One academic petition on the Requests tab.
class AcademicRequest extends Equatable {
  const AcademicRequest({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.filedOn,
    required this.status,
    this.decisionNote,
    this.canWithdraw = false,
    this.emphasis = const [],
  });

  final String id;
  final AcademicRequestType type;
  final String title;
  final String summary;
  final DateTime filedOn;
  final AcademicRequestStatus status;
  final String? decisionNote;
  final bool canWithdraw;

  /// Substrings in [summary] to emphasise (course codes).
  final List<String> emphasis;

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    summary,
    filedOn,
    status,
    decisionNote,
    canWithdraw,
    emphasis,
  ];
}

/// Draft fields for the new academic request form.
class AcademicRequestDraft extends Equatable {
  const AcademicRequestDraft({
    this.type = AcademicRequestType.waivePrerequisite,
    this.courseCode = '',
    this.prerequisiteCode = '',
    this.reasons = '',
  });

  final AcademicRequestType type;
  final String courseCode;
  final String prerequisiteCode;
  final String reasons;

  AcademicRequestDraft copyWith({
    AcademicRequestType? type,
    String? courseCode,
    String? prerequisiteCode,
    String? reasons,
  }) {
    return AcademicRequestDraft(
      type: type ?? this.type,
      courseCode: courseCode ?? this.courseCode,
      prerequisiteCode: prerequisiteCode ?? this.prerequisiteCode,
      reasons: reasons ?? this.reasons,
    );
  }

  @override
  List<Object?> get props => [type, courseCode, prerequisiteCode, reasons];
}
