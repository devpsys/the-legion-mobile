import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/widgets/accommodation_shell.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/widgets/staff/housing_shell.dart';

void main() {
  group('accommodationBackTarget', () {
    test('leaves the hub for the student hub', () {
      expect(accommodationBackTarget(Routes.accommodation), Routes.homeName);
    });

    test('unwinds every other student screen to the accommodation hub', () {
      for (final location in [
        Routes.accommodationHistory,
        Routes.accommodationTerms,
        Routes.accommodationRooms,
      ]) {
        expect(
          accommodationBackTarget(location),
          Routes.accommodationName,
          reason: location,
        );
      }
    });
  });

  group('housingBackTarget', () {
    test('leaves the allocations queue for the hub', () {
      expect(housingBackTarget(Routes.staffAllocations), Routes.homeName);
    });

    test('unwinds one allocation to the queue', () {
      expect(
        housingBackTarget(Routes.staffAllocation('al-1001')),
        Routes.staffAllocationsName,
      );
    });

    test('unwinds the hostel screens to the hostels list', () {
      expect(
        housingBackTarget(Routes.staffHostel('amina')),
        Routes.staffHostelsName,
      );
      expect(
        housingBackTarget(Routes.staffOccupants('amina')),
        Routes.staffHostelsName,
      );
      expect(
        housingBackTarget(Routes.staffRoom('amina', 'a-104')),
        Routes.staffHostelsName,
      );
      expect(
        housingBackTarget(Routes.staffBlock('amina', 'a')),
        Routes.staffHostelsName,
      );
    });

    test('unwinds the refund simulator to openings and prices', () {
      expect(housingBackTarget(Routes.staffRefunds), Routes.staffOpeningsName);
    });

    test('unwinds every tool to the allocations queue', () {
      for (final location in [
        Routes.staffHostels,
        Routes.staffOpenings,
        Routes.staffUpload,
        Routes.staffAllocate,
        Routes.staffAutoAllocation,
        Routes.staffDraw,
        Routes.staffKeepMyRoom,
        Routes.staffAgreement,
        Routes.staffNotices,
        Routes.staffCategories,
        Routes.staffBans,
      ]) {
        expect(
          housingBackTarget(location),
          Routes.staffAllocationsName,
          reason: location,
        );
      }
    });
  });
}
