import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_card_checkout_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_checkout_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fees_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';
import 'package:the_legion_mobile/features/fees/presentation/pages/fee_card_checkout_page.dart';

void main() {
  late FeesCubit fees;
  late FeeCheckoutCubit checkout;
  late FeeCardCheckoutCubit card;

  setUp(() {
    fees = FeesCubit()..load();
    checkout = FeeCheckoutCubit()
      ..start(invoices: FeesFixtures.invoices, terms: FeesFixtures.terms);
    card = FeeCardCheckoutCubit();
  });
  tearDown(() async {
    await fees.close();
    await checkout.close();
    await card.close();
  });

  Widget host(Widget child) => MultiBlocProvider(
    providers: [
      BlocProvider<FeesCubit>.value(value: fees),
      BlocProvider<FeeCheckoutCubit>.value(value: checkout),
      BlocProvider<FeeCardCheckoutCubit>.value(value: card),
    ],
    child: child,
  );

  Future<void> pumpCard(WidgetTester tester, {bool dark = false}) async {
    tester.view
      ..physicalSize = const Size(390, 2200) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      host(
        MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const FeeCardCheckoutPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the schedule, networks and card fields', (tester) async {
    await pumpCard(tester);

    expect(find.text('Card checkout'), findsOneWidget);
    expect(find.text('Fee breakdown'), findsOneWidget);
    expect(find.text('Tuition balance'), findsOneWidget);
    expect(find.text('Faculty levy'), findsOneWidget);
    expect(find.text('Pay ₦66,350.00'), findsOneWidget);
    expect(find.text('Mastercard'), findsOneWidget);
    expect(find.text('Card number'), findsOneWidget);
    expect(find.text('Cancel and return to fees'), findsOneWidget);
  });

  testWidgets('Pay opens the gateway return as awaiting confirmation', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/card',
      routes: [
        GoRoute(path: '/card', builder: (_, _) => const FeeCardCheckoutPage()),
        GoRoute(
          path: Routes.feesGatewayReturn,
          name: Routes.feesGatewayReturnName,
          builder: (_, state) => Text(
            'return:${state.uri.queryParameters[Routes.feesGatewayReturnRefParam]}',
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    tester.view
      ..physicalSize = const Size(390, 2200) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

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

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '5399123456784012');
    await tester.enterText(fields.at(1), '1228');
    await tester.enterText(fields.at(2), '123');
    await tester.enterText(fields.at(3), '1234');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pay ₦66,350.00'));
    await tester.pumpAndSettle();

    expect(
      find.text('return:${FeesFixtures.pendingTransactionReference}'),
      findsOneWidget,
    );
  });
}
