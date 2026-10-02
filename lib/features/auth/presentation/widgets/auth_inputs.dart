import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';

/// Email input with built-in keyboard and autofill hints.
class EmailTextField extends StatelessWidget {
  const EmailTextField({
    required this.controller,
    this.errorText,
    this.onSubmitted,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      onSubmitted: onSubmitted,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      autocorrect: false,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      decoration: InputDecoration(
        labelText: context.l10n.loginEmailLabel,
        hintText: context.l10n.loginEmailHint,
        prefixIcon: const Icon(Icons.mail_outline),
        errorText: errorText,
        errorMaxLines: 2,
      ),
    );
  }
}

/// Password input with a visibility toggle.
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    required this.controller,
    this.errorText,
    this.onSubmitted,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      enabled: widget.enabled,
      onSubmitted: widget.onSubmitted,
      obscureText: _isObscured,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: context.l10n.loginPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outline),
        errorText: widget.errorText,
        errorMaxLines: 2,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _isObscured = !_isObscured),
          tooltip: _isObscured
              ? context.l10n.loginShowPassword
              : context.l10n.loginHidePassword,
          icon: Icon(
            _isObscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
    );
  }
}

/// Submit button that shows progress while a request is running.
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
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: FilledButton(
        onPressed: isBusy ? null : onPressed,
        child: isBusy
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Text(busyLabel),
                ],
              )
            : Text(label),
      ),
    );
  }
}
