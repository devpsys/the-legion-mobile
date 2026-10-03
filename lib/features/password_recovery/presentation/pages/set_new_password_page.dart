import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../bloc/password_recovery_cubit.dart';
import '../bloc/password_recovery_state.dart';
import '../mock/password_recovery_fixtures.dart';
import '../widgets/password_field.dart';
import '../widgets/password_requirements_list.dart';
import '../widgets/password_strength_meter.dart';
import '../widgets/recovery_task_bar.dart';
import '../widgets/recovery_widgets.dart';
import '../widgets/terminate_sessions_tile.dart';

/// Step 3 — choose and confirm a new password.
///
/// Design: `ui-designs/auth/forgot_password/account_recovery_set_new_password`.
class SetNewPasswordPage extends StatefulWidget {
  const SetNewPasswordPage({super.key});

  @override
  SetNewPasswordPageState createState() => SetNewPasswordPageState();
}

class SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<PasswordRecoveryCubit>().updatePassword();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PasswordRecoveryCubit>();

    return BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
      listenWhen: (previous, current) =>
          previous.step != current.step ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.step == RecoveryStep.completed) {
          context.goNamed(Routes.recoverySuccessName);
          return;
        }
        // A policy failure is not tied to one field, so it surfaces as a
        // message rather than under an input.
        if (state.errorMessage == RecoveryValidationError.policyNotMet.key) {
          context.showErrorMessage(context.l10n.recoveryPasswordPolicyError);
        }
      },
      builder: (context, state) {
        final requirements = cubit.evaluatePassword(state.password);
        final errorKey = state.errorMessage;

        return Scaffold(
          body: Column(
            children: [
              RecoveryTaskBar(
                onBack: () => context.goNamed(Routes.verifyRecoveryCodeName),
                title: context.l10n.recoveryResetPasswordTitle,
                trailing: RecoveryStatusChip(
                  label: context.l10n.recoveryStepOf(3, 3),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppDimensions.maxFormWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              context.l10n.recoveryNewPasswordSubtitle,
                              style: context.textStyles.bodyMedium?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                            AppSpacing.verticalGap(AppSpacing.lg),
                            PasswordField(
                              label: context.l10n.recoveryNewPasswordLabel,
                              hint: context.l10n.recoveryNewPasswordHint,
                              controller: _passwordController,
                              enabled: !state.isBusy,
                              onChanged: cubit.passwordChanged,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => _confirmFocus.requestFocus(),
                            ),
                            AppSpacing.verticalGap(AppSpacing.sm),
                            PasswordStrengthMeter(
                              strength: cubit.policy.strengthOf(state.password),
                              metCount: requirements
                                  .where((r) => r.isMet)
                                  .length,
                              totalCount: requirements.length,
                            ),
                            AppSpacing.verticalGap(AppSpacing.lg),
                            PasswordRequirementsList(
                              requirements: requirements,
                              reference: RecoveryFixtures.policyReference,
                            ),
                            AppSpacing.verticalGap(AppSpacing.lg),
                            PasswordField(
                              label:
                                  '${context.l10n.recoveryConfirmPassword} *',
                              hint: context.l10n.recoveryConfirmPasswordHint,
                              controller: _confirmController,
                              enabled: !state.isBusy,
                              onChanged: cubit.confirmPasswordChanged,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                              errorText:
                                  errorKey ==
                                      RecoveryValidationError.mismatch.key
                                  ? context.l10n.recoveryPasswordMismatch
                                  : null,
                            ),
                            AppSpacing.verticalGap(AppSpacing.md),
                            TerminateSessionsTile(
                              value: state.terminateOtherSessions,
                              enabled: !state.isBusy,
                              onChanged: cubit.terminateOtherSessionsChanged,
                            ),
                            AppSpacing.verticalGap(AppSpacing.lg),
                            FilledButton.icon(
                              onPressed: state.isBusy ? null : _submit,
                              icon: const Icon(
                                Icons.lock_reset,
                                size: AppDimensions.iconDense,
                              ),
                              label: Text(context.l10n.recoveryUpdatePassword),
                            ),
                            AppSpacing.verticalGap(AppSpacing.md),
                            Text(
                              context.l10n.recoveryImmediateEffect,
                              style: context.textStyles.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            AppSpacing.verticalGap(AppSpacing.md),
                            TextButton(
                              onPressed: () =>
                                  context.goNamed(Routes.loginName),
                              child: Text(context.l10n.recoveryCancelAndReturn),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
