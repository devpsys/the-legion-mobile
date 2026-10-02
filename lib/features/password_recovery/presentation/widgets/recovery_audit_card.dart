import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Audit summary shown after a completed recovery.
///
/// Layout from `account_recovery_success_confirmation`: a card with a tinted
/// header, hairline-separated rows and a mono hash chip.
class RecoveryAuditCard extends StatelessWidget {
  const RecoveryAuditCard({
    required this.accountName,
    required this.registrationNumber,
    required this.email,
    required this.timestamp,
    required this.auditHash,
    required this.sessionsSummary,
    super.key,
  });

  final String accountName;
  final String registrationNumber;
  final String email;
  final String timestamp;
  final String auditHash;
  final String sessionsSummary;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
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
                Icon(
                  Icons.receipt_long_outlined,
                  size: 22,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Expanded(
                  child: Text(
                    context.l10n.recoveryAuditSummary,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Text(
                  context.l10n.recoveryStatusCommitted,
                  style: AppTextStyles.codeSmall.copyWith(
                    color: theme.colorScheme.outline,
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSpacing.card,
            child: Column(
              children: [
                _AuditRow(
                  label: context.l10n.recoveryAuditAccount,
                  value: '$accountName ($registrationNumber)',
                ),
                _AuditRow(label: context.l10n.recoveryAuditEmail, value: email),
                _AuditRow(
                  label: context.l10n.recoveryAuditTimestamp,
                  value: timestamp,
                ),
                _AuditRow(
                  label: context.l10n.recoveryAuditHash,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: AppRadii.elementRadius,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      auditHash,
                      style: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.primary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
                _AuditRow(
                  label: context.l10n.recoveryAuditSessions,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.successText(theme.brightness),
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Flexible(
                        child: Text(
                          sessionsSummary,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Label/value row that stacks on phones and aligns on wider layouts.
class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.label, this.value, this.child});

  final String label;
  final String? value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final labelWidget = Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );

    final valueWidget =
        child ??
        Text(
          value!,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.end,
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: context.screenSize.isCompactOrMedium
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                labelWidget,
                AppSpacing.verticalGap(AppSpacing.xs),
                Align(alignment: Alignment.centerLeft, child: valueWidget),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: labelWidget),
                AppSpacing.horizontalGap(AppSpacing.md),
                Flexible(child: valueWidget),
              ],
            ),
    );
  }
}
