import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../models/examinations_models.dart';

/// The five rules of a resit, as a short list.
class ResitHowItWorks extends StatelessWidget {
  const ResitHowItWorks({required this.record, super.key});

  final ResitsRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final rules = [
      l10n.examResitRuleFailedOnly,
      l10n.examResitRuleCap(record.unitCap),
      l10n.examResitRuleFee(formatNaira(record.feePerUnitMinorUnits)),
      l10n.examResitRuleBoth,
      l10n.examResitRuleWithdraw,
    ];

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.examResitHowTitle, style: theme.textTheme.titleMedium),
          AppSpacing.verticalGap(AppSpacing.sm),
          for (final rule in rules)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: AppDimensions.iconSmall,
                    color: theme.colorScheme.primary,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(child: Text(rule, style: theme.textTheme.bodySmall)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
