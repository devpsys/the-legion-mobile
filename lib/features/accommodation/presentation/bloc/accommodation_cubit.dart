import 'package:flutter_bloc/flutter_bloc.dart';

import '../mock/accommodation_fixtures.dart';
import '../models/accommodation_models.dart';
import 'accommodation_state.dart';

/// Drives the student Accommodation portal: the term selector, the agreement,
/// booking, the waitlist offer, cancelling and bed swaps.
///
/// Presentation only — fixtures until the housing endpoints land. The ledger
/// is injected so tests and previews can start a student in any phase.
class AccommodationCubit extends Cubit<AccommodationState> {
  AccommodationCubit({AccommodationLedger? ledger})
    : _ledger = ledger ?? AccommodationFixtures.ledger,
      super(const AccommodationState());

  AccommodationLedger _ledger;

  /// How long a freshly booked bed waits for its fee.
  static const Duration holdWindow = Duration(hours: 2);

  /// How long an accepted waitlist bed waits for its fee.
  static const Duration offerPaymentWindow = Duration(hours: 72);

  /// Grace after the deadline during which a late fee still confirms the bed.
  static const Duration graceWindow = Duration(hours: 72);

  void load() {
    if (state.status == AccommodationStatus.ready) return;
    _emitLedger();
  }

  /// Replaces the fixture ledger so every student phase can be previewed.
  ///
  /// Used by the debug preview menu only; production traffic never calls it.
  void previewScenario(AccommodationPreviewScenario scenario) {
    _ledger = AccommodationFixtures.ledgerFor(scenario);
    _emitLedger(selectedTerm: AccommodationTerm.first);
  }

  void _emitLedger({AccommodationTerm? selectedTerm}) {
    emit(
      state.copyWith(status: AccommodationStatus.loading, clearFailure: true),
    );
    emit(
      state.copyWith(
        status: AccommodationStatus.ready,
        student: _ledger.student,
        sessionLabel: _ledger.sessionLabel,
        now: _ledger.now,
        selectedTerm: selectedTerm ?? state.selectedTerm,
        terms: _ledger.terms,
        agreement: _ledger.agreement,
        history: _ledger.history,
        swapTargets: _ledger.swapTargets,
        swapLookup: const SwapLookup(),
        clearFailure: true,
        clearNotice: true,
      ),
    );
  }

  void selectTerm(AccommodationTerm term) {
    if (state.selectedTerm == term) return;
    emit(state.copyWith(selectedTerm: term, swapLookup: const SwapLookup()));
  }

  /// Records the agreement against the account and opens booking for every
  /// term that was waiting on it.
  void acceptTerms() {
    final updated = [
      for (final term in state.terms)
        term.phase == AllocationPhase.needsTerms
            ? term.copyWith(phase: AllocationPhase.roomList)
            : term,
    ];
    emit(
      state.copyWith(terms: updated, notice: AccommodationNotice.termsAccepted),
    );
  }

  /// Holds the first free bed of [roomId] for the selected term.
  ///
  /// Returns `false` when the room is not bookable (full, kept, closed) or the
  /// term is not accepting bookings.
  bool bookRoom(String roomId) {
    final term = state.current;
    final now = state.now;
    if (term == null || now == null) return false;
    if (term.phase != AllocationPhase.roomList) return false;
    final room = _roomById(term, roomId);
    if (room == null || !room.isBookable) return false;

    final booked = term.copyWith(
      phase: AllocationPhase.held,
      bed: room.nextBed,
      fee: AccommodationFee(
        amountMinorUnits: room.priceMinorUnits,
        invoiceReference: 'AC/2026/00143',
      ),
      deadline: now.add(holdWindow),
      graceUntil: now.add(holdWindow + graceWindow),
      bookedOn: now,
    );
    _replace(booked, notice: AccommodationNotice.bedHeld);
    return true;
  }

  /// Accepts the waitlist offer: the bed is held and an invoice is raised.
  bool acceptOffer() {
    final term = state.current;
    final now = state.now;
    if (term == null || now == null) return false;
    if (term.phase != AllocationPhase.offered) return false;

    final fee = term.fee;
    final accepted = term.copyWith(
      phase: AllocationPhase.held,
      fee: AccommodationFee(
        amountMinorUnits: fee?.amountMinorUnits ?? 0,
        invoiceReference: 'AC/2026/00144',
      ),
      deadline: now.add(offerPaymentWindow),
      graceUntil: now.add(offerPaymentWindow + graceWindow),
      bookedOn: now,
      clearOfferReference: true,
    );
    _replace(accepted, notice: AccommodationNotice.offerAccepted);
    return true;
  }

