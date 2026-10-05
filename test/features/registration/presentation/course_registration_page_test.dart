import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:the_legion_mobile/core/l10n/gen/app_localizations.dart';
import 'package:the_legion_mobile/core/notifications/notification_cubit.dart';
import 'package:the_legion_mobile/core/notifications/notification_fixtures.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/core/theme/app_theme.dart';
import 'package:the_legion_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:the_legion_mobile/features/registration/presentation/bloc/registration_cubit.dart';
import 'package:the_legion_mobile/features/registration/presentation/pages/course_registration_page.dart';
import 'package:the_legion_mobile/features/registration/presentation/widgets/registration_tab_bar.dart';
import 'package:the_legion_mobile/features/registration/presentation/widgets/registration_task_bar.dart';

import '../../../helpers/signed_in_auth_cubit.dart';

void main() {
  late RegistrationCubit cubit;
  late AuthCubit auth;

  setUp(() async {
    cubit = RegistrationCubit();
    auth = await signedInAuthCubit();
  });

  tearDown(() async {
    await cubit.close();
    await auth.close();
  });

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(390, 3200) * 2
      ..devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      routes: [
        GoRoute(
          path: Routes.registration,
          name: Routes.registrationName,
          builder: (_, _) => const CourseRegistrationPage(),
        ),
        GoRoute(
          path: Routes.registrationStudyPlan,
          name: Routes.registrationStudyPlanName,
          builder: (_, _) => const Text('study-plan'),
        ),
        GoRoute(
          path: Routes.registrationForm,
          name: Routes.registrationFormName,
          builder: (_, _) => const Text('form'),
        ),
        GoRoute(
          path: Routes.profile,
          name: Routes.profileName,
          builder: (_, _) => const Text('profile'),
        ),
      ],
      initialLocation: Routes.registration,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<RegistrationCubit>.value(value: cubit),
          BlocProvider<AuthCubit>.value(value: auth),
          BlocProvider<NotificationCubit>.value(
            value: NotificationCubit(entries: NotificationFixtures.entries),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('loads the ledger and shows the registration chrome', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.byType(RegistrationTaskBar), findsOneWidget);
    expect(find.byType(RegistrationTabBar), findsOneWidget);
    expect(find.text('Course registration'), findsWidgets);
    expect(find.text('Selected & Timetable'), findsOneWidget);
    expect(find.text('Catalogue & Add'), findsOneWidget);
    expect(find.text('Amaka Bello'), findsOneWidget);
    expect(find.text('CSC301 [A]'), findsOneWidget);
    expect(find.text('YOUR COURSES'), findsOneWidget);
    expect(find.text('YOUR WEEK'), findsOneWidget);
    expect(find.text('MON'), findsWidgets);
    expect(find.text('Submit course form'), findsOneWidget);

    await tester.tap(find.text('Catalogue & Add'));
    await tester.pumpAndSettle();
    expect(find.text('ADD COURSES'), findsOneWidget);
    expect(find.text('YOUR WEEK'), findsNothing);
  });

  testWidgets('requesting a clashing catalogue course opens the clash sheet', (
    tester,
  ) async {
    await pumpPage(tester);

    await tester.tap(find.text('Catalogue & Add'));
    await tester.pumpAndSettle();

    cubit.requestAdd('cat-csc405a');
    await tester.pumpAndSettle();

    expect(find.text('Add anyway'), findsOneWidget);
    expect(find.text('Keep it'), findsNothing);
  });
}
