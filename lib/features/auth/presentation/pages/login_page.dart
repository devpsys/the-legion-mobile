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
import '../../../../core/widgets/app_mark.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_inputs.dart';

/// Sign-in screen.
///
/// Purely compositional: it reads [AuthState] and forwards user input to
/// [AuthCubit]. No validation logic, no repository call.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    _passwordFocus.unfocus();
    context.read<AuthCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide =
                constraints.maxWidth >= AppDimensions.expandedBreakpoint;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                // On tablets the form sits vertically centered.
                vertical: isWide ? AppSpacing.xxl : AppSpacing.xl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppDimensions.maxFormWidth,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: AppMark()),
                      AppSpacing.verticalGap(AppSpacing.xl),
                      Text(
                        context.l10n.loginTitle,
                        style: context.textStyles.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        context.l10n.loginSubtitle,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      AppSpacing.verticalGap(AppSpacing.xl),
                      _LoginForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        passwordFocus: _passwordFocus,
                        onSubmit: _submit,
                      ),
                      AppSpacing.verticalGap(AppSpacing.lg),
                      Text(
                        context.l10n.loginNoAccount,
                        style: context.textStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Form fields plus the failure banner driven by [AuthState].
class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.passwordFocus,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode passwordFocus;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final failure = state.failure;
        final isBusy = state.status == AuthStatus.authenticating;
        final l10n = context.l10n;

        final emailError = _errorFor(failure, ValidationField.email, l10n);
        final passwordError = _errorFor(
          failure,
          ValidationField.password,
          l10n,
        );
        final hasBannerError = failure != null && emailError == null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EmailTextField(
              controller: emailController,
              enabled: !isBusy,
              errorText: emailError,
              onSubmitted: (_) => passwordFocus.requestFocus(),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            PasswordTextField(
              controller: passwordController,
              enabled: !isBusy,
              errorText: passwordError,
              onSubmitted: (_) => onSubmit(),
            ),
            if (hasBannerError) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              _FailureBanner(message: failure.localize(l10n)),
            ],
            AppSpacing.verticalGap(AppSpacing.lg),
            SubmitButton(
              label: l10n.loginSubmit,
              busyLabel: l10n.loginSubmitting,
              isBusy: isBusy,
              onPressed: onSubmit,
            ),
          ],
        );
      },
    );
  }

  /// Shows a validation error only under the field it belongs to.
  String? _errorFor(
    Failure? failure,
    ValidationField field,
    AppLocalizations l10n,
  ) {
    if (failure is! ValidationFailure || failure.field != field) return null;
    return failure.localize(l10n);
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
        borderRadius: AppRadii.field,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            size: AppDimensions.iconSmall,
            color: theme.colorScheme.onErrorContainer,
          ),
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
