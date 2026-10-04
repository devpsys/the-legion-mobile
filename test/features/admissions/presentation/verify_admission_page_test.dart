import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/theme/app_text_styles.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admission_verification_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/pages/verify_admission_page.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/brand_crest_tile.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/status_tag.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/verification_result_card.dart';

/// Public verification of an admission letter: one field, one button, and an
/// answer that repeats what the paper says and nothing more.
void main() {
  late AdmissionVerificationCubit cubit;

  const offeredCode = '7KQ2M9XW4HPA';
  const matriculatedCode = 'P3HD7VQ2TM8K';

  setUp(() => cubit = AdmissionVerificationCubit());
  tearDown(() => cubit.close());

  Future<void> pumpPage(
    WidgetTester tester, {
    String? initialCode,
    Size size = const Size(390, 1400),
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = size * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<AdmissionVerificationCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: VerifyAdmissionPage(initialCode: initialCode),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The "Verify" button as currently rendered.
  FilledButton verifyButton(WidgetTester tester) => tester.widget<FilledButton>(
    find.ancestor(of: find.text('Verify'), matching: find.byType(FilledButton)),
  );

  Future<void> verify(WidgetTester tester, String code) async {
    await tester.enterText(find.byType(TextField), code);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();
  }

  testWidgets('stands alone: brand block, no app bar, no tabs', (tester) async {
    await pumpPage(tester);

    expect(find.byType(AppBar), findsNothing);
    expect(find.byType(BrandCrestTile), findsOneWidget);
    expect(find.text('The Legion University'), findsOneWidget);
    expect(find.text('Admissions verification'), findsOneWidget);
    expect(find.text('Verify an admission'), findsOneWidget);
    expect(
      find.text(
        'Enter the verification code printed at the foot of the admission '
        'letter.',
      ),
      findsOneWidget,
    );
    expect(find.text('Verification code'), findsOneWidget);
    expect(
      find.text('This page shows only what is printed on the letter.'),
      findsOneWidget,
    );
    expect(find.text('Sign in to the portal'), findsOneWidget);
  });

  testWidgets('holds the button until the code has the right shape', (
    tester,
  ) async {
    await pumpPage(tester);
    expect(verifyButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '7KQ2M9');
    await tester.pumpAndSettle();
    expect(verifyButton(tester).onPressed, isNull);

    await tester.enterText(find.byType(TextField), offeredCode);
    await tester.pumpAndSettle();
    expect(verifyButton(tester).onPressed, isNotNull);
  });

  testWidgets('keeps the code in capitals as it is typed', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField), '7kq2 m9xw 4hpa');
    await tester.pumpAndSettle();

    expect(find.text('7KQ2 M9XW 4HPA'), findsOneWidget);
    expect(cubit.state.isCodeComplete, isTrue);
  });

  testWidgets('confirms a genuine offer with what the letter prints', (
    tester,
  ) async {
    await pumpPage(tester);
    await verify(tester, offeredCode);

    expect(find.byType(VerificationResultCard), findsOneWidget);
    expect(find.text('Genuine admission'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Musa Ibrahim'), findsOneWidget);
    expect(find.text('Programme'), findsOneWidget);
    expect(find.text('B.Sc. Computer Science'), findsOneWidget);
    expect(find.text('Department of Computer Science'), findsOneWidget);
    expect(find.text('Level'), findsOneWidget);
    expect(find.text('100 Level'), findsOneWidget);
    expect(find.text('Session'), findsOneWidget);
    expect(find.text('2026/2027'), findsOneWidget);
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Offered on'), findsOneWidget);
    expect(find.text('1 October 2026'), findsOneWidget);

    final tag = tester.widget<StatusTag>(find.byType(StatusTag));
    expect(tag.label, 'Admission offered');

    // An offer has no matric number yet, so the row is not drawn blank.
    expect(find.text('Matric number'), findsNothing);
  });

  testWidgets('weights who and what above the terms beneath them', (
    tester,
  ) async {
    await pumpPage(tester);
    await verify(tester, offeredCode);

    FontWeight? weightOf(String text) =>
        tester.widget<Text>(find.text(text)).style?.fontWeight;

    // The two facts a reader matches against the person in front of them.
    expect(weightOf('Musa Ibrahim'), AppTextStyles.bold);
    expect(weightOf('B.Sc. Computer Science'), AppTextStyles.bold);

    // The terms: a step lighter, so the identity reads first.
    expect(weightOf('100 Level'), AppTextStyles.semiBold);
    expect(weightOf('2026/2027'), AppTextStyles.semiBold);
    expect(weightOf('1 October 2026'), AppTextStyles.semiBold);

    // Labels and the department line stay regular.
    expect(weightOf('Name'), isNot(AppTextStyles.bold));
    expect(
      weightOf('Department of Computer Science'),
      isNot(AppTextStyles.bold),
    );
  });

  testWidgets('shows nothing the letter does not print', (tester) async {
    await pumpPage(tester);
    await verify(tester, offeredCode);

    // The candidate's contact details are the portal's, not the letter's.
    expect(
      find.textContaining(AdmissionsFixtures.candidate.email),
      findsNothing,
    );
    expect(find.textContaining('Gwarinpa'), findsNothing);
    expect(find.textContaining('UTME'), findsNothing);
  });

  testWidgets('adds the matric number once the candidate has one', (
    tester,
  ) async {
    await pumpPage(tester);
    await verify(tester, matriculatedCode);

    expect(find.text('Genuine admission'), findsOneWidget);
    expect(find.text('Matric number'), findsOneWidget);
    expect(find.text('25/ACC/0087'), findsOneWidget);
    expect(find.text('Matriculated'), findsOneWidget);
    expect(find.text('2025/2026'), findsOneWidget);
    expect(find.text('20 August 2025'), findsOneWidget);
  });

  testWidgets('reports a code the register does not know', (tester) async {
    await pumpPage(tester);
    await verify(tester, 'ZZZZZZZZZZZZ');

    expect(find.byType(VerificationNotFoundCard), findsOneWidget);
    expect(find.text('No admission matches this code'), findsOneWidget);
    expect(find.byType(VerificationResultCard), findsNothing);
  });

  testWidgets('drops the answer as soon as the code is edited', (tester) async {
    await pumpPage(tester);
    await verify(tester, offeredCode);
    expect(find.text('Genuine admission'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '7KQ2M9XW4HP');
    await tester.pumpAndSettle();

    expect(find.text('Genuine admission'), findsNothing);
    expect(find.byType(VerificationNotFoundCard), findsNothing);
  });

  testWidgets('checks a code that arrived in the link on arrival', (
    tester,
  ) async {
    await pumpPage(tester, initialCode: ' p3hd7vq2tm8k ');

    expect(find.text('P3HD7VQ2TM8K'), findsOneWidget);
    expect(find.text('Genuine admission'), findsOneWidget);
    expect(find.text('25/ACC/0087'), findsOneWidget);
  });

  for (final width in [320.0, 390.0, 768.0, 1280.0]) {
    testWidgets('lays out at ${width.toInt()}px without overflowing', (
      tester,
    ) async {
      await pumpPage(tester, size: Size(width, 1400));
      await verify(tester, offeredCode);

      expect(tester.takeException(), isNull);
      expect(find.text('Genuine admission'), findsOneWidget);
    });
  }

  testWidgets('renders in the dark theme', (tester) async {
    await pumpPage(tester, dark: true);
    await verify(tester, offeredCode);

    expect(tester.takeException(), isNull);
    expect(find.text('Genuine admission'), findsOneWidget);
  });
}
