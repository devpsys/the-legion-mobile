import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_gateway_return_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';
import 'package:the_legion_mobile/features/fees/presentation/pages/fee_gateway_return_page.dart';

void main() {
  late FeeGatewayReturnCubit cubit;

  setUp(() => cubit = FeeGatewayReturnCubit());
  tearDown(() => cubit.close());

  Future<void> pumpReturn(
    WidgetTester tester, {
    required String reference,
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 1600) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<FeeGatewayReturnCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FeeGatewayReturnPage(reference: reference),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Pay opens onto awaiting confirmation, never a success', (
    tester,
  ) async {
    await pumpReturn(
      tester,
      reference: FeesFixtures.pendingTransactionReference,
    );

    expect(find.text('AWAITING CONFIRMATION'), findsOneWidget);
    expect(find.text('Payment successful'), findsNothing);
    expect(find.textContaining('You can close this page.'), findsWidgets);
    expect(find.text(FeesFixtures.pendingTransactionReference), findsWidgets);
    expect(find.text('View official receipt'), findsNothing);
  });

  testWidgets('a succeeded return unlocks the receipt', (tester) async {
    final router = GoRouter(
      initialLocation: '/return',
      routes: [
        GoRoute(
          path: '/return',
          builder: (_, _) => FeeGatewayReturnPage(
            reference: FeesFixtures.succeededTransactionReference,
          ),
        ),
        GoRoute(
          path: Routes.feesReceiptTemplate,
          name: Routes.feesReceiptName,
          builder: (_, state) => Text(
            'receipt:${state.pathParameters[Routes.feesReceiptIdParam]}',
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    tester.view
      ..physicalSize = const Size(390, 1600) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<FeeGatewayReturnCubit>.value(
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

    expect(find.text('PAYMENT SUCCESSFUL'), findsOneWidget);
    expect(find.text('Course portal unlocked'), findsOneWidget);
    await tester.tap(find.text('View official receipt'));
    await tester.pumpAndSettle();
    expect(find.text('receipt:rec-098812'), findsOneWidget);
  });

  testWidgets('renders in dark mode', (tester) async {
    await pumpReturn(
      tester,
      reference: FeesFixtures.pendingTransactionReference,
      dark: true,
    );
    expect(find.text('AWAITING CONFIRMATION'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
