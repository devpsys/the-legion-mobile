import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Asks the officer for a reason before an act that needs one.
///
/// Resolves to the reason once they confirm, or `null` when they dismiss the
/// dialog. Confirming with nothing typed keeps the dialog open.
class ExamOfficeReasonDialog extends StatefulWidget {
  const ExamOfficeReasonDialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
    super.key,
  });

  final String title;
  final String body;
  final String confirmLabel;

  /// Shows the dialog and resolves to the reason, or `null` when dismissed.
  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => ExamOfficeReasonDialog(
        title: title,
        body: body,
        confirmLabel: confirmLabel,
      ),
    );
  }

  @override
  ExamOfficeReasonDialogState createState() => ExamOfficeReasonDialogState();
}

/// State of [ExamOfficeReasonDialog].
class ExamOfficeReasonDialogState extends State<ExamOfficeReasonDialog> {
  final TextEditingController _reason = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _confirm() {
    final text = _reason.text.trim();
    if (text.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.body),
          AppSpacing.verticalGap(AppSpacing.md),
          TextField(
            controller: _reason,
            autofocus: true,
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              labelText: l10n.examOfficeReasonLabel,
              errorText: _showError ? l10n.examOfficeReasonRequired : null,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.examOfficeConfirmKeep),
        ),
        FilledButton(onPressed: _confirm, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
