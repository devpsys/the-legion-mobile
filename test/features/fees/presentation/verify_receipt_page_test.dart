import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/widgets/brand_crest_tile.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/receipt_verification_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/mock/fees_fixtures.dart';
import 'package:the_legion_mobile/features/fees/presentation/pages/verify_receipt_page.dart';

void main() {
  late ReceiptVerificationCubit cubit;

  setUp(() => cubit = ReceiptVerificationCubit());
  tearDown(() => cubit.close());

  Future<void> pumpPage(
    WidgetTester tester, {
    String? initialCode,
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 1400) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<ReceiptVerificationCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: VerifyReceiptPage(initialCode: initialCode),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('stands alone with brand block and privacy disclosure', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.byType(AppBar), findsNothing);
    expect(find.byType(BrandCrestTile), findsOneWidget);
    expect(find.text('Bursary receipt verification'), findsOneWidget);
    expect(find.text('Verify a receipt'), findsOneWidget);
    expect(find.textContaining('Privacy & redaction'), findsOneWidget);
    expect(find.text('Sign in to the student portal'), findsOneWidget);
  });

  testWidgets('shows only the five public facts — never a matric', (
    tester,
  ) async {
    await pumpPage(tester, initialCode: FeesFixtures.receiptVerificationCode);

    expect(find.text('Genuine bursary receipt'), findsOneWidget);
    expect(find.text('REC-2027-098812'), findsOneWidget);
    expect(find.text('₦66,350.00'), findsOneWidget);
    expect(find.text('Amaka Bello'), findsOneWidget);
    expect(find.text('Tuition balance & faculty levy'), findsOneWidget);
    expect(find.text('15 January 2027'), findsOneWidget);

    // Privacy override: designs show matric; the product must not.
    expect(find.text('23/CSC/0412'), findsNothing);
    expect(find.textContaining('Matric'), findsNothing);
    expect(find.textContaining('amaka.bello@'), findsNothing);
  });

  testWidgets('unknown codes say so', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), 'AAAAAAAAAAAA');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verify receipt'));
    await tester.pumpAndSettle();

    expect(find.text('No receipt matches this code'), findsOneWidget);
  });
}
