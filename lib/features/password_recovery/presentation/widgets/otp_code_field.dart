import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

/// Segmented six-digit code input.
///
/// One hidden text field drives the boxes so paste, hardware keyboards and
/// accessibility all work, while the boxes render the mono digits exactly as
/// the design shows them.
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    required this.controller,
    required this.length,
    required this.onChanged,
    this.isEnabled = true,
    this.hasError = false,
    super.key,
  });

  final TextEditingController controller;
  final int length;
  final ValueChanged<String> onChanged;
  final bool isEnabled;
  final bool hasError;

  @override
  OtpCodeFieldState createState() => OtpCodeFieldState();
}

class OtpCodeFieldState extends State<OtpCodeField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _onFocusChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final border = widget.hasError
        ? theme.colorScheme.error
        : theme.colorScheme.outlineVariant;
    final focusBorder = theme.colorScheme.primary;
    final value = widget.controller.text;

    return Semantics(
      label: context.l10n.recoveryCodeLabel,
      textField: true,
      child: Stack(
        children: [
          // Invisible field that actually receives input.
          Opacity(
            opacity: 0,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.isEnabled,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              enableInteractiveSelection: false,
              showCursor: false,
              maxLength: widget.length,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              // The field itself is invisible: the boxes above render the
              // digits. Opacity (not a zero font size) keeps the caret and
              // text engine happy.
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: widget.onChanged,
            ),
          ),
          IgnorePointer(
            child: Row(
              children: [
                for (var index = 0; index < widget.length; index++) ...[
                  if (index > 0) AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: DigitBox(
                      digit: index < value.length ? value[index] : null,
                      isFocused: _focusNode.hasFocus && index == value.length,
                      borderColor: widget.hasError
                          ? border
                          : (_focusNode.hasFocus && index == value.length
                                ? focusBorder
                                : border),
                      isFilled: index < value.length,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DigitBox extends StatelessWidget {
  const DigitBox({
    required this.digit,
    required this.isFocused,
    required this.borderColor,
    required this.isFilled,
    super.key,
  });

  final String? digit;
  final bool isFocused;
  final Color borderColor;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: AppDimensions.codeFieldHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: borderColor, width: isFocused ? 2 : 1),
      ),
      alignment: Alignment.center,
      child: digit != null
          ? Text(
              digit!,
              style: AppTextStyles.codeDisplay.copyWith(
                color: theme.colorScheme.primary,
              ),
            )
          : Icon(
              Icons.circle,
              size: AppDimensions.indicator,
              color: theme.colorScheme.outlineVariant,
            ),
    );
  }
}
