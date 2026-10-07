import 'package:equatable/equatable.dart';

import '../models/accommodation_models.dart';

/// Loading status of the student accommodation portal.
enum AccommodationStatus { initial, loading, ready, failure }

/// One-off outcome the page tells the student about, then clears.
enum AccommodationNotice {
  termsAccepted,
  bedHeld,
  bookingCancelled,
  offerAccepted,
  offerDeclined,
  swapAccepted,
  swapDeclined,
  swapProposed,
}

/// State of the student Accommodation portal.
class AccommodationState extends Equatable {
  const AccommodationState({
    this.status = AccommodationStatus.initial,
    this.student,
    this.sessionLabel = '',
    this.now,
    this.selectedTerm = AccommodationTerm.first,
    this.terms = const [],
    this.agreement,
    this.history = const [],
    this.swapTargets = const [],
    this.swapLookup = const SwapLookup(),
    this.notice,
    this.failureMessage,
  });

  final AccommodationStatus status;
  final AccommodationStudent? student;

  /// `2026/2027`.
  final String sessionLabel;

  /// The clock countdowns are measured against.
  final DateTime? now;
  final AccommodationTerm selectedTerm;
  final List<TermAccommodation> terms;
  final AccommodationAgreement? agreement;
  final List<HistoryRecord> history;
  final List<SwapTarget> swapTargets;
  final SwapLookup swapLookup;
  final AccommodationNotice? notice;
  final String? failureMessage;

  /// The selected term's record, or null before the ledger has loaded.
  TermAccommodation? get current => termFor(selectedTerm);

  AllocationPhase? get phase => current?.phase;

  TermAccommodation? termFor(AccommodationTerm term) {
    for (final entry in terms) {
      if (entry.term == term) return entry;
    }
    return null;
  }

  /// Time left until [deadline], never negative.
  Duration remainingUntil(DateTime deadline) {
    final reference = now;
    if (reference == null) return Duration.zero;
    final left = deadline.difference(reference);
    return left.isNegative ? Duration.zero : left;
  }

  AccommodationState copyWith({
    AccommodationStatus? status,
    AccommodationStudent? student,
    String? sessionLabel,
    DateTime? now,
    AccommodationTerm? selectedTerm,
    List<TermAccommodation>? terms,
    AccommodationAgreement? agreement,
    List<HistoryRecord>? history,
    List<SwapTarget>? swapTargets,
    SwapLookup? swapLookup,
    AccommodationNotice? notice,
    bool clearNotice = false,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return AccommodationState(
      status: status ?? this.status,
      student: student ?? this.student,
      sessionLabel: sessionLabel ?? this.sessionLabel,
      now: now ?? this.now,
      selectedTerm: selectedTerm ?? this.selectedTerm,
      terms: terms ?? this.terms,
      agreement: agreement ?? this.agreement,
      history: history ?? this.history,
      swapTargets: swapTargets ?? this.swapTargets,
      swapLookup: swapLookup ?? this.swapLookup,
      notice: clearNotice ? null : notice ?? this.notice,
      failureMessage: clearFailure
          ? null
          : failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    student,
    sessionLabel,
    now,
    selectedTerm,
    terms,
    agreement,
    history,
    swapTargets,
    swapLookup,
    notice,
    failureMessage,
  ];
}
