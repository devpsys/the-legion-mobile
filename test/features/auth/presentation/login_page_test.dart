import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/fake_auth_remote_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/datasources/fake/in_memory_auth_local_data_source.dart';
import 'package:the_legion_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/login.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/logout.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/register.dart';
import 'package:the_legion_mobile/features/auth/domain/usecases/restore_session.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/auth_footer.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/auth_header_banner.dart';
import 'package:the_legion_mobile/features/auth/presentation/widgets/credential_card.dart';

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

  Future<void> pumpLogin(
    WidgetTester tester, {
    Size size = const Size(390, 700),
  }) async {
    tester.view
      ..physicalSize = size * 3
      ..devicePixelRatio = 3;
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

  group('LoginPage layout', () {
    testWidgets('docks the header banner and footer around a scrollable body', (
      tester,
    ) async {
      await pumpLogin(tester);

      expect(find.byType(AuthHeaderBanner), findsOneWidget);
      expect(find.byType(CredentialCard), findsOneWidget);
      expect(find.byType(AuthFooter), findsOneWidget);

      // Banner is flush with the top of the body, footer with the bottom.
      expect(tester.getTopLeft(find.byType(AuthHeaderBanner)).dy, 0);
      expect(
        tester.getBottomLeft(find.byType(AuthFooter)).dy,
        tester.getSize(find.byType(Scaffold)).height,
      );
    });

    testWidgets('keeps the footer docked while the content scrolls', (
      tester,
    ) async {
      await pumpLogin(tester);

      final footer = find.byType(AuthFooter);
      final before = tester.getTopLeft(footer);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -320),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(footer),
        before,
        reason: 'the footer is docked below the scrolling content',
      );
    });

    testWidgets('keeps the header banner fixed while the content scrolls', (
      tester,
    ) async {
      await pumpLogin(tester);

      final banner = find.byType(AuthHeaderBanner);
      final before = tester.getTopLeft(banner);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -320),
      );
      await tester.pumpAndSettle();

      expect(banner, findsOneWidget);
      expect(
        tester.getTopLeft(banner),
        before,
        reason: 'the institutional banner must not scroll away',
      );
    });

    testWidgets('shows the credential compartments from the design', (
      tester,
    ) async {
      await pumpLogin(tester);

      expect(find.text('Sign in'), findsWidgets);
      expect(find.text('Institutional email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Keep me signed in'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
      expect(find.text('Statutory Audit Protocol'), findsOneWidget);
    });
  });
}
