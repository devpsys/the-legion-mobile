import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/l10n/gen/app_localizations.dart';
import 'core/notifications/notification_cubit.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';

/// Root widget.
///
/// Composition only: it wires the theme, localization delegates, the router
/// and the session cubit, and nothing else.
class TheLegionApp extends StatelessWidget {
  const TheLegionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = sl<AppConfig>();

    // Provided above the router so redirect logic and every page share one
    // session instance. The notification centre is a sibling for the same
    // reason: one bell, one count, whichever screen it is on.
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: sl<AuthCubit>()),
        BlocProvider<NotificationCubit>.value(value: sl<NotificationCubit>()),
      ],
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: config.environment.enableDeveloperTools,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: sl<GoRouter>(),
      ),
    );
  }
}
