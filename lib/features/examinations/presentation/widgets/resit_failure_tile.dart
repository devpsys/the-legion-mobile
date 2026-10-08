import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../../../core/widgets/surface_card.dart';
import '../bloc/examinations_cubit.dart';
import '../models/examinations_models.dart';
import 'resit_confirm_sheet.dart';

/// One failed course: what it is, what the resit costs and, while the window
/// is open, a Register button that opens the confirm sheet.
class ResitFailureTile extends StatelessWidget {
  const ResitFailureTile({
    required this.record,
    required this.failure,
    super.key,
  });

  final ResitsRecord record;
  final ResitFailure failure;

  Future<void> _register(BuildContext context) async {
    final cubit = context.read<ExaminationsCubit>();
    final confirmed = await ResitConfirmSheet.show(
      context,
      record: record,
      failure: failure,
    );
    if (confirmed) cubit.registerResit(failure.code);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final canRegister = record.canRegister(failure);
    final usesLastUnits =
        record.isOpen && canRegister && failure.units == record.unitsLeft;

    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                failure.code,
                style: AppTextStyles.codeMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              AppSpacing.horizontalGap(AppSpacing.sm),
              Text(l10n.examUnitsValue(failure.units), style: muted),
              const Spacer(),
              Text(
                formatNaira(record.feeFor(failure)),
                style: AppTextStyles.codeMedium,
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(failure.title, style: theme.textTheme.bodyMedium),
          AppSpacing.verticalGap(AppSpacing.xs),
          Text(
            l10n.examResitFailedIn(
              failure.failedScore,
              failure.failedTermLabel,
            ),
            style: muted,
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
          if (!record.isOpen)
            Align(
              alignment: Alignment.centerLeft,
              child: StatusTag(
                label: l10n.examResitNotOpen,
                tone: AppTone.neutral,
              ),
            )
          else ...[
            if (usesLastUnits)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  l10n.examResitUsesLastUnits(failure.units),
                  style: muted,
                ),
              ),
            if (!canRegister)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(l10n.examResitOverBudget, style: muted),
              ),
            FilledButton(
              onPressed: canRegister ? () => _register(context) : null,
              child: Text(l10n.examResitRegister),
            ),
          ],
        ],
      ),
    );
  }
}
