import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/bloc/password_recovery_cubit.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/bloc/password_recovery_state.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/pages/request_recovery_code_page.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/widgets/otp_code_field.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/widgets/password_requirements_list.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/widgets/password_strength_meter.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/widgets/recovery_audit_card.dart';
import 'package:the_legion_mobile/features/password_recovery/presentation/widgets/recovery_widgets.dart';

void main() {
  late PasswordRecoveryCubit cubit;

  setUp(() => cubit = PasswordRecoveryCubit());
  tearDown(() => cubit.close());

  Future<void> pumpPage(WidgetTester tester, Widget page) async {
    tester.view
      ..physicalSize = const Size(390, 1400) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<PasswordRecoveryCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: page,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('request step', () {
    testWidgets('shows the design copy and blocks submit until an identifier', (
      tester,
    ) async {
      await pumpPage(tester, const RequestRecoveryCodePage());

      expect(find.text('Reset your password'), findsOneWidget);
      expect(find.text('Send recovery code'), findsOneWidget);
      expect(find.text('Institutional Security Protocol'), findsOneWidget);
      expect(find.text('Remembered your password? Sign in'), findsOneWidget);

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Send recovery code'),
      );
      expect(button.onPressed, isNull, reason: 'empty identifier disables it');
    });

    testWidgets('enables submit once an identifier is entered', (tester) async {
      await pumpPage(tester, const RequestRecoveryCodePage());

      await tester.enterText(find.byType(TextField), 'ada@legion.edu.ng');
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Send recovery code'),
      );
      expect(button.onPressed, isNotNull);
    });
  });

  group('OtpCodeField', () {
    testWidgets('renders one box per digit and reports the value', (
      tester,
    ) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final values = <String>[];

      await pumpPage(
        tester,
        Scaffold(
          body: OtpCodeField(
            controller: controller,
            length: RecoveryRules.codeLength,
            onChanged: values.add,
          ),
        ),
      );

      expect(find.byType(OtpCodeField), findsOneWidget);
      await tester.enterText(find.byType(TextField), '123');
      await tester.pumpAndSettle();

      expect(values.last, '123');
      expect(controller.text, '123');
    });
  });

  group('password step widgets', () {
    testWidgets('the requirements list reflects the policy', (tester) async {
      final met = cubit.evaluatePassword('Legion2024!');

      await pumpPage(
        tester,
        Scaffold(body: PasswordRequirementsList(requirements: met)),
      );

      expect(find.text('At least 8 characters'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
      expect(find.text('Policy Compliant (4/4)'), findsOneWidget);
    });

    testWidgets('the strength meter is full when compliant', (tester) async {
      final met = cubit.evaluatePassword('Legion2024!');

      await pumpPage(
        tester,
        Scaffold(
          body: PasswordStrengthMeter(
            strength: cubit.policy.strengthOf('Legion2024!'),
            metCount: met.where((r) => r.isMet).length,
            totalCount: met.length,
          ),
        ),
      );

      final indicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(indicator.value, 1.0);
      expect(find.text('Policy Compliant'), findsOneWidget);
    });
  });

  group('audit summary', () {
    testWidgets('shows every audited field', (tester) async {
      await pumpPage(
        tester,
        const Scaffold(
          body: RecoveryAuditCard(
            accountName: 'Amaka Bello',
            registrationNumber: '23/CSC/0412',
            email: 'amaka.bello@legion.edu.ng',
            timestamp: '15 January 2027, 11:08',
            auditHash: 'SEC-9F82-AUTH-CLR',
            sessionsSummary:
                'Revoked on all other devices (1 device authorized)',
          ),
        ),
      );

      expect(find.text('Official Audit Summary'), findsOneWidget);
      expect(find.text('STATUS: COMMITTED'), findsOneWidget);
      expect(find.text('Amaka Bello (23/CSC/0412)'), findsOneWidget);
      expect(find.text('SEC-9F82-AUTH-CLR'), findsOneWidget);
    });
  });

  group('countdown formatting', () {
    test('renders seconds below a minute and mm:ss above', () {
      expect(RecoveryCountdownBadge.format(const Duration(seconds: 42)), '42s');
      expect(
        RecoveryCountdownBadge.format(const Duration(minutes: 9, seconds: 42)),
        '9:42',
      );
    });
  });
}
