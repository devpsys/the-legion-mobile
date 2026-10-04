import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/emphasised_text.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/fees_models.dart';

/// Student strip and itemised fee schedule on the card checkout.
class CardCheckoutSchedule extends StatelessWidget {
  const CardCheckoutSchedule({required this.session, super.key});

  final CardCheckoutSession session;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final student = session.student;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    AppSpacing.verticalGap(AppSpacing.xs),
                    EmphasisedText(
                      l10n.feesStudentLine(
                        l10n.feesLevel(student.level),
                        student.matricNumber,
                        student.department,
                      ),
                      emphasis: [student.matricNumber],
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      emphasisStyle: AppTextStyles.codeSmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: AppTextStyles.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.verified,
                color: AppTone.success.foreground(theme.brightness),
                size: AppDimensions.iconMedium,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.feesFeeBreakdown,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                l10n.feesItemisedSchedule,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          Text(
            l10n.feesTerm(session.session),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
          for (final line in session.lines) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    line.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: line.isCharge
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  formatNaira(line.amountMinorUnits),
                  style: AppTextStyles.tabular(
                    AppTextStyles.codeMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: AppTextStyles.semiBold,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
          ],
          const Divider(),
          AppSpacing.verticalGap(AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.feesTotalPayable,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                formatNaira(session.totalMinorUnits),
                style: AppTextStyles.tabular(
                  AppTextStyles.codeLarge.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.lg),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppTone.info.surface(theme.brightness),
              borderRadius: AppRadii.elementRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: AppDimensions.iconSmall,
                    color: AppTone.info.foreground(theme.brightness),
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.feesSecurePayment,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppTone.info.foreground(theme.brightness),
                            letterSpacing: AppTextStyles.trackingCaps,
                          ),
                        ),
                        Text(
                          l10n.feesSecurePaymentNote,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusTag(
                    label: l10n.feesTlsActive,
                    tone: AppTone.info,
                    isUppercase: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
