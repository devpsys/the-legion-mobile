import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/registration_models.dart';
import 'registration_card.dart';
import 'registration_labels.dart';

/// Active credential / request status block on the ID card screen.
class IdCardActiveSection extends StatelessWidget {
  const IdCardActiveSection({
    required this.record,
    required this.onCancel,
    super.key,
  });

  final IdCardRecord record;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final active = record.activeRequest;
    final dateFormat = AppDateFormats.medium(l10n.localeName);

    if (active == null) {
      return RegistrationCard(
        clip: false,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.idCardActiveCredential.toUpperCase(),
                    style: AppTextStyles.codeSmall.copyWith(
                      letterSpacing: AppTextStyles.trackingCaps,
                      fontWeight: AppTextStyles.semiBold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                StatusTag(
                  label: l10n.idCardStatusNone,
                  tone: AppTone.neutral,
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Text(
              record.isFirstIssue
                  ? l10n.idCardNoActiveBody
                  : l10n.idCardPreviousLostBody(
                      record.history.isEmpty
                          ? '—'
                          : record.history.first.serial,
                    ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ],
        ),
      );
    }

    final statusLabel = RegistrationLabels.idCardStatus(l10n, active.status);
    final reasonLabel = RegistrationLabels.idCardReason(l10n, active.reason);

    return RegistrationCard(
      clip: false,
      borderColor: active.isInProgress
          ? theme.colorScheme.primary.withValues(alpha: 0.35)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.idCardActiveCredential.toUpperCase(),
                        style: AppTextStyles.codeSmall.copyWith(
                          letterSpacing: AppTextStyles.trackingCaps,
                          fontWeight: AppTextStyles.semiBold,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        active.serial,
                        style: AppTextStyles.codeMedium.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusTag(label: statusLabel, tone: active.status.tone),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  active.isReadyForCollection
                      ? l10n.idCardReadyBody
                      : l10n.idCardRequestedBody(
                          dateFormat.format(active.requestedOn),
                          reasonLabel,
                        ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: AppTextStyles.relaxedLineHeight,
                  ),
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                IdCardDetailInset(
                  icon: active.feePayment == IdCardFeePayment.unpaid
                      ? Icons.receipt_long_outlined
                      : Icons.check_circle_outline,
                  tone: active.feePayment == IdCardFeePayment.unpaid
                      ? AppTone.warning
                      : AppTone.success,
                  body: switch (active.feePayment) {
                    IdCardFeePayment.unpaid => l10n.idCardFeeUnpaidBody(
                      formatNaira(active.feeMinorUnits),
                    ),
                    IdCardFeePayment.paid => l10n.idCardFeePaid,
                    IdCardFeePayment.notRequired => l10n.idCardFeeFree,
                  },
                ),
                if (active.collectionDeadline != null) ...[
                  AppSpacing.verticalGap(AppSpacing.sm),
                  IdCardDetailInset(
                    icon: Icons.schedule_outlined,
                    tone: AppTone.info,
                    body: l10n.idCardCollectBy(
                      dateFormat.format(active.collectionDeadline!),
                    ),
                  ),
                ],
                AppSpacing.verticalGap(AppSpacing.sm),
                IdCardDetailInset(
                  icon: Icons.verified_user_outlined,
                  tone: AppTone.neutral,
                  body: l10n.idCardVerificationPending,
                ),
                if (onCancel != null) ...[
                  AppSpacing.verticalGap(AppSpacing.lg),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: AppRadii.elementRadius,
                      child: InkWell(
                        onTap: onCancel,
                        borderRadius: AppRadii.elementRadius,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            l10n.idCardCancelRequest,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.dangerText(theme.brightness),
                              fontWeight: AppTextStyles.semiBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Quiet inset row for fee / collection / verification detail.
class IdCardDetailInset extends StatelessWidget {
  const IdCardDetailInset({
    required this.icon,
    required this.tone,
    required this.body,
    super.key,
  });

  final IconData icon;
  final AppTone tone;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final brightness = theme.brightness;
    final foreground = tone == AppTone.neutral
        ? theme.colorScheme.onSurfaceVariant
        : tone.foreground(brightness);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: tone == AppTone.neutral
            ? theme.colorScheme.surfaceContainerLow
            : tone.surface(brightness).withValues(alpha: 0.7),
        borderRadius: AppRadii.elementRadius,
        border: Border.all(
          color: tone == AppTone.neutral
              ? theme.colorScheme.outlineVariant
              : tone.border(brightness).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconDense, color: foreground),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Text(
              body,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foreground,
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
