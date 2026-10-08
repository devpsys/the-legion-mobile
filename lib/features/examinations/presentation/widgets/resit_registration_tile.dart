import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';
import 'examinations_labels.dart';

/// A registered resit drawn as a receipt: the course, its invoice, and
/// whether the bursary is still waiting to be paid.
class ResitRegistrationTile extends StatelessWidget {
  const ResitRegistrationTile({required this.registration, super.key});

  final ResitRegistration registration;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final muted = theme.colorScheme.onSurfaceVariant;
    final awaiting =
        registration.payment == ResitPaymentStatus.awaitingPayment;

    return SurfaceCard(
      padding: EdgeInsets.zero,
      borderRadius: AppRadii.blockRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            color: theme.colorScheme.surfaceContainerLow,
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: AppDimensions.iconSmall,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.horizontalGap(AppSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.examResitReceiptDocket,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.codeSmall.copyWith(color: muted),
                  ),
                ),
                AppSpacing.horizontalGap(AppSpacing.sm),
                Text(
                  l10n.examResitInvoice(registration.invoiceReference),
                  style: AppTextStyles.codeSmall.copyWith(
                    color: muted,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSpacing.card,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          registration.code,
                          style: AppTextStyles.codeLarge.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        AppSpacing.horizontalGap(AppSpacing.xs),
                        Container(
                          width: AppSpacing.xs,
                          height: AppSpacing.xs,
                          decoration: BoxDecoration(
                            color: muted.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        AppSpacing.horizontalGap(AppSpacing.xs),
                        Text(
                          l10n.examUnitsValue(registration.units),
                          style: AppTextStyles.codeSmall.copyWith(color: muted),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DocketStatusChip(
                          label: l10n.examResitRegisteredTag,
                          tone: AppTone.info,
                        ),
                        AppSpacing.horizontalGap(AppSpacing.xs),
                        DocketStatusChip(
                          label: ExaminationsLabels.resitPayment(
                            l10n,
                            registration.payment,
                          ),
                          tone: ExaminationsLabels.resitPaymentTone(
                            registration.payment,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.examResitSemester(registration.termLabel),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.codeSmall.copyWith(color: muted),
                        ),
                      ),
                      AppSpacing.horizontalGap(AppSpacing.sm),
                      Text(
                        awaiting
                            ? l10n.examResitPaymentRequired
                            : l10n.examResitPaid,
                        style: AppTextStyles.codeSmall.copyWith(
                          color: awaiting
                              ? AppTone.warning.foreground(theme.brightness)
                              : AppTone.success.foreground(theme.brightness),
                          fontWeight: AppTextStyles.semiBold,
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

/// A small status pill on a receipt.
class DocketStatusChip extends StatelessWidget {
  const DocketStatusChip({
    required this.label,
    required this.tone,
    super.key,
  });

  final String label;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final foreground = tone.foreground(theme.brightness);

    final chip = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: tone.surface(theme.brightness),
        borderRadius: AppRadii.chipRadius,
        border: Border.all(color: tone.border(theme.brightness)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foreground,
              fontWeight: AppTextStyles.semiBold,
            ),
          ),
        ],
      ),
    );

    return chip;
  }
}
