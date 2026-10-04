import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/theme/app_colors.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/widgets/brand_crest_tile.dart';
import 'package:the_legion_mobile/core/widgets/emphasised_text.dart';
import 'package:the_legion_mobile/features/admissions/presentation/bloc/admissions_cubit.dart';
import 'package:the_legion_mobile/features/admissions/presentation/mock/admissions_fixtures.dart';
import 'package:the_legion_mobile/features/admissions/presentation/models/application_detail_models.dart';
import 'package:the_legion_mobile/features/admissions/presentation/pages/admission_letter_page.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/admission_letter_document.dart';
import 'package:the_legion_mobile/features/admissions/presentation/widgets/verification_qr_mark.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';

import '../../../helpers/signed_in_auth_cubit.dart';

/// The admission letter: the document the offer and the matriculation both
/// open, drawn from the record and nothing else.
void main() {
  late AdmissionsCubit cubit;
  late AuthCubit auth;

  const offeredId = 'app-00042';
  const matriculatedId = 'app-00377';
  const comingSoon = 'This service goes live with the next release.';

  setUp(() async {
    cubit = AdmissionsCubit();
    auth = await signedInAuthCubit();
  });
  tearDown(() async {
    await cubit.close();
    await auth.close();
  });

  Future<void> pumpLetter(
    WidgetTester tester,
    String applicationId, {
    Size size = const Size(390, 2400),
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = size * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AdmissionsCubit>.value(value: cubit),
          BlocProvider<AuthCubit>.value(value: auth),
          BlocProvider<NotificationCubit>.value(
            value: NotificationCubit(entries: NotificationFixtures.entries),
          ),
        ],
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AdmissionLetterPage(applicationId: applicationId),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The detail of [id] with [change] applied, swapped into the portal before
  /// the page is pumped.
  void replaceDetail(
    String id,
    ApplicationDetail Function(ApplicationDetail) change,
  ) {
    cubit.load();
    final details = {...cubit.state.applicationDetails};
    details[id] = change(details[id]!);
    cubit.emit(cubit.state.copyWith(applicationDetails: details));
  }

  group('the offer letter', () {
    testWidgets('names itself in the bar and loads the portal on entry', (
      tester,
    ) async {
      await pumpLetter(tester, offeredId);

      expect(cubit.state.applications, isNotEmpty);
      expect(find.text('ADMISSION LETTER'), findsOneWidget);
      expect(find.text('APP/2026/00042'), findsNWidgets(2));
      expect(find.byTooltip('Back to the application'), findsOneWidget);
    });

    testWidgets('sets out the letter as the registry prints it', (
      tester,
    ) async {
      await pumpLetter(tester, offeredId);

      expect(find.byType(AdmissionLetterDocument), findsOneWidget);
      expect(find.byType(BrandCrestTile), findsOneWidget);
      expect(find.text('The Legion University'), findsOneWidget);
      expect(find.text('Office of the Registrar | Admissions'), findsOneWidget);

      // Reference block.
      expect(find.text('Ref:'), findsOneWidget);
      expect(find.text('Date:'), findsOneWidget);
      expect(find.text('1 October 2026'), findsOneWidget);
      expect(find.byType(VerificationQrMark), findsOneWidget);
      expect(find.text('Scan to verify'), findsOneWidget);

      // Addressee.
      expect(find.text('Musa Ibrahim'), findsOneWidget);
      expect(find.text('Plot 14, Gwarinpa Estate'), findsOneWidget);
      expect(find.text('Federal Capital Territory, Abuja'), findsOneWidget);

      // Headline, in the registry's capitals.
      expect(
        find.text('OFFER OF PROVISIONAL ADMISSION: 2026/2027 SESSION'),
        findsOneWidget,
      );

      // Body and conditions, with the programme, the date and the fee set
      // in bold inside their sentences.
      expect(
        find.textContaining('B.Sc. Computer Science', findRichText: true),
        findsWidgets,
      );
      expect(
        find.textContaining('Faculty of', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.text('This offer is subject to the following conditions:'),
        findsOneWidget,
      );
      expect(
        find.textContaining('28 February 2027', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('₦5,000.00', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Please accept my congratulations.'), findsOneWidget);

      // Signatories.
      expect(find.text('Dr Amina Yusuf'), findsOneWidget);
      expect(find.text('Registrar'), findsOneWidget);
      expect(find.text('Prof Ibrahim Garba'), findsOneWidget);
      expect(find.text('Vice-Chancellor'), findsOneWidget);
      expect(find.text('for The Legion University'), findsOneWidget);

      // Footer: where to check it and with what.
      expect(find.text('thelegion.edu.ng/verify/admission'), findsOneWidget);
      expect(find.text('7KQ2M9XW4HPA'), findsOneWidget);
    });

    testWidgets('emphasises the values inside the sentence, not around it', (
      tester,
    ) async {
      await pumpLetter(tester, offeredId);

      final body = tester
          .widgetList<EmphasisedText>(find.byType(EmphasisedText))
          .firstWhere((text) => text.emphasis.contains('28 February 2027'));
      final spans = EmphasisedText.spans(
        body.text,
        body.emphasis,
        body.emphasisStyle,
      );

      expect(spans, hasLength(3));
      expect((spans[1] as TextSpan).text, '28 February 2027');
      expect((spans[1] as TextSpan).style, body.emphasisStyle);
      expect((spans[0] as TextSpan).style, isNull);
    });

    testWidgets('offers Save PDF, Share and Copy above the letter', (
      tester,
    ) async {
      await pumpLetter(tester, offeredId);

      expect(find.text('Save PDF'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
      expect(
        find.text(
          'Keep this letter. It is the document a landlord or employer will '
          'ask to see.',
        ),
        findsOneWidget,
      );
    });

    for (final action in ['Save PDF', 'Share']) {
      testWidgets('says "$action" is not live yet', (tester) async {
        await pumpLetter(tester, offeredId);

        await tester.tap(find.text(action));
        await tester.pumpAndSettle();

        expect(find.text(comingSoon), findsOneWidget);
      });
    }

    testWidgets('copies the verification code to the clipboard', (
      tester,
    ) async {
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

      await pumpLetter(tester, offeredId);
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      final copy = calls.singleWhere(
        (call) => call.method == 'Clipboard.setData',
      );
      expect(copy.arguments, {'text': '7KQ2M9XW4HPA'});
      expect(find.text('Verification code copied'), findsOneWidget);
    });

    testWidgets('keeps the paper white in the dark theme', (tester) async {
      await pumpLetter(tester, offeredId, dark: true);

      final paper = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AdmissionLetterDocument),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoration = paper.decoration! as BoxDecoration;

      expect(decoration.color, AppColors.paper);
      expect(decoration.boxShadow, isNull);
      expect(decoration.gradient, isNull);
    });

    for (final width in [320.0, 390.0, 768.0, 1280.0]) {
      testWidgets('lays out at ${width.toInt()}px without overflowing', (
        tester,
      ) async {
        await pumpLetter(tester, offeredId, size: Size(width, 2800));

        expect(tester.takeException(), isNull);
        expect(find.byType(AdmissionLetterDocument), findsOneWidget);
      });
    }
  });

  group('the letter behind a matriculation', () {
    testWidgets('is the older letter, for the session it admitted', (
      tester,
    ) async {
      await pumpLetter(tester, matriculatedId);

      expect(find.text('APP/2024/00377'), findsNWidgets(2));
      expect(find.text('20 August 2025'), findsOneWidget);
      expect(
        find.text('OFFER OF PROVISIONAL ADMISSION: 2025/2026 SESSION'),
        findsOneWidget,
      );
      expect(
        find.textContaining('B.Sc. Accounting', findRichText: true),
        findsWidgets,
      );
      expect(find.text('P3HD7VQ2TM8K'), findsOneWidget);
    });
  });

  group('when there is nothing to show', () {
    testWidgets('answers a stale link with the record\'s own sentence', (
      tester,
    ) async {
      await pumpLetter(tester, 'app-99999');

      expect(
        find.text('This application is no longer on your record.'),
        findsOneWidget,
      );
      expect(find.byType(AdmissionLetterDocument), findsNothing);
    });

    testWidgets('says so for a record that has no letter yet', (tester) async {
      replaceDetail(
        offeredId,
        (detail) => ApplicationDetail(
          application: detail.application,
          cycleId: detail.cycleId,
          firstChoiceProgrammeId: detail.firstChoiceProgrammeId,
          secondChoiceProgrammeId: detail.secondChoiceProgrammeId,
          checklist: detail.checklist,
          referees: detail.referees,
          history: detail.history,
          offer: detail.offer,
        ),
      );
      await pumpLetter(tester, offeredId);

      expect(
        find.text('No letter has been issued for this application.'),
        findsOneWidget,
      );
      expect(find.byType(AdmissionLetterDocument), findsNothing);
      expect(find.text('Save PDF'), findsNothing);
    });
  });

  group('the QR mark', () {
    test('draws the same mark for the same code and a different one for '
        'another', () {
      const a = QrMarkPainter(code: '7KQ2M9XW4HPA');
      const b = QrMarkPainter(code: 'P3HD7VQ2TM8K');

      expect(a.shouldRepaint(const QrMarkPainter(code: '7KQ2M9XW4HPA')), false);
      expect(a.shouldRepaint(b), true);
    });

    testWidgets('paints without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(child: VerificationQrMark(code: '7KQ2M9XW4HPA')),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  group('the fixtures', () {
    test('issue a letter against every offer and matriculation', () {
      expect(AdmissionsFixtures.offeredDetail.letter, isNotNull);
      expect(AdmissionsFixtures.matriculatedDetail.letter, isNotNull);
      expect(
        AdmissionsFixtures.offeredDetail.letter!.terms,
        same(AdmissionsFixtures.offeredDetail.offer),
        reason: 'the card and the letter must quote one set of terms',
      );
    });
  });
}
