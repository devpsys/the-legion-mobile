import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';

/// Plain text input — a name, a phone number. The label and helper live in
/// [FieldCompartment]; this widget owns only the field itself, so every
/// auth form's fields are the same field.
class TextInputField extends StatelessWidget {
  const TextInputField({
    required this.controller,
    required this.hint,
    this.focusNode,
    this.onSubmitted,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.words,
    this.autofillHints,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      onSubmitted: onSubmitted,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      autofillHints: autofillHints,
      decoration: InputDecoration(hintText: hint),
    );
  }
}

/// Email input. The label and helper live in [FieldCompartment]; this widget
/// owns only the field itself.
class EmailTextField extends StatelessWidget {
  const EmailTextField({
    required this.controller,
    this.hint,
    this.focusNode,
    this.onSubmitted,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;

  /// The sign-in hint when omitted; registration shows an applicant's.
  final String? hint;

  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      autocorrect: false,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      decoration: InputDecoration(
        hintText: hint ?? context.l10n.loginEmailHint,
        suffixIcon: Icon(
          Icons.mail_outline,
          size: AppDimensions.iconMedium,
          color: context.colors.outline,
        ),
      ),
    );
  }
}

/// Password input with a visibility toggle.
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    required this.controller,
    this.hint,
    this.focusNode,
    this.onSubmitted,
    this.enabled = true,
    this.textInputAction = TextInputAction.done,
    this.isNewPassword = false,
    super.key,
  });

  final TextEditingController controller;

  /// The sign-in hint when omitted.
  final String? hint;

  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final TextInputAction textInputAction;

  /// Tells the platform's password manager this is a password being chosen,
  /// not one being recalled.
  final bool isNewPassword;

  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final outlineColor = context.colors.outline;
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      onSubmitted: widget.onSubmitted,
      obscureText: _isObscured,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autofillHints: [
        widget.isNewPassword
            ? AutofillHints.newPassword
            : AutofillHints.password,
      ],
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        hintText: widget.hint ?? context.l10n.loginPasswordHint,
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
          color: outlineColor,
        ),
      ),
    );
  }
}

/// Primary action button with a trailing arrow, as in the design.
class SubmitButton extends StatelessWidget {
  const SubmitButton({
    required this.label,
    required this.busyLabel,
    required this.isBusy,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String busyLabel;
  final bool isBusy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: FilledButton(
        onPressed: isBusy ? null : onPressed,
        child: isBusy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: AppDimensions.hairline * 2,
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Text(busyLabel),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  const Icon(
                    Icons.arrow_forward,
                    size: AppDimensions.iconDense,
                  ),
                ],
              ),
      ),
    );
  }
}
