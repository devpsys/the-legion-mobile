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
import '../widgets/identifier_field.dart';
import '../widgets/recovery_task_bar.dart';
import '../widgets/recovery_widgets.dart';
import '../widgets/reference_row.dart';

/// Step 1 — request a recovery code.
///
/// Design: `ui-designs/auth/forgot_password/account_recovery_request_code`.
class RequestRecoveryCodePage extends StatefulWidget {
  const RequestRecoveryCodePage({super.key});

  @override
  RequestRecoveryCodePageState createState() => RequestRecoveryCodePageState();
}

class RequestRecoveryCodePageState extends State<RequestRecoveryCodePage> {
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
                                  ReferenceRow(
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
                                  IdentifierField(
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
                                      size: AppDimensions.iconDense,
                                    ),
                                    label: Text(context.l10n.recoverySendCode),
                                  ),
                                  AppSpacing.verticalGap(AppSpacing.lg),
                                  TextButton.icon(
                                    onPressed: () =>
                                        context.goNamed(Routes.loginName),
                                    icon: const Icon(
                                      Icons.chevron_right,
                                      size: AppDimensions.iconDense,
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
