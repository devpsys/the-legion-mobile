import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/bloc/staff/housing_cubit.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/models/staff/housing_models.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_agreement_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_allocate_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_allocation_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_allocations_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_auto_allocation_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_bans_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_block_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_categories_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_draw_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_hostel_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_hostels_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_keep_my_room_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_notices_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_occupants_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_openings_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_refunds_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_room_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/staff/housing_upload_page.dart';

void main() {
  Future<HousingCubit> pump(
    WidgetTester tester,
    String location,
    Widget page,
  ) async {
    tester.view
      ..physicalSize = const Size(390, 3600) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final cubit = HousingCubit();
    addTearDown(cubit.close);

    final router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(path: location, builder: (_, _) => page),
        GoRoute(
          path: Routes.home,
          name: Routes.homeName,
          builder: (_, _) => const Text('home'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      BlocProvider<HousingCubit>.value(
        value: cubit,
        child: MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return cubit;
  }

  group('every housing screen renders without layout errors', () {
    final screens = <String, (String, Widget)>{
      'allocations queue': (
        Routes.staffAllocations,
        const HousingAllocationsPage(),
      ),
      'allocation detail': (
        Routes.staffAllocation('al-1001'),
        const HousingAllocationPage(allocationId: 'al-1001'),
      ),
      'missing allocation': (
        Routes.staffAllocation('nope'),
        const HousingAllocationPage(allocationId: 'nope'),
      ),
      'hostels': (Routes.staffHostels, const HousingHostelsPage()),
      'hostel bed grid': (
        Routes.staffHostel('amina'),
        const HousingHostelPage(hostelId: 'amina'),
      ),
      'occupants': (
        Routes.staffOccupants('amina'),
        const HousingOccupantsPage(hostelId: 'amina'),
      ),
      'room settings': (
        Routes.staffRoom('amina', 'a-104'),
        const HousingRoomPage(hostelId: 'amina', roomId: 'a-104'),
      ),
      'block bulk add': (
        Routes.staffBlock('amina', 'a'),
        const HousingBlockPage(hostelId: 'amina', blockId: 'a'),
      ),
      'openings and prices': (
        Routes.staffOpenings,
        const HousingOpeningsPage(),
      ),
      'spreadsheet upload': (Routes.staffUpload, const HousingUploadPage()),
      'allocate by hand': (Routes.staffAllocate, const HousingAllocatePage()),
      'automatic allocation': (
        Routes.staffAutoAllocation,
        const HousingAutoAllocationPage(),
      ),
      'draw': (Routes.staffDraw, const HousingDrawPage()),
      'keep my room': (Routes.staffKeepMyRoom, const HousingKeepMyRoomPage()),
      'agreement': (Routes.staffAgreement, const HousingAgreementPage()),
      'notices': (Routes.staffNotices, const HousingNoticesPage()),
      'categories': (Routes.staffCategories, const HousingCategoriesPage()),
      'bans': (Routes.staffBans, const HousingBansPage()),
      'refunds': (Routes.staffRefunds, const HousingRefundsPage()),
    };

    for (final entry in screens.entries) {
      testWidgets(entry.key, (tester) async {
        await pump(tester, entry.value.$1, entry.value.$2);

        expect(tester.takeException(), isNull);
        expect(find.text('Housing Directorate'), findsOneWidget);
      });
    }
  });

  testWidgets('the queue filters by state and opens an allocation', (
    tester,
  ) async {
    final cubit = await pump(
      tester,
      Routes.staffAllocations,
      const HousingAllocationsPage(),
    );

    expect(find.text('Zainab Yusuf'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Held'));
    await tester.pumpAndSettle();

    expect(cubit.state.filter, AllocationQueueFilter.held);
    expect(find.text('Zainab Yusuf'), findsNothing);
    expect(find.text('Amaka Bello'), findsOneWidget);
  });

  testWidgets('an empty hostel says nobody lives there yet', (tester) async {
    await pump(
      tester,
      Routes.staffOccupants('tafawa'),
      const HousingOccupantsPage(hostelId: 'tafawa'),
    );

    expect(find.text('Nobody lives here yet'), findsOneWidget);
  });

  testWidgets('an occupied hostel lists its residents', (tester) async {
    await pump(
      tester,
      Routes.staffOccupants('amina'),
      const HousingOccupantsPage(hostelId: 'amina'),
    );

    expect(find.text('Ifeoma Nwosu'), findsOneWidget);
    expect(find.text('Nobody lives here yet'), findsNothing);
  });

  testWidgets('a sheet with row problems lists all five and applies none', (
    tester,
  ) async {
    final cubit = await pump(
      tester,
      Routes.staffUpload,
      const HousingUploadPage(),
    );

    await tester.tap(find.text('Use a sheet with row problems'));
    await tester.pumpAndSettle();

    expect(cubit.state.upload.status, UploadStatus.rowErrors);
    for (final row in [4, 9, 15, 22, 31]) {
      expect(find.text('Row $row'), findsOneWidget);
    }
    expect(find.text('Batch applied'), findsNothing);
  });

  testWidgets('a sheet without a header says which column is missing', (
    tester,
  ) async {
    await pump(tester, Routes.staffUpload, const HousingUploadPage());

    await tester.tap(find.text('Use a sheet with a missing column'));
    await tester.pumpAndSettle();

    expect(find.textContaining('"matric_number"'), findsOneWidget);
  });

  testWidgets('a correct sheet is applied as one batch', (tester) async {
    await pump(tester, Routes.staffUpload, const HousingUploadPage());

    await tester.tap(find.text('Use a correct sample sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Batch applied'), findsOneWidget);
    expect(find.textContaining('BATCH-2026-'), findsOneWidget);
  });

  testWidgets('keep-my-room confirms, then reports who was skipped', (
    tester,
  ) async {
    final cubit = await pump(
      tester,
      Routes.staffKeepMyRoom,
      const HousingKeepMyRoomPage(),
    );

    await tester.tap(find.text('Send offers'));
    await tester.pumpAndSettle();
    expect(cubit.state.keepOutcome, isNull);

    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Send offers'),
      ),
    );
    await tester.pumpAndSettle();

    expect(cubit.state.keepOutcome, isNotNull);
    expect(find.text('Offers sent'), findsOneWidget);
    expect(find.text('Tunde Bakare'), findsOneWidget);
  });

  testWidgets('allocating by hand needs a bed picked, then reports success', (
    tester,
  ) async {
    final cubit = await pump(
      tester,
      Routes.staffAllocate,
      const HousingAllocatePage(),
    );

    await tester.enterText(find.byType(TextField), '24/ENG/0128');
    await tester.tap(find.widgetWithText(ChoiceChip, 'Amina Hall'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Block B · 101'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, '1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allocate bed'));
    await tester.pumpAndSettle();

    expect(cubit.state.handOutcome.status, HandAllocationStatus.allocated);
    expect(find.text('Bed allocated'), findsOneWidget);
  });

  testWidgets('the refund simulator shows what a cancellation hands back', (
    tester,
  ) async {
    final cubit = await pump(
      tester,
      Routes.staffRefunds,
      const HousingRefundsPage(),
    );

    await tester.ensureVisible(find.text('Simulate'));
    await tester.tap(find.text('Simulate'));
    await tester.pumpAndSettle();

    expect(cubit.state.refundSimulation, isNotNull);
    expect(find.text('Refunded to wallet'), findsOneWidget);
  });

  testWidgets('openings has openings, prices and refunds tabs', (tester) async {
    await pump(tester, Routes.staffOpenings, const HousingOpeningsPage());
    expect(find.text('2026/2027-1'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Prices'));
    await tester.pumpAndSettle();
    expect(find.text('Bed price by room type'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Refunds'));
    await tester.pumpAndSettle();
    expect(find.text('Open the refund simulator'), findsOneWidget);
  });
}
