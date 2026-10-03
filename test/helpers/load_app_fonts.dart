import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Registers the app's bundled fonts with the test font collection.
///
/// `flutter test` otherwise renders every glyph as a full-em box (Ahem), which
/// makes text roughly twice as wide as it will ever be on a device. A widget
/// test that loads the real faces measures the layout that actually ships, so
/// an overflow it reports is one a candidate would see — rather than an
/// artefact of the harness.
///
/// Call it from a suite that asserts on layout. Suites that only check copy or
/// widget presence do not need it, and leaving it out keeps them fast.
Future<void> loadAppFonts() async {
  final faces = {
    'Inter': [
      'assets/fonts/Inter-400.ttf',
      'assets/fonts/Inter-500.ttf',
      'assets/fonts/Inter-600.ttf',
      'assets/fonts/Inter-700.ttf',
    ],
    'JetBrainsMono': [
      'assets/fonts/JetBrainsMono-400.ttf',
      'assets/fonts/JetBrainsMono-500.ttf',
      'assets/fonts/JetBrainsMono-600.ttf',
      'assets/fonts/JetBrainsMono-700.ttf',
    ],
  };

  for (final entry in faces.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      loader.addFont(rootBundle.load(path));
    }
    // Awaited: `load` completes only once every face has been registered, and
    // an unresolved face silently renders as the fallback.
    await loader.load();
  }
}
