import 'package:flutter/material.dart';

/// Snackbar helpers so presentation code never repeats `ScaffoldMessenger`
/// plumbing, and so every message is styled from the theme.
extension MessageFeedbackX on BuildContext {
  void showMessage(String message, {bool isError = false}) {
    final theme = Theme.of(this);
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? theme.colorScheme.error : null,
          duration: const Duration(seconds: 4),
        ),
      );
  }

  void showErrorMessage(String message) => showMessage(message, isError: true);
}
