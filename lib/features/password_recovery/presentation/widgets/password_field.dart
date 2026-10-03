import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Labelled password input with a visibility toggle.

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.enabled,
    required this.onChanged,
    required this.textInputAction,
    required this.onSubmitted,
    this.errorText,
    super.key,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;
  final String? errorText;

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: context.textStyles.labelMedium?.copyWith(
            color: context.colors.primary,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          obscureText: _isObscured,
          textInputAction: widget.textInputAction,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            suffixIcon: IconButton(
              onPressed: () => setState(() => _isObscured = !_isObscured),
              tooltip: _isObscured
                  ? context.l10n.loginShowPassword
                  : context.l10n.loginHidePassword,
              icon: Icon(
                _isObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: AppDimensions.iconMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
