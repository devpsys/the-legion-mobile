import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_checkout_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fees_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/models/fees_models.dart';
import 'package:the_legion_mobile/features/fees/presentation/pages/fee_checkout_page.dart';
import 'package:the_legion_mobile/features/fees/presentation/widgets/checkout_option_tile.dart';
import 'package:the_legion_mobile/features/fees/presentation/widgets/payment_amount_card.dart';

/// The checkout: what is owed, how much to pay now, how, and by whom.
void main() {
  /// The instalment's text field, present only while that option is chosen.
  Finder instalmentField() => find.descendant(
    of: find.byType(InstalmentField),
    matching: find.byType(TextField),
  );

  late FeesCubit fees;
  late FeeCheckoutCubit checkout;

  setUp(() {
    fees = FeesCubit();
    checkout = FeeCheckoutCubit();
  });
  tearDown(() async {
    await fees.close();
    await checkout.close();
  });

  void setViewport(WidgetTester tester, Size size) {
    tester.view
      ..physicalSize = size * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  Widget host(Widget child) => MultiBlocProvider(
    providers: [
      BlocProvider<FeesCubit>.value(value: fees),
      BlocProvider<FeeCheckoutCubit>.value(value: checkout),
    ],
    child: child,
  );

  Future<void> pumpCheckout(
    WidgetTester tester, {
    List<String> invoiceIds = const [],
    Size size = const Size(390, 2400),
    bool dark = false,
  }) async {
    setViewport(tester, size);

    await tester.pumpWidget(
      host(
        MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FeeCheckoutPage(invoiceIds: invoiceIds),
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

  /// The docked button, found through its label's prefix.
  Finder proceedButton() => find.ancestor(
    of: find.textContaining('Proceed to pay'),
    matching: find.byType(FilledButton),
  );

  bool isEnabled(WidgetTester tester, Finder button) =>
      tester.widget<FilledButton>(button).onPressed != null;

  group('starting the visit', () {
    testWidgets('reads the ledger and takes every open invoice', (
      tester,
    ) async {
      await pumpCheckout(tester);

      expect(fees.state.student, isNotNull);
      expect(checkout.state.invoices.map((i) => i.id), [
        'inv-08821',
        'inv-09104',
      ]);
      expect(checkout.state.balanceMinorUnits, 6600000);
    });

    testWidgets('takes only the invoice the link names', (tester) async {
      await pumpCheckout(tester, invoiceIds: ['inv-09104']);

      expect(checkout.state.invoices.map((i) => i.id), ['inv-09104']);
      expect(find.text('INV-2026-08821'), findsNothing);
      expect(find.text('Proceed to pay ₦16,350.00'), findsOneWidget);
    });

    testWidgets('says so when the link names nothing open', (tester) async {
      await pumpCheckout(tester, invoiceIds: ['nope']);

      expect(
        find.text('There is nothing to pay on these invoices.'),
        findsOneWidget,
      );
      expect(find.textContaining('Proceed to pay'), findsNothing);
    });
  });

  group('the bar', () {
    testWidgets('names the task and says it is secure', (tester) async {
      await pumpCheckout(tester);

      expect(find.text('Make payment'), findsOneWidget);
      expect(
        find.textContaining('Official bursary payment gateway'),
        findsOneWidget,
      );
      expect(find.text('SECURE'), findsOneWidget);
      expect(find.byTooltip('Back to your fees'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsNothing);
    });

    testWidgets('back pops to the tab it was opened from', (tester) async {
      setViewport(tester, const Size(390, 2400));
      final router = GoRouter(
        initialLocation: Routes.feesCheckout,
        routes: [
          GoRoute(
            path: Routes.fees,
            name: Routes.feesName,
            builder: (_, _) => const Text('fees tab'),
            routes: [
              GoRoute(
                path: Routes.feesCheckoutSegment,
                name: Routes.feesCheckoutName,
                builder: (_, _) => const FeeCheckoutPage(invoiceIds: []),
              ),
            ],
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
      expect(find.text('Make payment'), findsOneWidget);

      await tester.tap(find.byTooltip('Back to your fees'));
      await tester.pumpAndSettle();

      expect(find.text('fees tab'), findsOneWidget);
      expect(find.text('Make payment'), findsNothing);
    });
  });

  group('the payment details', () {
    testWidgets('list the invoices, the lines, the charge and the total', (
      tester,
    ) async {
      await pumpCheckout(tester);

      expect(find.text('PAYMENT DETAILS'), findsOneWidget);
      expect(find.text('Term: 2026/2027'), findsOneWidget);
      expect(find.text('INV-2026-08821'), findsOneWidget);
      expect(find.text('INV-2026-09104'), findsOneWidget);
      expect(find.text('300 Level Composite Tuition'), findsOneWidget);
      expect(find.text('Faculty of Science ICT & Lab Levy'), findsOneWidget);
      expect(find.text('Tuition balance (300 Level)'), findsOneWidget);
      expect(find.text('₦50,000.00'), findsOneWidget);
      expect(find.text('Faculty ICT & Lab levy'), findsOneWidget);
      expect(find.text('₦16,000.00'), findsOneWidget);
      expect(
        find.text('Gateway processing charge (statutory)'),
        findsOneWidget,
      );
      expect(find.text('₦350.00'), findsOneWidget);
      expect(find.text('Total amount payable'), findsOneWidget);
      // The total bar and the full-balance option quote the same figure.
      expect(find.text('₦66,350.00'), findsNWidgets(2));
      expect(find.text('Proceed to pay ₦66,350.00'), findsOneWidget);
    });

    testWidgets('explain whose the charge is on demand', (tester) async {
      await pumpCheckout(tester);

      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.text(
          'A statutory charge collected by the payment gateway, not by the '
          'university.',
        ),
        findsOneWidget,
      );
    });
  });

  group('the amount', () {
    testWidgets('offers the full balance, chosen, and an instalment', (
      tester,
    ) async {
      await pumpCheckout(tester);

      expect(find.text('SELECT PAYMENT AMOUNT'), findsOneWidget);
      expect(find.text('Pay full balance'), findsOneWidget);
      expect(
        find.text('Clears your course enrolment hold immediately'),
        findsOneWidget,
      );
      expect(find.text('Pay a custom instalment'), findsOneWidget);
      expect(
        find.text('Minimum permitted instalment: ₦25,000.00'),
        findsOneWidget,
      );
      expect(find.byType(Radio<PaymentAmountMode>), findsNWidgets(2));
      expect(instalmentField(), findsNothing);
      expect(isEnabled(tester, proceedButton()), isTrue);
    });

    testWidgets('withholds the instalment when the balance is under the '
        'minimum', (tester) async {
      await pumpCheckout(tester, invoiceIds: ['inv-09104']);

      expect(find.text('Pay full balance'), findsOneWidget);
      expect(find.text('Pay a custom instalment'), findsNothing);
      expect(find.byType(Radio<PaymentAmountMode>), findsOneWidget);
    });

    testWidgets('opens the field holding the balance when chosen', (
      tester,
    ) async {
      await pumpCheckout(tester);

      await tapText(tester, 'Pay a custom instalment');

      expect(checkout.state.amountMode, PaymentAmountMode.instalment);
      expect(find.text('SPECIFIED PAYMENT AMOUNT'), findsOneWidget);
      final field = tester.widget<TextField>(instalmentField());
      expect(field.controller?.text, '66,000.00');
      expect(checkout.state.instalmentMinorUnits, 6600000);
      // Same figure as the full balance, so the button says the same thing.
      expect(find.text('Proceed to pay ₦66,350.00'), findsOneWidget);
      expect(isEnabled(tester, proceedButton()), isTrue);
    });

    testWidgets('re-prices the button from what is typed', (tester) async {
      await pumpCheckout(tester);
      await tapText(tester, 'Pay a custom instalment');

      await tester.enterText(instalmentField(), '30000');
      await tester.pumpAndSettle();

      expect(checkout.state.instalmentMinorUnits, 3000000);
      expect(find.text('Proceed to pay ₦30,350.00'), findsOneWidget);
      expect(isEnabled(tester, proceedButton()), isTrue);
    });

    testWidgets('refuses too little, and says how little is too little', (
      tester,
    ) async {
      await pumpCheckout(tester);
      await tapText(tester, 'Pay a custom instalment');

      await tester.enterText(instalmentField(), '1000');
      await tester.pumpAndSettle();

      expect(find.text('Enter at least ₦25,000.00.'), findsOneWidget);
      expect(isEnabled(tester, proceedButton()), isFalse);
    });

    testWidgets('refuses more than is owed', (tester) async {
      await pumpCheckout(tester);
      await tapText(tester, 'Pay a custom instalment');

      await tester.enterText(instalmentField(), '70000');
      await tester.pumpAndSettle();

      expect(
        find.text('Enter no more than ₦66,000.00, the balance owed.'),
        findsOneWidget,
      );
      expect(isEnabled(tester, proceedButton()), isFalse);
    });

    testWidgets('an empty field disables the button without scolding', (
      tester,
    ) async {
      await pumpCheckout(tester);
      await tapText(tester, 'Pay a custom instalment');

      await tester.enterText(instalmentField(), '');
      await tester.pumpAndSettle();

      expect(checkout.state.instalmentMinorUnits, isNull);
      expect(find.text('Proceed to pay'), findsOneWidget);
      expect(isEnabled(tester, proceedButton()), isFalse);
      expect(find.textContaining('Enter '), findsNothing);
    });

    testWidgets('going back to the full balance restores the full figure', (
      tester,
    ) async {
      await pumpCheckout(tester);
      await tapText(tester, 'Pay a custom instalment');
      await tester.enterText(instalmentField(), '1000');
      await tester.pumpAndSettle();
      expect(isEnabled(tester, proceedButton()), isFalse);

      await tapText(tester, 'Pay full balance');

      expect(checkout.state.amountMode, PaymentAmountMode.full);
      expect(instalmentField(), findsNothing);
      expect(find.text('Proceed to pay ₦66,350.00'), findsOneWidget);
      expect(isEnabled(tester, proceedButton()), isTrue);
    });
  });

  group('the method', () {
    testWidgets('offers three ways to pay and says when each clears', (
      tester,
    ) async {
      await pumpCheckout(tester);

      expect(find.text('PAYMENT METHOD'), findsOneWidget);
      expect(find.text('Verified integrations'), findsOneWidget);
      expect(find.text('Card & instant bank transfer'), findsOneWidget);
      expect(find.text('Instant'), findsNWidgets(2));
      expect(find.text('Debit card'), findsOneWidget);
      expect(find.text('USSD'), findsOneWidget);
      expect(find.text('Direct debit'), findsOneWidget);
      expect(find.text('Bank branch via RRR invoice'), findsOneWidget);
      expect(find.text('1–24h clearing'), findsOneWidget);
      expect(find.text('RRR: 2409-8812-9014'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
      expect(
        find.text('NIP dedicated student virtual account'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Single-use account generated specifically for matric 23/CSC/0412.',
        ),
        findsOneWidget,
      );
      expect(find.byType(Radio<PaymentMethod>), findsNWidgets(3));
      expect(checkout.state.method, PaymentMethod.gateway);
    });

    testWidgets('records the method the student picks', (tester) async {
      await pumpCheckout(tester);

      await tapText(tester, 'Bank branch via RRR invoice');
      expect(checkout.state.method, PaymentMethod.bankBranch);

      final tiles = tester.widgetList<CheckoutOptionTile<PaymentMethod>>(
        find.byType(CheckoutOptionTile<PaymentMethod>),
      );
      expect(tiles.map((tile) => tile.isSelected), [false, true, false]);

      await tapText(tester, 'NIP dedicated student virtual account');
      expect(checkout.state.method, PaymentMethod.virtualAccount);
    });

    testWidgets('copies the bank branch reference', (tester) async {
      // The clipboard is a platform service; stand in for it and record
      // what was handed over.
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          calls.add(call);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pumpCheckout(tester);

      await tapText(tester, 'Copy');

      final copy = calls.singleWhere(
        (call) => call.method == 'Clipboard.setData',
      );
      expect(copy.arguments, {'text': '2409-8812-9014'});
      expect(find.text('Reference copied.'), findsOneWidget);
    });
  });

  group('the payer', () {
    testWidgets('is the record, read-only', (tester) async {
      await pumpCheckout(tester);

      expect(find.text('PAYER VERIFICATION'), findsOneWidget);
      expect(find.text('Verified record'), findsOneWidget);
      expect(find.text('Student name'), findsOneWidget);
      expect(find.text('Amaka Bello'), findsOneWidget);
      expect(find.text('Matriculation number'), findsOneWidget);
      expect(find.text('23/CSC/0412'), findsOneWidget);
      expect(find.text('Academic department'), findsOneWidget);
      expect(find.text('Computer Science (300 Level)'), findsOneWidget);
      expect(find.text('Institutional email'), findsOneWidget);
      expect(find.text('amaka.bello@legion.edu.ng'), findsOneWidget);
      expect(
        find.byType(TextField),
        findsNothing,
        reason: 'nothing on the record is edited at a checkout',
      );
    });
  });

  group('the footer', () {
    testWidgets('is docked, names the figure, and opens the card checkout', (
      tester,
    ) async {
      setViewport(tester, const Size(390, 844));
      final router = GoRouter(
        initialLocation: Routes.feesCheckout,
        routes: [
          GoRoute(
            path: Routes.fees,
            name: Routes.feesName,
            builder: (_, _) => const Text('fees tab'),
            routes: [
              GoRoute(
                path: Routes.feesCheckoutSegment,
                name: Routes.feesCheckoutName,
                builder: (_, _) => const FeeCheckoutPage(invoiceIds: []),
                routes: [
                  GoRoute(
                    path: Routes.feesCardCheckoutSegment,
                    name: Routes.feesCardCheckoutName,
                    builder: (_, _) => const Text('card checkout'),
                  ),
                ],
              ),
            ],
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

      expect(find.text('Proceed to pay ₦66,350.00'), findsOneWidget);
      expect(find.textContaining('Encrypted 256-bit TLS'), findsOneWidget);

      await tester.tap(find.text('Proceed to pay ₦66,350.00'));
      await tester.pumpAndSettle();

      expect(find.text('card checkout'), findsOneWidget);
    });

    testWidgets('bank branch still says the service is not live', (
      tester,
    ) async {
      await pumpCheckout(tester, size: const Size(390, 844));

      await tapText(tester, 'Bank branch via RRR invoice');
      await tester.tap(find.text('Proceed to pay ₦66,350.00'));
      await tester.pumpAndSettle();

      expect(
        find.text('This service goes live with the next release.'),
        findsOneWidget,
      );
    });
  });

  group('layout', () {
    for (final width in [320.0, 390.0, 768.0, 1280.0]) {
      testWidgets('lays out at ${width.toInt()}px without overflowing', (
        tester,
      ) async {
        await pumpCheckout(tester, size: Size(width, 2400));
        await tapText(tester, 'Pay a custom instalment');

        expect(find.text('Make payment'), findsOneWidget);
        expect(find.text('Proceed to pay ₦66,350.00'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('renders in dark mode', (tester) async {
      await pumpCheckout(tester, dark: true);

      expect(find.text('₦66,350.00'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  });
}
