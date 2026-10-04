import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';

/// Status hero, optional unlock banner and ledger rows for gateway return.
class GatewayReturnCard extends StatelessWidget {
  const GatewayReturnCard({
    required this.payment,
    required this.onCopy,
    super.key,
  });

  final GatewayReturn payment;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final status = payment.status;
    final tone = status.tone;

    final title = switch (status) {
      GatewayReturnStatus.pending => l10n.feesGatewayStatusPending,
      GatewayReturnStatus.succeeded => l10n.feesGatewayStatusSucceeded,
      GatewayReturnStatus.failed => l10n.feesGatewayStatusFailed,
      GatewayReturnStatus.expired => l10n.feesGatewayStatusExpired,
    };

    final detail = switch (status) {
      GatewayReturnStatus.pending => l10n.feesGatewayPendingDetail,
      GatewayReturnStatus.succeeded => l10n.feesGatewaySucceededDetail(
        AppDateFormats.longDateTime(locale).format(payment.occurredOn),
      ),
      GatewayReturnStatus.failed => l10n.feesGatewayFailedDetail,
      GatewayReturnStatus.expired => l10n.feesGatewayExpiredDetail,
    };

    final icon = switch (status) {
      GatewayReturnStatus.pending => Icons.hourglass_top_outlined,
      GatewayReturnStatus.succeeded => Icons.check_circle,
      GatewayReturnStatus.failed => Icons.cancel_outlined,
      GatewayReturnStatus.expired => Icons.timer_off_outlined,
    };

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: StatusTag(
              label: title,
              tone: tone,
              isUppercase: true,
              icon: icon,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xl),
          Text(
            formatNaira(payment.amountMinorUnits),
            textAlign: TextAlign.center,
            style: AppTextStyles.tabular(
              AppTextStyles.codeLarge.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: AppTextStyles.bold,
                fontSize: AppTextStyles.headlineLargeSize,
              ),
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
          if (status == GatewayReturnStatus.pending) ...[
            AppSpacing.verticalGap(AppSpacing.sm),
            Text(
              l10n.feesGatewayYouCanClose,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            SelectableText(
              payment.reference,
              textAlign: TextAlign.center,
              style: AppTextStyles.codeLarge.copyWith(
                color: AppTone.warning.foreground(theme.brightness),
                fontWeight: AppTextStyles.bold,
                letterSpacing: AppTextStyles.trackingCode,
              ),
            ),
          ],
          if (status == GatewayReturnStatus.succeeded) ...[
            AppSpacing.verticalGap(AppSpacing.xl),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppTone.warning.surface(theme.brightness),
                borderRadius: AppRadii.elementRadius,
                border: Border.all(
                  color: AppTone.warning.border(theme.brightness),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_open,
                      size: AppDimensions.iconMedium,
                      color: AppTone.warning.foreground(theme.brightness),
                    ),
                    AppSpacing.horizontalGap(AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.feesCoursePortalUnlocked,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                    letterSpacing: AppTextStyles.trackingCaps,
                                  ),
                                ),
                              ),
                              StatusTag(
                                label: l10n.feesCoursePortalActive,
                                tone: AppTone.warning,
                                isUppercase: true,
                              ),
                            ],
                          ),
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            l10n.feesCoursePortalDetail,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: AppTextStyles.relaxedLineHeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          AppSpacing.verticalGap(AppSpacing.xl),
          LabelledValueRow(
            label: l10n.feesStudentName,
            value: payment.studentName,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          LabelledValueRow(
            label: l10n.feesMatricNumber,
            value: payment.matricNumber,
            isCode: true,
          ),
          if (payment.paidFor != null) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            LabelledValueRow(label: l10n.feesPaidFor, value: payment.paidFor!),
          ],
          if (payment.rrr != null) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            GatewayCopyRow(
              label: l10n.feesRemitaRrr,
              value: payment.rrr!,
              onCopy: onCopy,
            ),
          ],
          if (payment.gatewayReference != null) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            GatewayCopyRow(
              label: l10n.feesGatewayReference,
              value: payment.gatewayReference!,
              onCopy: onCopy,
            ),
          ],
          AppSpacing.verticalGap(AppSpacing.md),
          LabelledValueRow(
            label: l10n.feesPaymentChannel,
            value: payment.channelLabel,
          ),
        ],
      ),
    );
  }
}

/// A mono value with a copy control, for RRR and gateway references.
class GatewayCopyRow extends StatelessWidget {
  const GatewayCopyRow({
    required this.label,
    required this.value,
    required this.onCopy,
    super.key,
  });

  final String label;
  final String value;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: SelectableText(
                  value,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.codeMedium.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => onCopy(value),
                tooltip: l10n.feesCopy,
                icon: Icon(
                  Icons.content_copy,
                  size: AppDimensions.iconSmall,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Copies [text] and shows the shared "reference copied" snackbar.
Future<void> copyGatewayReference(BuildContext context, String text) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  context.showMessage(context.l10n.feesReferenceCopied);
}
