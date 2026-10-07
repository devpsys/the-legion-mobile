import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_confirm_dialog.dart';
import 'housing_section.dart';

/// Places the waitlist into the free beds automatically.
class AutoAllocationBody extends StatelessWidget {
  const AutoAllocationBody({required this.state, super.key});

  final HousingState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final outcome = state.autoOutcome;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: l10n.housingAutoTitle,
          description: l10n.housingAutoBody,
          children: [
            HousingMetricRow(
              metrics: [
                HousingMetric(
                  value: '${state.waitlistCount}',
                  caption: l10n.housingMetricWaitlist,
                ),
                HousingMetric(
                  value: '${state.freeBedTotal}',
                  caption: l10n.housingMetricFreeBeds,
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.info,
              icon: Icons.rule_folder_outlined,
              body: l10n.housingAutoRules,
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        FilledButton.icon(
          onPressed: state.waitlistCount == 0 || state.freeBedTotal == 0
              ? null
              : () async {
                  final cubit = context.read<HousingCubit>();
                  final confirmed = await confirmHousingAction(
                    context,
                    title: l10n.housingAutoConfirmTitle,
                    body: l10n.housingAutoConfirmBody(
                      state.waitlistCount,
                      state.freeBedTotal,
                    ),
                    confirmLabel: l10n.housingAutoRun,
                  );
                  if (confirmed) cubit.runAutoAllocation();
                },
          icon: const Icon(Icons.auto_fix_high_outlined),
          label: Text(l10n.housingAutoRun),
        ),
        if (outcome != null) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          HousingSection(
            title: l10n.housingAutoResultTitle,
            children: [
              HousingMetricRow(
                metrics: [
                  HousingMetric(
                    value: '${outcome.placed}',
                    caption: l10n.housingAutoPlaced,
                  ),
                  HousingMetric(
                    value: '${outcome.unplaced}',
                    caption: l10n.housingAutoUnplaced,
                  ),
                  HousingMetric(
                    value: '${outcome.freeBedsLeft}',
                    caption: l10n.housingAutoLeft,
                  ),
                ],
              ),
            ],
          ),
        ],
      ],
    );
  }
}
