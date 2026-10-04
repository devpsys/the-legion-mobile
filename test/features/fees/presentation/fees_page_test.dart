import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/widgets/notification_bell.dart';
import 'package:the_legion_mobile/core/widgets/status_tag.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fees_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';
import 'package:the_legion_mobile/features/fees/presentation/models/fees_models.dart';
import 'package:the_legion_mobile/features/fees/presentation/pages/fees_page.dart';
import 'package:the_legion_mobile/features/fees/presentation/widgets/bursary_notice_card.dart';
import 'package:the_legion_mobile/features/fees/presentation/widgets/invoice_card.dart';
import 'package:the_legion_mobile/features/fees/presentation/widgets/outstanding_balance_card.dart';
import 'package:the_legion_mobile/features/fees/presentation/widgets/payment_record_card.dart';

/// The fees tab: the ledger's figures, drawn once each from the same record.
void main() {
  late FeesCubit cubit;

  setUp(() => cubit = FeesCubit());
  tearDown(() => cubit.close());

  void setViewport(WidgetTester tester, Size size) {
    tester.view
      ..physicalSize = size * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  /// The providers every fees screen reads: the ledger, and the bell's
  /// notification centre, which the app provides above the router.
  Widget host(Widget child) => MultiBlocProvider(
    providers: [
      BlocProvider<FeesCubit>.value(value: cubit),
      BlocProvider<NotificationCubit>.value(
        value: NotificationCubit(entries: NotificationFixtures.entries),
      ),
    ],
    child: child,
  );

  Future<void> pumpFees(
    WidgetTester tester, {
    Size size = const Size(390, 2600),
    bool dark = false,
  }) async {
    setViewport(tester, size);

    await tester.pumpWidget(
      host(
        MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FeesPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The tab under a router with the checkout and the hub as stand-ins, so
  /// every "pay" can be followed to where it goes and with what.
  Future<void> pumpFeesWithRouter(WidgetTester tester) async {
    setViewport(tester, const Size(390, 2600));

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const FeesPage()),
        GoRoute(
          path: Routes.feesCheckout,
          name: Routes.feesCheckoutName,
          builder: (_, state) => Text('checkout:${state.uri.query}'),
        ),
        GoRoute(
          path: Routes.home,
          name: Routes.homeName,
          builder: (_, _) => const Text('hub'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      host(
        MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.pumpAndSettle();
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  group('loading', () {
    testWidgets('reads the ledger on entry', (tester) async {
      await pumpFees(tester);

      expect(cubit.state.student, FeesFixtures.student);
      expect(find.text('Student fees'), findsOneWidget);
    });
  });

  group('the bar and the header', () {
    testWidgets('names the bursary, the screen and the student', (
      tester,
    ) async {
      await pumpFees(tester);

      expect(find.text('THE LEGION UNIVERSITY'), findsOneWidget);
      expect(find.byType(NotificationBell), findsOneWidget);
      expect(find.byTooltip('Back to the hub'), findsOneWidget);
      expect(find.text('BURSARY & FINANCIAL SERVICES'), findsOneWidget);
      expect(find.text('Student fees'), findsOneWidget);
      expect(
        find.textContaining('Amaka Bello', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('23/CSC/0412', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('· 300 Level', findRichText: true),
        findsOneWidget,
        reason: 'the level is on the byline, after the matric number',
      );
    });
  });

  group('the outstanding balance', () {
    testWidgets('sums the open invoices and names the deadline', (
      tester,
    ) async {
      await pumpFees(tester);

      expect(find.text('TOTAL OUTSTANDING BALANCE'), findsOneWidget);
      expect(find.text('₦66,000.00'), findsOneWidget);
      // Once on the hero's pill, once under the unpaid levy.
      expect(find.text('Due 15 March 2027'), findsNWidgets(2));
      expect(find.text('Pay outstanding balance (₦66,000.00)'), findsOneWidget);
      expect(find.textContaining('instant bursary clearance'), findsOneWidget);
    });

    testWidgets('breaks the total down by invoice', (tester) async {
      await pumpFees(tester);

      final strip = find.byType(OutstandingBreakdownStrip);
      expect(strip, findsOneWidget);
      expect(
        find.descendant(of: strip, matching: find.text('Tuition balance')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: strip, matching: find.text('₦50,000.00')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: strip, matching: find.text('Faculty levy')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: strip, matching: find.text('₦16,000.00')),
        findsOneWidget,
      );
    });

    testWidgets('offers no payment when nothing is owed', (tester) async {
      await cubit.close();
      cubit = FeesCubit(
        ledger: FeesLedger(
          student: FeesFixtures.student,
          session: FeesFixtures.session,
          invoices: [
            Invoice(
              id: 'inv-settled',
              reference: 'INV-2026-00001',
              title: 'Settled bill',
              subtitle: 'Faculty of Science',
              shortLabel: 'Settled',
              lineLabel: 'Settled',
              session: FeesFixtures.session,
              status: InvoiceStatus.paid,
              totalMinorUnits: 1000000,
              paidMinorUnits: 1000000,
              dueOn: DateTime(2027),
            ),
          ],
          payments: const [],
          terms: FeesFixtures.terms,
        ),
      );
      await pumpFees(tester);

      expect(find.text('₦0.00'), findsOneWidget);
      expect(find.text('Nothing is owed on your account.'), findsOneWidget);
      expect(find.textContaining('Pay outstanding balance'), findsNothing);
      expect(find.byType(OutstandingBreakdownStrip), findsNothing);
      expect(find.text('All settled'), findsOneWidget);
      expect(find.text('Settled'), findsOneWidget);
      expect(find.text('No payments have been recorded yet.'), findsOneWidget);
      expect(find.text('View all'), findsNothing);
      // A settled bill shows its ledger and offers nothing.
      expect(find.text('Total billed'), findsOneWidget);
      expect(find.text('Remaining balance'), findsNothing);
      expect(find.textContaining('Pay '), findsNothing);
    });
  });

  group('the invoices', () {
    testWidgets('are headed with the session and the open count', (
      tester,
    ) async {
      await pumpFees(tester);

      expect(find.text('2026/2027 invoices'), findsOneWidget);
      expect(find.text('2 pending'), findsOneWidget);
      expect(find.byType(InvoiceCard), findsNWidgets(2));
    });

    testWidgets('show a part-paid bill as a ledger with a bar', (tester) async {
      await pumpFees(tester);

      expect(find.text('INV-2026-08821'), findsOneWidget);
      expect(find.text('Part paid'), findsOneWidget);
      expect(find.text('300 Level Composite Tuition'), findsOneWidget);
      expect(
        find.text('Faculty of Science · Computer Science'),
        findsNWidgets(2),
      );
      expect(find.text('Total billed'), findsOneWidget);
      expect(find.text('₦165,000.00'), findsOneWidget);
      expect(find.text('Amount cleared'), findsOneWidget);
      expect(find.text('Remaining balance'), findsOneWidget);
      expect(find.text('Payment progress'), findsOneWidget);
      expect(find.text('70%'), findsOneWidget);
      expect(find.text('Pay balance ₦50,000.00'), findsOneWidget);
      expect(find.text('Breakdown'), findsOneWidget);

      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, closeTo(115 / 165, 0.001));
    });

    testWidgets('show an unpaid bill as one figure and its deadline', (
      tester,
    ) async {
      await pumpFees(tester);

      expect(find.text('INV-2026-09104'), findsOneWidget);
      expect(find.text('Unpaid'), findsOneWidget);
      expect(find.text('Faculty of Science ICT & Lab Levy'), findsOneWidget);
      expect(find.text('AMOUNT'), findsOneWidget);
      expect(find.text('Pay ₦16,000.00'), findsOneWidget);
      expect(
        find.byType(LinearProgressIndicator),
        findsOneWidget,
        reason: 'no progress to draw on a bill nothing was paid on',
      );
    });

    testWidgets('colour the statuses by urgency', (tester) async {
      await pumpFees(tester);

      final tags = tester
          .widgetList<StatusTag>(find.byType(StatusTag))
          .where((tag) => tag.label == 'Part paid' || tag.label == 'Unpaid')
          .toList();
      expect(tags.map((tag) => tag.tone), [
        InvoiceStatus.partiallyPaid.tone,
        InvoiceStatus.open.tone,
      ]);
    });

    testWidgets('the breakdown is not live yet', (tester) async {
      await pumpFees(tester);

      await tapText(tester, 'Breakdown');

      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
      );
    });
  });

  group('the payment history', () {
    testWidgets('lists every receipt with how it was paid', (tester) async {
      await pumpFees(tester);

      expect(find.text('Payment history & receipts'), findsOneWidget);
      expect(find.text('View all'), findsOneWidget);
      expect(find.byType(PaymentRecordCard), findsNWidgets(2));
      expect(find.text('REC-2026-04412'), findsOneWidget);
      expect(find.text('Successful'), findsNWidgets(2));
      expect(find.text('Tuition Instalment 1'), findsOneWidget);
      expect(
        find.text('12 Jan 2027 · Remita RRR 2401-9982-1102'),
        findsOneWidget,
      );
      expect(find.text('REC-2026-01009'), findsOneWidget);
      expect(find.text('₦12,500.00'), findsOneWidget);
      expect(find.text('Departmental Dues (CSC)'), findsOneWidget);
      expect(find.text('15 Oct 2026 · Card'), findsOneWidget);
      expect(find.text('Receipt PDF'), findsNWidgets(2));
    });

    testWidgets('the receipts and the full history are not live yet', (
      tester,
    ) async {
      await pumpFees(tester);

      await tapText(tester, 'View all');
      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('Receipt PDF').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Receipt PDF').first);
      await tester.pumpAndSettle();
      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
      );
    });
  });

  group('the bursary notice', () {
    testWidgets('states the policy', (tester) async {
      await pumpFees(tester);

      expect(find.byType(BursaryNoticeCard), findsOneWidget);
      expect(find.text('Institutional bursary notice:'), findsOneWidget);
      expect(
        find.textContaining('Cash payments to staff are strictly prohibited.'),
        findsOneWidget,
      );
    });
  });

  group('paying', () {
    testWidgets('the hero opens the checkout for every open invoice', (
      tester,
    ) async {
      await pumpFeesWithRouter(tester);

      await tapText(tester, 'Pay outstanding balance (₦66,000.00)');

      expect(
        find.text('checkout:'),
        findsOneWidget,
        reason: 'no invoice named means all of them',
      );
    });

    testWidgets('a card opens the checkout for its own invoice', (
      tester,
    ) async {
      await pumpFeesWithRouter(tester);

      await tapText(tester, 'Pay ₦16,000.00');
      expect(find.text('checkout:invoices=inv-09104'), findsOneWidget);
    });

    testWidgets('a part-paid card pays its balance', (tester) async {
      await pumpFeesWithRouter(tester);

      await tapText(tester, 'Pay balance ₦50,000.00');
      expect(find.text('checkout:invoices=inv-08821'), findsOneWidget);
    });

    testWidgets('the bar leads back to the hub', (tester) async {
      await pumpFeesWithRouter(tester);

      await tester.tap(find.byTooltip('Back to the hub'));
      await tester.pumpAndSettle();

      expect(find.text('hub'), findsOneWidget);
    });
  });

  group('layout', () {
    for (final width in [320.0, 390.0, 768.0, 1280.0]) {
      testWidgets('lays out at ${width.toInt()}px without overflowing', (
        tester,
      ) async {
        await pumpFees(tester, size: Size(width, 2600));

        expect(find.text('Student fees'), findsOneWidget);
        expect(find.byType(InvoiceCard), findsNWidgets(2));
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('renders in dark mode', (tester) async {
      await pumpFees(tester, dark: true);

      expect(find.text('₦66,000.00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
