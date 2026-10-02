import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/password_recovery_cubit.dart';
import '../bloc/password_recovery_state.dart';
import '../mock/password_recovery_fixtures.dart';
import '../widgets/recovery_task_bar.dart';
import '../widgets/recovery_widgets.dart';

/// Step 1 — request a recovery code.
///
/// Design: `ui-designs/auth/forgot_password/account_recovery_request_code`.
class RequestRecoveryCodePage extends StatefulWidget {
  const RequestRecoveryCodePage({super.key});

  @override
  State<RequestRecoveryCodePage> createState() =>
      _RequestRecoveryCodePageState();
}

class _RequestRecoveryCodePageState extends State<RequestRecoveryCodePage> {
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    context.read<PasswordRecoveryCubit>().requestCode();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PasswordRecoveryCubit>();

    return BlocListener<PasswordRecoveryCubit, PasswordRecoveryState>(
      listenWhen: (previous, current) =>
          previous.step != current.step &&
          current.step == RecoveryStep.verifyCode,
      listener: (context, state) =>
          context.goNamed(Routes.verifyRecoveryCodeName),
      child: Scaffold(
        body: Column(
          children: [
            RecoveryTaskBar(
              onBack: () => context.goNamed(Routes.loginName),
              title: context.l10n.recoveryPortalTitle,
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
                      child:
                          BlocBuilder<
                            PasswordRecoveryCubit,
                            PasswordRecoveryState
                          >(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _ReferenceRow(
                                    protocol:
                                        RecoveryFixtures.protocolReference,
                                    reference:
                                        RecoveryFixtures.registryReference,
                                  ),
                                  AppSpacing.verticalGap(AppSpacing.lg),
                                  Text(
                                    context.l10n.recoveryRequestTitle,
                                    style: context.textStyles.headlineMedium
                                        ?.copyWith(
                                          color: context.colors.primary,
                                        ),
                                  ),
                                  AppSpacing.verticalGap(AppSpacing.sm),
                                  Text(
                                    context.l10n.recoveryRequestSubtitle,
                                    style: context.textStyles.bodyMedium
                                        ?.copyWith(
                                          color:
                                              context.colors.onSurfaceVariant,
                                        ),
                                  ),
                                  AppSpacing.verticalGap(AppSpacing.lg),
                                  _IdentifierField(
                                    controller: _identifierController,
                                    enabled: !state.isBusy,
                                    errorText: state.errorMessage,
                                    onChanged: cubit.identifierChanged,
                                    onSubmitted: (_) => _submit(),
                                  ),
                                  AppSpacing.verticalGap(AppSpacing.lg),
                                  RecoveryNotice(
                                    title:
                                        context.l10n.recoverySecurityProtocol,
                                    body: context
                                        .l10n
                                        .recoverySecurityProtocolBody,
                                  ),
                                  AppSpacing.verticalGap(AppSpacing.lg),
                                  FilledButton.icon(
                                    onPressed: state.isBusy
                                        ? null
                                        : (_identifierController.text
                                                  .trim()
                                                  .isEmpty
                                              ? null
                                              : _submit),
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                    ),
                                    label: Text(context.l10n.recoverySendCode),
                                  ),
                                  AppSpacing.verticalGap(AppSpacing.lg),
                                  TextButton.icon(
                                    onPressed: () =>
                                        context.goNamed(Routes.loginName),
                                    icon: const Icon(
                                      Icons.chevron_right,
                                      size: 18,
                                    ),
                                    label: Text(
                                      context.l10n.recoveryRememberedPassword,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Protocol badge and registry reference from the design's card header.
///
/// A [Wrap] rather than a [Row] so the reference drops onto its own line on
/// narrow phones instead of overflowing.
class _ReferenceRow extends StatelessWidget {
  const _ReferenceRow({required this.protocol, required this.reference});

  final String protocol;
  final String reference;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        RecoveryStatusChip(label: protocol, icon: Icons.verified_user_outlined),
        Text(
          reference,
          style: context.textStyles.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _IdentifierField extends StatelessWidget {
  const _IdentifierField({
    required this.controller,
    required this.enabled,
    required this.onChanged,
    required this.onSubmitted,
    this.errorText,
  });

  final TextEditingController controller;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.l10n.recoveryIdentifierLabel} *',
          style: context.textStyles.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        TextField(
          controller: controller,
          enabled: enabled,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: context.l10n.recoveryIdentifierHint,
            suffixIcon: const Icon(Icons.badge_outlined, size: 20),
            errorText: errorText,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.xs),
        Text(
          context.l10n.recoveryIdentifierHelper,
          style: context.textStyles.bodySmall,
        ),
      ],
    );
  }
}
