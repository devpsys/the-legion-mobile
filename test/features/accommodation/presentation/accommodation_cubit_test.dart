import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/bloc/accommodation_cubit.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/bloc/accommodation_state.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/mock/accommodation_fixtures.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/models/accommodation_models.dart';

void main() {
  AccommodationCubit started([AccommodationLedger? ledger]) =>
      AccommodationCubit(ledger: ledger)..load();

  test('loads Amaka with a held bed and a waitlist offer', () {
    final cubit = started();

    expect(cubit.state.status, AccommodationStatus.ready);
    expect(cubit.state.phase, AllocationPhase.held);
    expect(
      cubit.state.termFor(AccommodationTerm.second)?.phase,
      AllocationPhase.offered,
    );
    expect(
      cubit.state.remainingUntil(cubit.state.current!.deadline!),
      const Duration(hours: 41, minutes: 20),
    );
  });

  test('selecting a term switches the phase the hub shows', () {
    final cubit = started()..selectTerm(AccommodationTerm.second);

    expect(cubit.state.phase, AllocationPhase.offered);
  });

  test('accepting terms opens the room list', () {
    final cubit = started(AccommodationFixtures.needsTermsLedger)
      ..acceptTerms();

    expect(cubit.state.phase, AllocationPhase.roomList);
    expect(cubit.state.notice, AccommodationNotice.termsAccepted);
  });

  test('booking a room holds its first free bed and starts the clock', () {
    final cubit = started(AccommodationFixtures.roomListLedger);
    final room = cubit.state.current!.rooms.first;

    expect(cubit.bookRoom(room.id), isTrue);
    expect(cubit.state.phase, AllocationPhase.held);
    expect(
      cubit.state.current?.deadline,
      AccommodationFixtures.now.add(AccommodationCubit.holdWindow),
    );
    expect(cubit.state.notice, AccommodationNotice.bedHeld);
  });

  test('refuses to book while a bed is already held', () {
    final cubit = started();

    expect(cubit.bookRoom('room-a-104'), isFalse);
  });

  test('accepting the offer raises an invoice and holds the bed', () {
    final cubit = started()..selectTerm(AccommodationTerm.second);

    expect(cubit.acceptOffer(), isTrue);
    expect(cubit.state.phase, AllocationPhase.held);
    expect(cubit.state.current?.fee?.invoiceReference, isNotNull);
  });

  test('declining the offer returns the term to the room list', () {
    final cubit = started()..selectTerm(AccommodationTerm.second);

    expect(cubit.declineOffer(), isTrue);
    expect(cubit.state.phase, AllocationPhase.roomList);
    expect(cubit.state.current?.bed, isNull);
  });

  test('cancelling a held bed frees it and writes the history', () {
    final cubit = started();
    final before = cubit.state.history.length;

    expect(cubit.cancelBooking(), isTrue);
    expect(cubit.state.phase, AllocationPhase.roomList);
    expect(cubit.state.history.length, before + 1);
    expect(cubit.state.history.first.outcome, HistoryOutcome.cancelled);
  });

  test('cannot cancel once checked in', () {
    final cubit = started(AccommodationFixtures.checkedInLedger);

    expect(cubit.cancelBooking(), isFalse);
    expect(cubit.state.phase, AllocationPhase.checkedIn);
  });

  test('pay hands back the invoice only while a bed is held', () {
    expect(
      started().pay(),
      AccommodationFixtures.heldFirstTerm.fee?.invoiceReference,
    );
    expect(started(AccommodationFixtures.confirmedLedger).pay(), isNull);
  });
}
