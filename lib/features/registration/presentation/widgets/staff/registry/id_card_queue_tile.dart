import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/dates.dart';
import '../../../../../../core/utils/money.dart';
import '../../../../../../core/widgets/status_tag.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../models/registration_models.dart';
import '../../../models/staff/registry_models.dart';
import '../../../widgets/registration_labels.dart';
import '../staff_labels.dart';

/// One card in the ID card production queue, with the actions its state
/// allows. A null callback hides its action.
class IdCardQueueTile extends StatelessWidget {
  const IdCardQueueTile({
    required this.item,
    required this.onPreview,
    this.onMarkPrinted,
    this.onMarkCollected,
    this.onCancel,
    super.key,
  });

  final IdCardProductionItem item;
  final VoidCallback onPreview;
  final VoidCallback? onMarkPrinted;
  final VoidCallback? onMarkCollected;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final dateFormat = AppDateFormats.medium(l10n.localeName);
    final printedOn = item.printedOn;
    final isRequested = item.status == IdCardStatus.requested;
    final blockedUnpaid = isRequested && item.feePayment == IdCardFeePayment.unpaid;
    final blockedPhoto = isRequested && !item.hasPhoto;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.serial,
                  style: AppTextStyles.codeMedium.copyWith(
                    fontWeight: AppTextStyles.semiBold,
                  ),
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              StatusTag(
                label: RegistrationLabels.idCardStatus(l10n, item.status),
                tone: item.status.tone,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            item.studentName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.staffRegistryStudentMeta(
              item.matricNumber,
              item.programmeCode,
              RegistrationLabels.idCardReason(l10n, item.reason),
            ),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            printedOn == null
                ? l10n.staffRegistryRequestedOn(
                    dateFormat.format(item.requestedOn),
                  )
                : l10n.staffRegistryPrintedOn(dateFormat.format(printedOn)),
            style: AppTextStyles.codeSmall.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusTag(
                label: StaffRegistrationLabels.feePayment(
                  l10n,
                  item.feePayment,
                ),
                tone: StaffRegistrationLabels.feePaymentTone(item.feePayment),
              ),
              if (item.feePayment != IdCardFeePayment.notRequired)
                Text(
                  formatNaira(item.feeMinorUnits),
                  style: AppTextStyles.tabular(
                    AppTextStyles.codeSmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          if (blockedUnpaid || blockedPhoto) ...[
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.warning,
              icon: blockedUnpaid
                  ? Icons.payments_outlined
                  : Icons.no_photography_outlined,
              body: blockedUnpaid
                  ? l10n.staffRegistryBlockedUnpaid
                  : l10n.staffRegistryBlockedNoPhoto,
            ),
          ],
          AppSpacing.verticalGap(AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              if (onMarkPrinted != null)
                FilledButton(
                  onPressed: item.canMarkPrinted ? onMarkPrinted : null,
                  child: Text(l10n.staffRegistryMarkPrinted),
                ),
              if (onMarkCollected != null)
                FilledButton(
                  onPressed: onMarkCollected,
                  child: Text(l10n.staffRegistryMarkCollected),
                ),
              OutlinedButton(
                onPressed: onPreview,
                child: Text(l10n.staffRegistryPreview),
              ),
              if (onCancel != null)
                TextButton(
                  onPressed: item.canCancel ? onCancel : null,
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                  ),
                  child: Text(l10n.staffRegistryCancelCard),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
