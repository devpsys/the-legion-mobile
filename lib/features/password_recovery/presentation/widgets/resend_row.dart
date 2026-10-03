import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/password_recovery_state.dart';
import 'recovery_widgets.dart';

/// Resend affordance with its cooldown.
class ResendRow extends StatelessWidget {
  const ResendRow({required this.state, required this.onResend, super.key});

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
