import 'package:flutter/material.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/di/injection.dart';
import 'core/utils/app_logger.dart';

/// Application entry point.
///
/// Local storage and the service locator are initialized before the first
/// frame so the router can redirect immediately on cold start.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  AppLogger.instance.i(
    'The Legion started (${sl<AppConfig>().environment.name})',
  );

  runApp(const TheLegionApp());
}
