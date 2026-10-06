import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../registration_chrome.dart';

/// Labelled multi-line note field used for HoD reasons and advice.
///
/// Keeps its own controller seeded from [initialValue]; edits are reported
/// through [onChanged] so the cubit holds the draft.
class StaffReasonField extends StatefulWidget {
  const StaffReasonField({
    required this.label,
    required this.hint,
    required this.initialValue,
    required this.onChanged,
    this.minLines = 2,
    this.maxLines = 5,
    super.key,
  });

  final String label;
  final String hint;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final int minLines;
  final int maxLines;

  @override
  StaffReasonFieldState createState() => StaffReasonFieldState();
}

/// State of [StaffReasonField].
class StaffReasonFieldState extends State<StaffReasonField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RegistrationFieldLabel(widget.label),
        AppSpacing.verticalGap(AppSpacing.xs),
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(hintText: widget.hint),
        ),
      ],
    );
  }
}
