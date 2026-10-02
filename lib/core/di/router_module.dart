import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../router/app_router.dart';
import '../router/auth_guard.dart';

/// Registers the application router.
///
/// The router refreshes whenever the session changes, which is what makes
/// authentication-aware redirects work without manual navigation calls.
void registerRouterModule(GetIt sl) {
  sl.registerLazySingleton<GoRouter>(
    () => createRouter(
      authGuard: sl<AuthGuard>(),
      authStateChanges: sl<AuthCubit>().stream,
    ),
  );
}
