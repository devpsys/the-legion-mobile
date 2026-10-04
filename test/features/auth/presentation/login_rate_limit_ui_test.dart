import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/entities/sign_in_attempts.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/register.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/auth_inputs.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/credential_card.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/rate_limit/locked_credential_summary.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/rate_limit/lockout_notice_card.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/rate_limit/rate_limit_banner.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/secondary_action_deck.dart';

/// Clock anchored to a fixed instant that advances with real time, plus an
/// offset the test can jump forward — `tester.pump` moves fake time, not the
/// wall clock the cooldown is measured against.
class _Clock {
  _Clock() : _base = DateTime.utc(2026, 1, 1), _realBase = DateTime.now();

  final DateTime _base;
  final DateTime _realBase;
  Duration _offset = Duration.zero;

  DateTime call() => _base.add(DateTime.now().difference(_realBase) + _offset);

  void advance(Duration duration) => _offset += duration;
}

void main() {
  late AuthCubit cubit;
  late _Clock clock;

  setUp(() {
    clock = _Clock();
    final repository = AuthRepositoryImpl(
      remote: FakeAuthRemoteDataSource(
        latency: Duration.zero,
        acceptedPassword: 'correct-horse-battery',
      ),
      local: InMemoryAuthLocalDataSource(),
    );
    cubit = AuthCubit(
      login: LoginUseCase(repository),
      logout: LogoutUseCase(repository),
      register: RegisterUseCase(repository),
      restoreSession: RestoreSessionUseCase(repository),
      now: clock.call,
      cooldown: const Duration(seconds: 1),
    );
  });

  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
  });

  /// Lets the cooldown ticker fire and cancel itself, so no timer outlives the
  /// widget tree. Call after the assertions of a locked test.
  Future<void> settleCooldown(WidgetTester tester) async {
    clock.advance(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  }

  Future<void> pumpLogin(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 1400) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      BlocProvider<AuthCubit>.value(
        value: cubit,
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> submit(WidgetTester tester, String password) async {
    await tester.enterText(find.byType(TextField).first, 'ada@the-legion.dev');
    await tester.enterText(find.byType(TextField).last, password);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }

  group('rate-limited login state', () {
    testWidgets('shows the normal form before the limit is reached', (
      tester,
    ) async {
      await pumpLogin(tester);

      expect(find.byType(EmailTextField), findsOneWidget);
      expect(find.byType(RateLimitAlertBanner), findsNothing);
      expect(find.byType(SecondaryActionDeck), findsOneWidget);
    });

    testWidgets('locks after five wrong attempts', (tester) async {
      await pumpLogin(tester);

      for (var i = 0; i < 4; i++) {
        await submit(tester, 'wrong-password');
      }
      expect(find.byType(RateLimitAlertBanner), findsNothing);

      await submit(tester, 'wrong-password');

      // Alert banner + locked credentials + lockout callout.
      expect(find.byType(RateLimitAlertBanner), findsOneWidget);
      expect(find.byType(LockedCredentialSummary), findsOneWidget);
      expect(find.byType(LockoutNoticeCard), findsOneWidget);
      expect(find.text('Too many sign-in attempts'), findsOneWidget);
      expect(find.text('Institutional lockout'), findsOneWidget);
      expect(find.text('SEC-403'), findsOneWidget);

      await settleCooldown(tester);
    });

    testWidgets('hides the credential fields and secondary deck when locked', (
      tester,
    ) async {
      await pumpLogin(tester);

      for (var i = 0; i < 5; i++) {
        await submit(tester, 'wrong-password');
      }

      expect(find.byType(EmailTextField), findsNothing);
      expect(find.byType(PasswordTextField), findsNothing);
      expect(find.byType(SecondaryActionDeck), findsNothing);
      // The institutional banner and the statutory notice stay.
      expect(find.byType(CredentialCard), findsOneWidget);

      await settleCooldown(tester);
    });

    testWidgets('masks the passphrase in the locked summary', (tester) async {
      await pumpLogin(tester);

      for (var i = 0; i < 5; i++) {
        await submit(tester, 'wrong-password');
      }

      expect(
        find.text(LockedCredentialSummary.maskedPassphrase),
        findsOneWidget,
      );
      expect(find.text('ada@the-legion.dev'), findsWidgets);
      expect(find.text('Field locked'), findsNWidgets(2));

      await settleCooldown(tester);
    });

    testWidgets('disables the retry action until the cooldown elapses', (
      tester,
    ) async {
      await pumpLogin(tester);

      for (var i = 0; i < 5; i++) {
        await submit(tester, 'wrong-password');
      }

      final retry = tester.widget<FilledButton>(
        // The label carries the live countdown, so match on the prefix.
        find.ancestor(
          of: find.textContaining('Try again in'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(retry.onPressed, isNull);

      // Let the cooldown run out, then the form returns.
      await settleCooldown(tester);

      expect(find.byType(EmailTextField), findsOneWidget);
      expect(find.byType(RateLimitAlertBanner), findsNothing);
    });

    testWidgets('a correct password after the lockout signs in', (
      tester,
    ) async {
      await pumpLogin(tester);

      for (var i = 0; i < 5; i++) {
        await submit(tester, 'wrong-password');
      }
      await settleCooldown(tester);

      await submit(tester, 'correct-horse-battery');

      expect(cubit.state.isAuthenticated, isTrue);
    }, timeout: const Timeout(Duration(seconds: 30)));
  });

  group('RateLimitAlertBanner formatting', () {
    test('renders seconds below a minute', () {
      expect(
        RateLimitAlertBanner.formatRemaining(const Duration(seconds: 41)),
        '41s',
      );
      expect(
        RateLimitAlertBanner.formatRemaining(const Duration(seconds: 9)),
        '9s',
      );
    });

    test('renders minutes with padded seconds', () {
      expect(
        RateLimitAlertBanner.formatRemaining(
          const Duration(minutes: 2, seconds: 5),
        ),
        '2m 05s',
      );
    });
  });

  group('SignInAttempts default', () {
    test('the production window is five minutes', () {
      expect(SignInAttempts.cooldown, const Duration(minutes: 5));
    });
  });
}
