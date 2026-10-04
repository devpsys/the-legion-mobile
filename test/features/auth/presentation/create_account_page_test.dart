import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/error/failures.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/core/widgets/brand_block.dart';
import 'package:the_legion_mobile/core/widgets/brand_crest_tile.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/register.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:the_legion_mobile/features/auth/presentation/pages/create_account_page.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/auth_footer.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/auth_inputs.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/credential_card.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/field_compartment.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/registration_card.dart';

/// Opening an applicant account, over the in-memory backend.
void main() {
  late AuthCubit cubit;

  setUp(() {
    final repository = AuthRepositoryImpl(
      remote: FakeAuthRemoteDataSource(latency: Duration.zero),
      local: InMemoryAuthLocalDataSource(),
    );
    cubit = AuthCubit(
      login: LoginUseCase(repository),
      logout: LogoutUseCase(repository),
      register: RegisterUseCase(repository),
      restoreSession: RestoreSessionUseCase(repository),
    );
  });

  tearDown(() => cubit.close());

  Future<void> pumpPage(
    WidgetTester tester, {
    Size size = const Size(390, 1500),
    bool dark = false,
  }) async {
    tester.view
      ..physicalSize = size * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: dark ? AppTheme.dark : AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CreateAccountPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The fields, in the order the design lists them.
  Finder fieldAt(int index) => find.byType(TextField).at(index);

  Future<void> fillValidForm(
    WidgetTester tester, {
    String email = 'seun@example.com',
    String confirmPassword = 'legion123',
  }) async {
    await tester.enterText(fieldAt(0), 'Oluwaseun');
    await tester.enterText(fieldAt(1), 'Adeyemi');
    await tester.enterText(fieldAt(3), email);
    await tester.enterText(fieldAt(5), 'legion123');
    await tester.enterText(fieldAt(6), confirmPassword);
  }

  Future<void> submit(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Create account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
  }

  group('layout', () {
    testWidgets('wears the public brand block, the card and the footer', (
      tester,
    ) async {
      await pumpPage(tester);

      expect(find.byTooltip('Back to sign in'), findsOneWidget);
      expect(find.byType(BrandBlock), findsOneWidget);
      expect(find.byType(BrandCrestTile), findsOneWidget);
      expect(find.text('The Legion University'), findsOneWidget);
      expect(find.text('The Legion University Admissions'), findsOneWidget);
      expect(find.byType(RegistrationCard), findsOneWidget);
      expect(find.byType(AuthFooter), findsOneWidget);
      // No navy sign-in banner: this door is for people from outside.
      expect(find.byType(AppBar), findsNothing);
    });

    testWidgets('is built from the sign-in deck\'s own parts', (tester) async {
      await pumpPage(tester);

      expect(find.byType(CardHeader), findsOneWidget);
      expect(find.text('Create an applicant account'), findsOneWidget);
      expect(
        find.text(
          'Apply for admission, claim your JAMB result and track your offer. '
          'Students and staff get their accounts from the university.',
        ),
        findsOneWidget,
      );
      expect(find.byType(FieldCompartment), findsNWidgets(7));
      expect(find.byType(EmailTextField), findsOneWidget);
      expect(find.byType(PasswordTextField), findsNWidgets(2));
      expect(find.byType(SubmitButton), findsOneWidget);
    });

    testWidgets('lists the fields in the design\'s order with its labels', (
      tester,
    ) async {
      await pumpPage(tester);

      final labels = tester
          .widgetList<FieldLabel>(find.byType(FieldLabel))
          .map((label) => (label.text, label.isRequired))
          .toList();
      expect(labels, [
        ('First name', true),
        ('Surname', true),
        ('Other names (optional)', false),
        ('Email address', true),
        ('Phone number (optional)', false),
        ('Password', true),
        ('Confirm password', true),
      ]);

      expect(find.text("We'll send a link to confirm it."), findsOneWidget);
      expect(
        find.text('8 or more characters, with letters and numbers.'),
        findsOneWidget,
      );
      expect(find.text('Create account'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
    });

    testWidgets('flags required fields with a red marker after the label', (
      tester,
    ) async {
      await pumpPage(tester);

      final theme = Theme.of(tester.element(find.byType(RegistrationCard)));
      final richLabels = find.descendant(
        of: find.byType(FieldLabel),
        matching: find.byType(Text),
      );
      final markers = tester
          .widgetList<Text>(richLabels)
          .map((text) => text.textSpan)
          .whereType<TextSpan>()
          .map((span) => span.children!.last as TextSpan)
          .toList();

      expect(markers, hasLength(5), reason: 'five of the seven are required');
      for (final marker in markers) {
        expect(marker.text, '*');
        expect(marker.style?.color, theme.colorScheme.error);
      }
      // The field's name itself stays in the label colour.
      final first = tester.widget<Text>(richLabels.first).textSpan! as TextSpan;
      expect(first.text, 'First name');
      expect(first.style?.color, theme.colorScheme.primary);
    });

    testWidgets('keeps the footer docked while the form scrolls', (
      tester,
    ) async {
      await pumpPage(tester, size: const Size(390, 700));

      final footer = find.byType(AuthFooter);
      final before = tester.getTopLeft(footer);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      expect(tester.getTopLeft(footer), before);
    });

    for (final width in [320.0, 390.0, 768.0, 1280.0]) {
      testWidgets('lays out at ${width.toInt()}px without overflowing', (
        tester,
      ) async {
        await pumpPage(tester, size: Size(width, 1500));

        expect(tester.takeException(), isNull);
        expect(find.byType(RegistrationCard), findsOneWidget);
      });
    }

    testWidgets('renders in the dark theme', (tester) async {
      await pumpPage(tester, dark: true);

      expect(tester.takeException(), isNull);
    });
  });

  group('validation', () {
    testWidgets('reports a blank form under its first field', (tester) async {
      await pumpPage(tester);
      await submit(tester);

      expect(cubit.state.status, AuthStatus.unauthenticated);
      expect(find.text('This field is required.'), findsOneWidget);
      // Under the first name, and nowhere else.
      final compartment = find.ancestor(
        of: find.text('This field is required.'),
        matching: find.byType(FieldCompartment),
      );
      expect(tester.widget<FieldCompartment>(compartment).label, 'First name');
    });

    testWidgets('reports a bad address under the email, replacing the helper', (
      tester,
    ) async {
      await pumpPage(tester);
      await fillValidForm(tester, email: 'seun@');
      await submit(tester);

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(find.text("We'll send a link to confirm it."), findsNothing);
    });

    testWidgets('reports a mismatch under the confirmation', (tester) async {
      await pumpPage(tester);
      await fillValidForm(tester, confirmPassword: 'legion124');
      await submit(tester);

      expect(find.text('The passwords do not match.'), findsOneWidget);
      final compartment = find.ancestor(
        of: find.text('The passwords do not match.'),
        matching: find.byType(FieldCompartment),
      );
      expect(
        tester.widget<FieldCompartment>(compartment).label,
        'Confirm password',
      );
    });

    testWidgets('reports an address that already has an account', (
      tester,
    ) async {
      await pumpPage(tester);
      await fillValidForm(tester, email: 'ada@the-legion.dev');
      await submit(tester);

      expect(
        find.text(
          'An account already exists for this email address. Sign in instead.',
        ),
        findsOneWidget,
      );
      expect(find.byType(FailureBanner), findsNothing);
    });

    testWidgets('shows a failure that names no field once, under the form', (
      tester,
    ) async {
      await pumpPage(tester);
      cubit.emit(
        const AuthState.unauthenticated(
          failure: NetworkFailure(message: 'offline'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FailureBanner), findsOneWidget);
      expect(
        find.text('No internet connection. Check your network and try again.'),
        findsOneWidget,
      );
    });
  });

  group('submission', () {
    testWidgets('opens the account and signs the applicant in', (tester) async {
      await pumpPage(tester);
      await fillValidForm(tester);
      await tester.enterText(fieldAt(2), 'Michael');
      await tester.enterText(fieldAt(4), '+234 803 123 4567');
      await submit(tester);

      expect(cubit.state.isAuthenticated, isTrue);
      expect(cubit.state.user?.displayName, 'Oluwaseun Adeyemi');
      expect(cubit.state.user?.email, 'seun@example.com');
    });

    testWidgets('submits from the keyboard on the last field', (tester) async {
      await pumpPage(tester);
      await fillValidForm(tester);

      await tester.showKeyboard(fieldAt(6));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(cubit.state.isAuthenticated, isTrue);
    });

    testWidgets('clears a sign-in failure left over from the door before', (
      tester,
    ) async {
      cubit.emit(
        const AuthState.unauthenticated(
          failure: AuthFailure(message: 'bad credentials'),
        ),
      );

      await pumpPage(tester);

      expect(cubit.state.failure, isNull);
      expect(find.byType(FailureBanner), findsNothing);
    });
  });
}
