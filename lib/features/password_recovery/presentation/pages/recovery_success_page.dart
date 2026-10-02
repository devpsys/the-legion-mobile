import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../bloc/password_recovery_cubit.dart';
import '../mock/password_recovery_fixtures.dart';
import '../widgets/recovery_audit_card.dart';
import '../widgets/recovery_task_bar.dart';
import '../widgets/recovery_widgets.dart';

/// Step 4 — audit summary of the completed recovery.
///
/// Design: `ui-designs/auth/forgot_password/account_recovery_success_confirmation`.
class RecoverySuccessPage extends StatelessWidget {
  const RecoverySuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PasswordRecoveryCubit>().state;
    final identifier = state.identifier;

    return Scaffold(
      body: Column(
        children: [
          RecoveryTaskBar(
            onBack: () => context.goNamed(Routes.loginName),
            title: context.l10n.recoveryRegistryAuthority,
            subtitle: context.l10n.recoveryAccessDirectorate,
            isDocked: true,
            leading: const _RegistryMonogram(),
            trailing: RecoveryStatusChip(
              label: context.l10n.recoveryVerified,
              icon: Icons.verified_outlined,
              color: AppColors.successText(Brightness.light),
              isMono: false,
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
                        const _SuccessMark(),
                        AppSpacing.verticalGap(AppSpacing.lg),
                        Text(
                          context.l10n.recoverySuccessTitle,
                          style: context.textStyles.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.verticalGap(AppSpacing.sm),
                        Text(
                          context.l10n.recoverySuccessBody(
                            state.terminateOtherSessions,
                          ),
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.verticalGap(AppSpacing.lg),
                        RecoveryAuditCard(
                          accountName: RecoveryFixtures.accountName,
                          registrationNumber:
                              RecoveryFixtures.registrationNumber,
                          email: identifier.isEmpty
                              ? RecoveryFixtures.accountName
                              : identifier,
                          timestamp: DateFormat.yMMMMd('en')
                              .add_jm()
                              .format(DateTime.now()),
                          auditHash: RecoveryFixtures.auditReference,
                          sessionsSummary: state.terminateOtherSessions
                              ? context.l10n.recoverySessionsRevoked
                              : context.l10n.recoverySessionsKept,
                        ),
                        AppSpacing.verticalGap(AppSpacing.lg),
                        RecoveryNotice(
                          icon: Icons.info_outline,
                          title: context.l10n.recoveryAdvisoryTitle,
                          body: context.l10n.recoveryAdvisoryBody(
                            RecoveryFixtures.emergencyHotline,
                          ),
                        ),
                        AppSpacing.verticalGap(AppSpacing.lg),
                        FilledButton.icon(
                          onPressed: () => context.goNamed(Routes.loginName),
                          icon: const Icon(Icons.arrow_forward, size: 18),
                          label: Text(
                            context.l10n.recoverySignInWithNewPassword,
                          ),
                        ),
                        AppSpacing.verticalGap(AppSpacing.sm),
                        TextButton(
                          onPressed: () => context.showMessage(
                            context.l10n.commonComingSoon,
                          ),
                          child: Text(context.l10n.recoveryAuditGuidelines),
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
  }
}

/// Registry monogram from the success design's task bar.
class _RegistryMonogram extends StatelessWidget {
  const _RegistryMonogram();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: AppRadii.elementRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        'LR',
        style: context.textStyles.labelSmall?.copyWith(
          color: context.colors.onPrimary,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

/// Success glyph: filled circle on a tinted ring.
class _SuccessMark extends StatelessWidget {
  const _SuccessMark();

  @override
  Widget build(BuildContext context) {
    final success = AppColors.successText(context.colors.brightness);
    final surface = AppColors.successSurface(context.colors.brightness);

    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(color: surface, shape: BoxShape.circle),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: success.withValues(alpha: 0.35),
              width: 2,
            ),
          ),
          child: Icon(Icons.check, size: 30, color: success),
        ),
      ),
    );
  }
}
