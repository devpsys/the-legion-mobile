import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../bloc/password_recovery_cubit.dart';
import '../bloc/password_recovery_state.dart';
import '../mock/password_recovery_fixtures.dart';
import '../widgets/otp_code_field.dart';
import '../widgets/recovery_task_bar.dart';
import '../widgets/recovery_widgets.dart';

/// Step 2 — verify the dispatched code.
///
/// Design: `ui-designs/auth/forgot_password/account_recovery_verify_code`.
class VerifyRecoveryCodePage extends StatefulWidget {
  const VerifyRecoveryCodePage({super.key});

  @override
  State<VerifyRecoveryCodePage> createState() => _VerifyRecoveryCodePageState();
}

class _VerifyRecoveryCodePageState extends State<VerifyRecoveryCodePage> {
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: context.read<PasswordRecoveryCubit>().state.code,
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<PasswordRecoveryCubit>().verifyCode();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PasswordRecoveryCubit>();

    return BlocListener<PasswordRecoveryCubit, PasswordRecoveryState>(
      listenWhen: (previous, current) =>
          previous.step != current.step &&
          current.step == RecoveryStep.setPassword,
      listener: (context, state) => context.goNamed(Routes.setNewPasswordName),
      child: BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
        listenWhen: (previous, current) =>
            previous.attemptedCodes != current.attemptedCodes,
        listener: (context, state) {
          if (state.attemptedCodes > 0 && !state.isCodeLocked) {
            context.showErrorMessage(
              context.l10n.recoveryCodeInvalid(
                RecoveryRules.maxCodeAttempts - state.attemptedCodes,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                RecoveryTaskBar(
                  onBack: () => context.goNamed(Routes.forgotPasswordName),
                  title: context.l10n.recoverySovereignId,
                  trailing: RecoveryStatusChip(
                    label: context.l10n.recoverySecurityLevel,
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
                              _StageRow(attempts: state.attemptedCodes),
                              AppSpacing.verticalGap(AppSpacing.lg),
                              Text(
                                context.l10n.recoveryVerifyTitle,
                                style: context.textStyles.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                              AppSpacing.verticalGap(AppSpacing.sm),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${context.l10n.recoveryVerifySent} ',
                                    ),
                                    if (state.maskedEmail != null)
                                      TextSpan(
                                        text: state.maskedEmail,
                                        style: context.textStyles.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    TextSpan(
                                      text:
                                          ' ${context.l10n.recoveryVerifyAndSms} ',
                                    ),
                                    if (state.maskedPhone != null)
                                      TextSpan(
                                        text: state.maskedPhone,
                                        style: context.textStyles.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    TextSpan(text: '.'),
                                  ],
                                ),
                                style: context.textStyles.bodyMedium?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              AppSpacing.verticalGap(AppSpacing.lg),
                              if (state.isCodeLocked)
                                RecoveryNotice(
                                  icon: Icons.lock_outline,
                                  title: context.l10n.recoveryCodeLockedTitle,
                                  body: context.l10n.recoveryCodeLockedBody(
                                    RecoveryCountdownBadge.format(
                                      state.codeLockedFor,
                                    ),
                                  ),
                                )
                              else
                                Center(
                                  child: RecoveryCountdownBadge(
                                    label: context.l10n.recoveryExpiresIn,
                                    remaining: state.codeExpiresIn,
                                  ),
                                ),
                              AppSpacing.verticalGap(AppSpacing.lg),
                              Text(
                                context.l10n.recoveryCodeLabel,
                                style: context.textStyles.labelSmall?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                  letterSpacing: 0.8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              AppSpacing.verticalGap(AppSpacing.md),
                              OtpCodeField(
                                controller: _codeController,
                                length: RecoveryRules.codeLength,
                                isEnabled: !state.isBusy && !state.isCodeLocked,
                                hasError: state.status == RecoveryStatus.failed,
                                onChanged: (value) {
                                  cubit.codeChanged(value);
                                  if (value.length ==
                                      RecoveryRules.codeLength) {
                                    _submit();
                                  }
                                },
                              ),
                              AppSpacing.verticalGap(AppSpacing.md),
                              _ResendRow(
                                state: state,
                                onResend: cubit.resendCode,
                              ),
                              AppSpacing.verticalGap(AppSpacing.lg),
                              RecoveryNotice(
                                icon: Icons.lock_outline,
                                title: context.l10n.recoveryAttemptsTitle,
                                body: context.l10n.recoveryAttemptsBody(
                                  RecoveryRules.maxCodeAttempts,
                                  RecoveryRules.codeLockout.inMinutes,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.lg),
                              FilledButton.icon(
                                onPressed:
                                    state.isBusy ||
                                        state.isCodeLocked ||
                                        !state.isCodeComplete
                                    ? null
                                    : _submit,
                                icon: const Icon(Icons.arrow_forward, size: 18),
                                label: Text(context.l10n.recoveryVerifyCode),
                              ),
                              AppSpacing.verticalGap(AppSpacing.sm),
                              OutlinedButton.icon(
                                onPressed: cubit.useDifferentMethod,
                                icon: const Icon(Icons.key_outlined, size: 18),
                                label: Text(
                                  context.l10n.recoveryDifferentMethod,
                                ),
                              ),
                              AppSpacing.verticalGap(AppSpacing.sm),
                              TextButton(
                                onPressed: () =>
                                    context.goNamed(Routes.loginName),
                                child: Text(
                                  context.l10n.recoveryCancelAndReturn,
                                ),
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
      ),
    );
  }
}

/// Stage indicator and session reference from the design's card header.
class _StageRow extends StatelessWidget {
  const _StageRow({required this.attempts});

  final int attempts;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: context.colors.secondary,
            shape: BoxShape.circle,
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.sm),
        Expanded(
          child: Text(
            context.l10n.recoveryStage(2),
            style: context.textStyles.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Text(
          RecoveryFixtures.sessionReference,
          style: AppTextStyles.codeSmall.copyWith(
            color: context.colors.outline,
          ),
        ),
      ],
    );
  }
}

/// Resend affordance with its cooldown.
class _ResendRow extends StatelessWidget {
  const _ResendRow({required this.state, required this.onResend});

  final PasswordRecoveryState state;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            context.l10n.recoveryNoCode,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        AppSpacing.horizontalGap(AppSpacing.xs),
        if (state.canResend)
          TextButton(
            onPressed: onResend,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, AppDimensions.minTapTarget),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            ),
            child: Text(context.l10n.recoveryResendCode),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Text(
              '${context.l10n.recoveryResendIn} '
              '${RecoveryCountdownBadge.format(state.resendAvailableIn)}',
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
      ],
    );
  }
}