  /// Declines the waitlist offer; the student leaves the waitlist and the
  /// term goes back to the room list.
  bool declineOffer() {
    final term = state.current;
    if (term == null || term.phase != AllocationPhase.offered) return false;
    _replace(
      term.copyWith(
        phase: AllocationPhase.roomList,
        clearBed: true,
        clearFee: true,
        clearDeadline: true,
        clearOfferReference: true,
      ),
      notice: AccommodationNotice.offerDeclined,
    );
    return true;
  }

  /// Cancels a held or confirmed bed before check-in.
  ///
  /// The bed goes back on the room list and the record joins the history.
  bool cancelBooking() {
    final term = state.current;
    if (term == null) return false;
    if (term.phase != AllocationPhase.held &&
        term.phase != AllocationPhase.confirmed) {
      return false;
    }
    final bed = term.bed;
    final record = bed == null
        ? null
        : HistoryRecord(
            id: 'cancelled-${term.label}',
            location: bed,
            sessionLabel: term.label,
            outcome: HistoryOutcome.cancelled,
            note: 'Accommodation cancelled: student requested',
          );

    emit(
      state.copyWith(
        terms: [
          for (final entry in state.terms)
            entry.term == term.term
                ? entry.copyWith(
                    phase: AllocationPhase.roomList,
                    clearBed: true,
                    clearFee: true,
                    clearDeadline: true,
                    clearGrace: true,
                    clearBookedOn: true,
                    clearSwap: true,
                  )
                : entry,
        ],
        history: record == null ? state.history : [record, ...state.history],
        swapLookup: const SwapLookup(),
        notice: AccommodationNotice.bookingCancelled,
      ),
    );
    return true;
  }

  /// The invoice reference the student is sent to pay, or null when the
  /// selected term has nothing to pay. The page deep-links to Fees.
  String? pay() {
    final term = state.current;
    if (term == null || term.phase != AllocationPhase.held) return null;
    return term.fee?.invoiceReference;
  }

  /// Looks [matricNumber] up for a swap proposal.
  void lookupSwapTarget(String matricNumber) {
    final query = matricNumber.trim().toUpperCase();
    final own = state.student?.matricNumber.toUpperCase();
    SwapTarget? found;
    if (query.isNotEmpty && query != own) {
      for (final target in state.swapTargets) {
        if (target.matricNumber.toUpperCase() == query) {
          found = target;
          break;
        }
      }
    }
    emit(
      state.copyWith(
        swapLookup: found == null
            ? const SwapLookup(status: SwapLookupStatus.notFound)
            : SwapLookup(status: SwapLookupStatus.found, target: found),
      ),
    );
  }

  /// Sends the swap request for the student the lookup found.
  bool proposeSwap() {
    if (state.swapLookup.status != SwapLookupStatus.found) return false;
    emit(
      state.copyWith(
        swapLookup: const SwapLookup(),
        notice: AccommodationNotice.swapProposed,
      ),
    );
    return true;
  }

  /// Answers the swap another student proposed.
  ///
  /// Accepting takes the proposer's bed; either answer clears the proposal.
  bool respondToSwap({required bool accept}) {
    final term = state.current;
    final swap = term?.swap;
    if (term == null || swap == null) return false;
    _replace(
      term.copyWith(bed: accept ? swap.location : null, clearSwap: true),
      notice: accept
          ? AccommodationNotice.swapAccepted
          : AccommodationNotice.swapDeclined,
    );
    return true;
  }

  void clearNotice() {
    if (state.notice == null) return;
    emit(state.copyWith(clearNotice: true));
  }

  BookableRoom? _roomById(TermAccommodation term, String id) {
    for (final room in term.rooms) {
      if (room.id == id) return room;
    }
    return null;
  }

  void _replace(TermAccommodation updated, {AccommodationNotice? notice}) {
    emit(
      state.copyWith(
        terms: [
          for (final entry in state.terms)
            entry.term == updated.term ? updated : entry,
        ],
        swapLookup: const SwapLookup(),
        notice: notice,
      ),
    );
  }
}
