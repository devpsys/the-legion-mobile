import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'helpers/load_app_fonts.dart';

/// Runs once for the whole test binary, before any suite.
///
/// `flutter test` renders every glyph as a full-em box (Ahem) unless the app's
/// fonts are registered, which makes text roughly twice as wide as it will ever
/// be on a device. Left alone, that produces two kinds of lie: layout assertions
/// that pass only because the text is inflated, and "overflow" reports for rows
/// that fit perfectly in the real app.
///
/// Registering the bundled faces here means every widget test measures the
/// layout that actually ships. Suites that do not care about layout are
/// unaffected apart from the one-off load.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await loadAppFonts();

  return testMain();
}
