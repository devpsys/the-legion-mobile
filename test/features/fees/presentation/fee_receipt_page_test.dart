import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/utils/responsive.dart';
import 'package:the_legion_mobile/core/widgets/verification_qr_mark.dart';
import 'package:the_legion_mobile/features/fees/presentation/bloc/fee_receipt_cubit.dart';
import 'package:the_legion_mobile/features/fees/presentation/pages/fee_receipt_page.dart';
import 'package:the_legion_mobile/features/fees/presentation/widgets/receipt_document.dart';

void main() {
  late FeeReceiptCubit cubit;

  setUp(() => cubit = FeeReceiptCubit());
  tearDown(() => cubit.close());

  Future<void> pumpReceipt(
    WidgetTester tester, {
    String id = 'rec-098812',
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 2200) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<FeeReceiptCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: FeeReceiptPage(receiptId: id),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('draws the paper with settlement and verification code', (
    tester,
  ) async {
    await pumpReceipt(tester);

    expect(find.byType(ReceiptDocument), findsOneWidget);
    expect(find.byType(VerificationQrMark), findsOneWidget);
    final qr = tester.widget<VerificationQrMark>(
      find.byType(VerificationQrMark),
    );
    expect(tester.getSize(find.byWidget(qr)).width, AppDimensions.qrTile);
    expect(find.textContaining('Clearance receipt'), findsOneWidget);
    expect(find.text('REC-2027-098812'), findsWidgets);
    expect(find.text('Amaka Bello'), findsOneWidget);
    expect(find.text('23/CSC/0412'), findsOneWidget);
    expect(find.text('PAID'), findsWidgets);
    expect(find.text('Total paid & cleared'), findsOneWidget);
    expect(find.text('SETTLED'), findsOneWidget);
    expect(find.text('9K8L-4M2P-TX77'), findsOneWidget);
    expect(find.text('Interswitch / Mastercard'), findsOneWidget);

    // Amount and status sit on one line — not letter-wrapped in a tiny column.
    final amount = find.text('₦66,350.00').last;
    expect(tester.getSize(amount).height, lessThan(AppDimensions.iconLarge));
    final paid = find.text('PAID').first;
    expect(tester.getSize(paid).height, lessThan(AppDimensions.iconLarge));
  });

  testWidgets('copies the verification code', (tester) async {
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

    await pumpReceipt(tester);
    await tester.tap(find.text('Copy verification code'));
    await tester.pumpAndSettle();

    final copy = calls.singleWhere((c) => c.method == 'Clipboard.setData');
    expect(copy.arguments, {'text': '9K8L-4M2P-TX77'});
    expect(find.text('Verification code copied.'), findsOneWidget);
  });

  testWidgets('renders in dark mode with a light paper', (tester) async {
    await pumpReceipt(tester, dark: true);
    expect(find.byType(ReceiptDocument), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
