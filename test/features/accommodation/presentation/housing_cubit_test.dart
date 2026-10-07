import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/bloc/staff/housing_cubit.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/bloc/staff/housing_state.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/mock/staff/housing_fixtures.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/models/staff/housing_models.dart';

void main() {
  HousingCubit started() => HousingCubit()..load();

  test('loads the ledger', () {
    final cubit = started();

    expect(cubit.state.status, HousingStatus.ready);
    expect(cubit.state.allocations, isNotEmpty);
    expect(cubit.state.hostels.length, 2);
  });

  test('filters the queue by state, newest first', () {
    final cubit = started()..setFilter(AllocationQueueFilter.held);

    expect(cubit.state.visibleAllocations.map((r) => r.state).toSet(), {
      StaffAllocationState.held,
    });

    cubit.setFilter(AllocationQueueFilter.all);
    final dates = cubit.state.visibleAllocations.map((r) => r.createdOn);
    expect(dates.toList(), [...dates]..sort((a, b) => b.compareTo(a)));
  });

  test('cancelling an allocation frees its bed', () {
    final cubit = started();
    final free = cubit.state.freeBedTotal;

    cubit.cancelAllocation('al-1001');

    expect(
      cubit.state.allocationById('al-1001')?.state,
      StaffAllocationState.cancelled,
    );
    expect(cubit.state.freeBedTotal, free + 1);
    expect(cubit.state.notice, HousingNotice.allocationCancelled);
  });

  group('allocating by hand', () {
    test('gives a student a free bed and lists them as an occupant', () {
      final cubit = started()
        ..allocateByHand(
          matricNumber: '24/ENG/0128',
          hostelId: HousingFixtures.amina,
          roomId: 'b-101',
          bedNumber: 1,
        );

      expect(cubit.state.handOutcome.status, HandAllocationStatus.allocated);
      expect(cubit.state.allocations.first.studentName, 'Chinedu Okafor');
      expect(
        cubit.state.hostelById('amina')?.roomById('b-101')?.beds.first.state,
        BedState.taken,
      );
    });

    test('refuses an unknown matric number', () {
      final cubit = started()
        ..allocateByHand(
          matricNumber: '99/XXX/0000',
          hostelId: HousingFixtures.amina,
          roomId: 'b-101',
          bedNumber: 1,
        );

      expect(
        cubit.state.handOutcome.status,
        HandAllocationStatus.unknownStudent,
      );
    });

    test('refuses a banned student', () {
      final cubit = started()
        ..allocateByHand(
          matricNumber: HousingFixtures.bannedMatric,
          hostelId: HousingFixtures.amina,
          roomId: 'b-101',
          bedNumber: 1,
        );

      expect(
        cubit.state.handOutcome.status,
        HandAllocationStatus.studentBanned,
      );
    });

    test('refuses a bed that is not free', () {
      final cubit = started()
        ..allocateByHand(
          matricNumber: '24/ENG/0128',
          hostelId: HousingFixtures.amina,
          roomId: 'a-101',
          bedNumber: 1,
        );

      expect(cubit.state.handOutcome.status, HandAllocationStatus.bedTaken);
    });
  });

  test('automatic allocation places the waitlist into free beds', () {
    final cubit = started();
    final waitlist = cubit.state.waitlistCount;
    final free = cubit.state.freeBedTotal;

    cubit.runAutoAllocation();

    final outcome = cubit.state.autoOutcome!;
    expect(outcome.placed, waitlist < free ? waitlist : free);
    expect(outcome.placed + outcome.unplaced, waitlist);
  });

  test('the draw never gives out more beds than are free', () {
    final cubit = started()..runDraw(method: DrawMethod.ballot, seats: 9999);

    final outcome = cubit.state.drawOutcome!;
    expect(
      outcome.seats,
      lessThanOrEqualTo(
        HousingFixtures.ledger.hostels.fold<int>(
          0,
          (sum, h) => sum + h.freeBeds,
        ),
      ),
    );
    expect(outcome.winners, lessThanOrEqualTo(outcome.seats));
  });

  test('keep-my-room reports who was skipped', () {
    final cubit = started()..sendKeepMyRoom(windowDays: 7);

    final outcome = cubit.state.keepOutcome!;
    expect(outcome.skipped, HousingCubit.keepSkips);
    expect(outcome.offered, cubit.state.keepEligible - outcome.skipped.length);
  });

  group('spreadsheet upload', () {
    test('a good sheet is applied as one batch', () {
      final cubit = started()..uploadSample(UploadSample.valid);

      expect(cubit.state.upload.status, UploadStatus.success);
      expect(cubit.state.upload.batchReference, isNotEmpty);
      expect(cubit.state.notice, HousingNotice.uploadDone);
    });

    test('a missing header is reported before any row', () {
      final cubit = started()..uploadSample(UploadSample.badHeader);

      expect(cubit.state.upload.status, UploadStatus.headerError);
      expect(cubit.state.upload.missingColumn, 'matric_number');
      expect(cubit.state.upload.issues, isEmpty);
    });

    test('bad rows are listed and nothing is applied', () {
      final cubit = started()..uploadSample(UploadSample.badRows);

      expect(cubit.state.upload.status, UploadStatus.rowErrors);
      expect(cubit.state.upload.issues.length, 5);
      expect(cubit.state.notice, isNull);
    });
  });

  test('adding rooms skips numbers the block already has', () {
    final cubit = started()
      ..addRooms(
        hostelId: HousingFixtures.amina,
        blockId: 'a',
        from: 104,
        to: 108,
        roomType: '2-Bed Room',
        bedsPerRoom: 2,
      );

    final rooms = cubit.state.hostelById('amina')!.roomsOf('a');
    expect(rooms.map((r) => r.number).where((n) => n == '104').length, 1);
    expect(rooms.length, 4 + 3);
  });

  test('publishing the agreement makes the new version current', () {
    final cubit = started()..publishAgreement('Quiet hours start at ten.');

    expect(cubit.state.currentAgreement?.version, 4);
    expect(cubit.state.agreements.where((a) => a.isCurrent).length, 1);
  });

  test('a ban blocks a known student once, and can be lifted', () {
    final cubit = started();

    expect(
      cubit.addBan(matricNumber: '25/CSC/0101', reason: 'Late levy'),
      isTrue,
    );
    expect(cubit.addBan(matricNumber: '25/CSC/0101', reason: 'Again'), isFalse);
    expect(
      cubit.addBan(matricNumber: '00/XXX/0000', reason: 'Unknown'),
      isFalse,
    );

    cubit.liftBan(cubit.state.bans.first.id);
    expect(cubit.state.bans.length, 1);
  });

  test('refund simulation honours the share and the window', () {
    final cubit = started()
      ..simulateRefund(paidMinorUnits: 7500000, daysBeforeCheckIn: 21);
    expect(cubit.state.refundSimulation?.refundMinorUnits, 5250000);

    cubit.simulateRefund(paidMinorUnits: 7500000, daysBeforeCheckIn: 3);
    expect(cubit.state.refundSimulation?.refundMinorUnits, 0);
    expect(cubit.state.refundSimulation?.chargeMinorUnits, 7500000);
  });
}
