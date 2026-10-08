import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';

/// Asks the officer to confirm an act that cannot be undone.
///
/// Resolves to `true` only when they confirm; dismissing the dialog or tapping
/// the keep button resolves to `false`.
Future<bool> confirmExamOfficeAction(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
}) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.examOfficeConfirmKeep),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
