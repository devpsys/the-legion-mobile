import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/status_tag.dart';
import '../models/fees_models.dart';
import 'checkout_option_tile.dart';

/// How to pay: the gateway, a bank branch, or a virtual account.
///
/// Each option says when it clears, because that is the difference between
/// them a student cares about: the gateway and the virtual account are
/// instant, a bank branch takes up to a day. The bank branch option carries
/// the reference the teller will ask for, with a button to copy it.
class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    required this.method,
    required this.terms,
    required this.student,
    required this.onMethodChanged,
    required this.onCopyReference,
    super.key,
  });

  final PaymentMethod method;
  final PaymentTerms terms;
  final FeesStudent student;
  final ValueChanged<PaymentMethod> onMethodChanged;

  /// Copies the bank branch reference, handed the reference itself.
  final ValueChanged<String> onCopyReference;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final success = AppColors.successText(theme.brightness);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.feesPaymentMethod.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: AppTextStyles.trackingCapsWide,
                ),
              ),
            ),
            Icon(
              Icons.verified_user_outlined,
              size: AppDimensions.iconSmall,
              color: success,
            ),
            AppSpacing.horizontalGap(AppSpacing.xs),
            Text(
              l10n.feesVerifiedIntegrations,
              style: theme.textTheme.labelSmall?.copyWith(color: success),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        RadioGroup<PaymentMethod>(
          groupValue: method,
          onChanged: (value) {
            if (value != null) onMethodChanged(value);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CheckoutOptionTile<PaymentMethod>(
                value: PaymentMethod.gateway,
                isSelected: method == PaymentMethod.gateway,
                title: l10n.feesMethodGateway,
                tag: StatusTag(
                  label: l10n.feesMethodInstant,
                  tone: AppTone.success,
                ),
                detail: l10n.feesMethodGatewayDetail,
                extra: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    StatusTag(
                      label: l10n.feesChipDebitCard,
                      tone: AppTone.neutral,
                    ),
                    StatusTag(label: l10n.feesChipUssd, tone: AppTone.neutral),
                    StatusTag(
                      label: l10n.feesChipDirectDebit,
                      tone: AppTone.neutral,
                    ),
                  ],
                ),
                onTap: () => onMethodChanged(PaymentMethod.gateway),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              CheckoutOptionTile<PaymentMethod>(
                value: PaymentMethod.bankBranch,
                isSelected: method == PaymentMethod.bankBranch,
                title: l10n.feesMethodBankBranch,
                tag: StatusTag(
                  label: l10n.feesMethodBankBranchClearing,
                  tone: AppTone.neutral,
                ),
                detail: l10n.feesMethodBankBranchDetail,
                extra: BankBranchReference(
                  reference: terms.bankBranchReference,
                  onCopy: () => onCopyReference(terms.bankBranchReference),
                ),
                onTap: () => onMethodChanged(PaymentMethod.bankBranch),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              CheckoutOptionTile<PaymentMethod>(
                value: PaymentMethod.virtualAccount,
                isSelected: method == PaymentMethod.virtualAccount,
                title: l10n.feesMethodVirtualAccount,
                tag: StatusTag(
                  label: l10n.feesMethodInstant,
                  tone: AppTone.success,
                ),
                detail: l10n.feesMethodVirtualAccountDetail(
                  student.matricNumber,
                ),
                onTap: () => onMethodChanged(PaymentMethod.virtualAccount),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The Remita reference a bank teller asks for, in the mono face, with the
/// one action a reference needs.
class BankBranchReference extends StatelessWidget {
  const BankBranchReference({
    required this.reference,
    required this.onCopy,
    super.key,
  });

  final String reference;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.elementRadius,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.feesRrrLabel(reference),
              style: AppTextStyles.tabular(
                AppTextStyles.codeMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: AppTextStyles.semiBold,
                ),
              ),
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          TextButton.icon(
            onPressed: onCopy,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, AppDimensions.buttonCompact),
              visualDensity: VisualDensity.compact,
            ),
            icon: const Icon(
              Icons.content_copy_outlined,
              size: AppDimensions.iconSmall,
            ),
            label: Text(l10n.feesCopy),
          ),
        ],
      ),
    );
  }
}
