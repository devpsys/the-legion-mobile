import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/bloc/accommodation_cubit.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/bloc/accommodation_state.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/mock/accommodation_fixtures.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/models/accommodation_models.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/accommodation_history_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/accommodation_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/accommodation_rooms_page.dart';
import 'package:the_legion_mobile/features/accommodation/presentation/pages/accommodation_terms_page.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

import '../../../../helpers/signed_in_auth_cubit.dart';

void main() {
  late AuthCubit auth;

  setUp(() async {
    auth = await signedInAuthCubit();
  });

  tearDown(() async {
    await auth.close();
  });

  Future<AccommodationCubit> pumpAt(
    WidgetTester tester,
    String location, {
    AccommodationLedger? ledger,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 3200) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final cubit = AccommodationCubit(ledger: ledger);
    addTearDown(cubit.close);

    final router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(
          path: Routes.accommodation,
          name: Routes.accommodationName,
          builder: (_, _) => const AccommodationPage(),
        ),
        GoRoute(
          path: Routes.accommodationTerms,
          name: Routes.accommodationTermsName,
          builder: (_, _) => const AccommodationTermsPage(),
        ),
        GoRoute(
          path: Routes.accommodationRooms,
          name: Routes.accommodationRoomsName,
          builder: (_, _) => const AccommodationRoomsPage(),
        ),
        GoRoute(
          path: Routes.accommodationHistory,
          name: Routes.accommodationHistoryName,
          builder: (_, _) => const AccommodationHistoryPage(),
        ),
        GoRoute(
          path: Routes.fees,
          name: Routes.feesName,
          builder: (_, _) => const Text('fees'),
        ),
        GoRoute(
          path: Routes.profile,
          name: Routes.profileName,
          builder: (_, _) => const Text('profile'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AccommodationCubit>.value(value: cubit),
          BlocProvider<AuthCubit>.value(value: auth),
          BlocProvider<NotificationCubit>.value(
            value: NotificationCubit(entries: NotificationFixtures.entries),
          ),
        ],
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

  group('the hub body follows the phase', () {
    final phases = <String, ({AccommodationLedger ledger, String marker})>{
      'not scheduled': (
        ledger: AccommodationFixtures.notScheduledLedger,
        marker: "Booking for 2026/2027-1 hasn't been scheduled.",
      ),
      'terms to accept': (
        ledger: AccommodationFixtures.needsTermsLedger,
        marker: 'Accept the accommodation terms',
      ),
      'room list': (
        ledger: AccommodationFixtures.roomListLedger,
        marker: 'Rooms you can book',
      ),
      'held': (
        ledger: AccommodationFixtures.ledger,
        marker: 'Total allocation fee',
      ),
      'confirmed': (
        ledger: AccommodationFixtures.confirmedLedger,
        marker: 'Allocation slip',
      ),
      'free bed': (ledger: AccommodationFixtures.freeBedLedger, marker: 'Free'),
      'checked in': (
        ledger: AccommodationFixtures.checkedInLedger,
        marker: 'Residence record',
      ),
    };

    for (final entry in phases.entries) {
      testWidgets(entry.key, (tester) async {
        await pumpAt(tester, Routes.accommodation, ledger: entry.value.ledger);

        expect(tester.takeException(), isNull);
        expect(find.textContaining(entry.value.marker), findsWidgets);
      });
    }
  });

  testWidgets('the term selector shows the waitlist offer for term 2', (
    tester,
  ) async {
    final cubit = await pumpAt(tester, Routes.accommodation);

    await tester.tap(find.text('2026/2027-2').first);
    await tester.pumpAndSettle();

    expect(cubit.state.phase, AllocationPhase.offered);
    expect(find.text('Accept the bed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancelling a held bed asks first, then frees it', (
    tester,
  ) async {
    final cubit = await pumpAt(tester, Routes.accommodation);

    await tester.ensureVisible(find.text('Cancel booking').first);
    await tester.tap(find.text('Cancel booking').first);
    await tester.pumpAndSettle();
    expect(cubit.state.phase, AllocationPhase.held);

    await tester.tap(find.text('Cancel booking').last);
    await tester.pumpAndSettle();

    expect(cubit.state.phase, AllocationPhase.roomList);
    expect(cubit.state.status, AccommodationStatus.ready);
  });

  testWidgets('accepting the terms needs the box ticked', (tester) async {
    final cubit = await pumpAt(
      tester,
      Routes.accommodationTerms,
      ledger: AccommodationFixtures.needsTermsLedger,
    );

    await tester.ensureVisible(find.text('Accept terms'));
    await tester.tap(find.text('Accept terms'));
    await tester.pumpAndSettle();
    expect(cubit.state.phase, AllocationPhase.needsTerms);
    expect(
      find.text('Tick the box to accept the accommodation terms.'),
      findsOneWidget,
    );

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Accept terms'));
    await tester.pumpAndSettle();
    expect(cubit.state.phase, AllocationPhase.roomList);
  });

  testWidgets('the room list books a room after confirming', (tester) async {
    final cubit = await pumpAt(
      tester,
      Routes.accommodationRooms,
      ledger: AccommodationFixtures.roomListLedger,
    );

    expect(find.text('Book room'), findsWidgets);
    await tester.tap(find.text('Book room').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Raise invoice and hold bed'));
    await tester.pumpAndSettle();

    expect(cubit.state.phase, AllocationPhase.held);
  });

  testWidgets('history lists past beds, and shows an empty state without any', (
    tester,
  ) async {
    await pumpAt(tester, Routes.accommodationHistory);
    expect(find.text('Accommodation history'), findsWidgets);
    expect(find.text('No previous accommodation'), findsNothing);
    expect(tester.takeException(), isNull);

    await pumpAt(
      tester,
      Routes.accommodationHistory,
      ledger: AccommodationFixtures.noHistoryLedger,
    );
    expect(find.text('No previous accommodation'), findsOneWidget);
  });
}
