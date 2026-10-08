import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../models/examinations_models.dart';
import 'resit_registration_tile.dart';

/// Registered resits, each one a receipt docket for its invoice.
class ResitRegistrationsSection extends StatelessWidget {
  const ResitRegistrationsSection({required this.record, super.key});

  final ResitsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final awaitingPayment = record.registrations.any(
      (registration) =>
          registration.payment == ResitPaymentStatus.awaitingPayment,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.examResitRegisteredTitle.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: AppTextStyles.semiBold,
                  letterSpacing: AppTextStyles.trackingCaps,
                ),
              ),
            ),
            AppSpacing.horizontalGap(AppSpacing.sm),
            Text(
              l10n.examResitRegisteredCount(record.registrations.length),
              style: AppTextStyles.codeSmall.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.sm),
        for (final registration in record.registrations) ...[
          ResitRegistrationTile(registration: registration),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
        if (awaitingPayment)
          ResitPaymentBar(
            onPay: () => context.goNamed(Routes.feesName),
          ),
      ],
    );
  }
}

/// A clearance strip: the bursary mark, what it settles, and one pay button.
class ResitPaymentBar extends StatelessWidget {
  const ResitPaymentBar({required this.onPay, super.key});

  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final primary = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: AppRadii.rowRadius,
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.iconLarge,
            height: AppDimensions.iconLarge,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              size: AppDimensions.iconSmall,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.examResitBursaryClearance,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  l10n.examResitSettleLedger,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.horizontalGap(AppSpacing.sm),
          FilledButton(
            onPressed: onPay,
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, AppDimensions.buttonHeight),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.elementRadius,
              ),
              textStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: AppTextStyles.semiBold,
              ),
            ),
            child: Text(l10n.examResitPayFees),
          ),
        ],
      ),
    );
  }
}
