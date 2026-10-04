import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';

/// The five public facts a genuine receipt check may show — and nothing more.
class ReceiptVerificationResultCard extends StatelessWidget {
  const ReceiptVerificationResultCard({required this.result, super.key});

  final ReceiptVerificationResult result;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.feesVerifyGenuine,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppTone.success.foreground(theme.brightness),
                  ),
                ),
              ),
              StatusTag(
                label: l10n.feesReceiptSettled,
                tone: AppTone.success,
                isUppercase: true,
                icon: Icons.verified,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          LabelledValueRow(
            label: l10n.feesVerifyReceiptNumber,
            value: result.receiptNumber,
            isCode: true,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          LabelledValueRow(
            label: l10n.feesVerifyAmount,
            value: formatNaira(result.amountMinorUnits),
            isCode: true,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          LabelledValueRow(label: l10n.feesVerifyPaidBy, value: result.paidBy),
          AppSpacing.verticalGap(AppSpacing.md),
          LabelledValueRow(
            label: l10n.feesVerifyPaidFor,
            value: result.paidFor,
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          LabelledValueRow(
            label: l10n.feesVerifyPaidOn,
            value: AppDateFormats.long(locale).format(result.paidOn),
          ),
        ],
      ),
    );
  }
}

/// Shown when the code matches nothing on the ledger.
class ReceiptVerificationNotFoundCard extends StatelessWidget {
  const ReceiptVerificationNotFoundCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.feesVerifyNotFoundTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.feesVerifyNotFoundBody,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: AppTextStyles.relaxedLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}
