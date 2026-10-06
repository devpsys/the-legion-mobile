import 'package:flutter/material.dart';

import '../theme/app_tone.dart';

/// Snackbar helpers so presentation code never repeats `ScaffoldMessenger`
/// plumbing, and so every message is styled from the theme.
extension MessageFeedbackX on BuildContext {
  void showMessage(String message, {bool isError = false}) {
    final theme = Theme.of(this);
    final scheme = theme.colorScheme;
    final brightness = theme.brightness;
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;

    // Failures use warning amber (same pair as ToneCallout), not danger red —
    // snackbars are transient feedback, not blocked-state banners.
    // Success / info stays on inverse surface for contrast against the canvas.
    final background = isError
        ? AppTone.warning.surface(brightness)
        : scheme.inverseSurface;
    final foreground = isError
        ? AppTone.warning.foreground(brightness)
        : scheme.onInverseSurface;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
          ),
          backgroundColor: background,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  void showErrorMessage(String message) => showMessage(message, isError: true);
}
