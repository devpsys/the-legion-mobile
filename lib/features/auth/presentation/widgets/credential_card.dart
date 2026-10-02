import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_localization.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/validation.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'auth_inputs.dart';
import 'field_compartment.dart';

/// The credential deck: fields, options row and the primary action.
///
/// Reads [AuthState] only — it never touches a repository. Validation errors
/// arrive from the domain layer as [AuthState.failure] and are routed to the
/// compartment they belong to.
class CredentialCard extends StatelessWidget {
  const CredentialCard({
    required this.emailController,
    required this.passwordController,
    required this.passwordFocus,
    required this.onSubmit,
    this.keepSignedIn = false,
    this.onKeepSignedInChanged,
    this.onForgotPassword,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocus;
  final VoidCallback onSubmit;

  /// Presentation-only flag; persistence policy arrives with the API contract.
  final bool keepSignedIn;
  final ValueChanged<bool>? onKeepSignedInChanged;
  final VoidCallback? onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CardHeader(
            title: context.l10n.loginCardTitle,
            subtitle: context.l10n.loginCardSubtitle,
          ),
          Padding(
            padding: AppSpacing.card,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final l10n = context.l10n;
                final failure = state.failure;
                final isBusy = state.status == AuthStatus.authenticating;

                final emailError = _errorFor(failure, l10n, email: true);
                final passwordError = _errorFor(failure, l10n, email: false);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FieldCompartment(
                      label: l10n.loginEmailLabel,
                      helper: emailError ?? l10n.loginEmailHelper,
                      isError: emailError != null,
                      child: EmailTextField(
                        controller: emailController,
                        enabled: !isBusy,
                        onSubmitted: (_) => passwordFocus.requestFocus(),
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.md),
                    FieldCompartment(
                      label: l10n.loginPasswordLabel,
                      helper: passwordError,
                      isError: passwordError != null,
                      child: PasswordTextField(
                        controller: passwordController,
                        enabled: !isBusy,
                        onSubmitted: (_) => onSubmit(),
                      ),
                    ),
                    if (failure != null && emailError == null) ...[
                      AppSpacing.verticalGap(AppSpacing.md),
                      _FailureBanner(message: failure.localize(l10n)),
                    ],
                    AppSpacing.verticalGap(AppSpacing.lg),
                    _OptionsRow(
                      keepSignedIn: keepSignedIn,
                      onKeepSignedInChanged: onKeepSignedInChanged,
                      onForgotPassword: onForgotPassword,
                    ),
                    SubmitButton(
                      label: l10n.loginSubmit,
                      busyLabel: l10n.loginSubmitting,
                      isBusy: isBusy,
                      onPressed: onSubmit,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Renders a validation failure only under the field it belongs to.
  String? _errorFor(
    Failure? failure,
    AppLocalizations l10n, {
    required bool email,
  }) {
    if (failure is! ValidationFailure) return null;
    if (failure.field !=
        (email ? ValidationField.email : ValidationField.password)) {
      return null;
    }
    return failure.localize(l10n);
  }
}

/// Tinted sub-header row: title, subtitle and a leading icon chip.
class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.xs),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.md),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: AppDimensions.iconMedium,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// "Keep me signed in" checkbox plus the password reset link.
class _OptionsRow extends StatelessWidget {
  const _OptionsRow({
    required this.keepSignedIn,
    this.onKeepSignedInChanged,
    this.onForgotPassword,
  });

  final bool keepSignedIn;
  final ValueChanged<bool>? onKeepSignedInChanged;
  final VoidCallback? onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onKeepSignedInChanged == null
                ? null
                : () => onKeepSignedInChanged!(!keepSignedIn),
            borderRadius: AppRadii.elementRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox.square(
                    dimension: AppDimensions.checkboxSize,
                    child: Checkbox(
                      value: keepSignedIn,
                      onChanged: onKeepSignedInChanged == null
                          ? null
                          : (value) => onKeepSignedInChanged!(value ?? false),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Flexible(
                    child: Text(
                      context.l10n.loginRememberMe,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (onForgotPassword != null)
          TextButton(
            onPressed: onForgotPassword,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              minimumSize: const Size(0, AppDimensions.minTapTarget),
            ),
            child: Text(context.l10n.loginForgotPassword),
          ),
      ],
    );
  }
}

/// Inline banner for failures that are not tied to a single field.
class _FailureBanner extends StatelessWidget {
  const _FailureBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      padding: AppSpacing.card,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: AppRadii.elementRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 18, color: theme.colorScheme.error),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
