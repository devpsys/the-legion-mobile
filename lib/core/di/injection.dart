import 'package:get_it/get_it.dart';

import '../../features/admissions/di/admissions_module.dart';
import '../../features/auth/di/auth_module.dart';
import '../../features/fees/di/fees_module.dart';
import '../../features/password_recovery/di/password_recovery_module.dart';
import '../config/app_config.dart';
import 'network_module.dart';
import 'notifications_module.dart';
import 'router_module.dart';
import 'storage_module.dart';

/// Application wide service locator.
///
/// Imported everywhere a dependency is needed and referred to as `sl`; nothing
/// outside `core/di` and the feature `di` folders constructs infrastructure
/// objects.
final GetIt sl = GetIt.instance;

/// Registers every dependency and prepares local storage.
///
/// Registration order matters: storage first (Hive/secure storage), then the
/// network client, then features, then the router. Lazy singletons may be
/// resolved in any order, so feature modules do not need to know about each
/// other.
Future<void> configureDependencies({AppConfig? config}) async {
  final appConfig = config ?? AppConfig.fromEnvironment();

  sl.registerSingleton<AppConfig>(appConfig);
  await registerStorageModule(sl);
  registerNetworkModule(sl);
  registerNotificationsModule(sl);
  registerAuthModule(sl);
  registerAdmissionsModule(sl);
  registerFeesModule(sl);
  registerPasswordRecoveryModule(sl);
  registerRouterModule(sl);
  configureLogging(sl);
}

/// Tears the container down. Used by integration tests.
Future<void> resetDependencies() => sl.reset();
