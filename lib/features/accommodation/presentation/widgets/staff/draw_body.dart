import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/labelled_value_row.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import '../../models/staff/housing_models.dart';
import 'housing_confirm_dialog.dart';
import 'housing_field.dart';
import 'housing_labels.dart';
import 'housing_section.dart';

/// The draw: how the winners are picked, how many beds it gives out, and what
/// it did.
class DrawBody extends StatefulWidget {
  const DrawBody({required this.state, super.key});

  final HousingState state;

  @override
  DrawBodyState createState() => DrawBodyState();
}

/// State of [DrawBody]: the method and seats being drafted.
class DrawBodyState extends State<DrawBody> {
  DrawMethod _method = DrawMethod.ballot;
  int? _seats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = widget.state;
    final free = state.freeBedTotal;
    final seats = (_seats ?? free).clamp(0, free);
    final outcome = state.drawOutcome;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: l10n.housingDrawTitle,
          description: l10n.housingDrawBody,
          children: [
            HousingMetricRow(
              metrics: [
                HousingMetric(
                  value: '${state.drawApplicants}',
                  caption: l10n.housingMetricApplicants,
                ),
                HousingMetric(
                  value: '$free',
                  caption: l10n.housingMetricFreeBeds,
                ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final method in DrawMethod.values)
                  ChoiceChip(
                    label: Text(HousingLabels.drawMethod(l10n, method)),
                    selected: _method == method,
                    onSelected: (_) => setState(() => _method = method),
                  ),
              ],
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            ToneCallout(
              tone: AppTone.info,
              icon: Icons.info_outline,
              body: _method == DrawMethod.ballot
                  ? l10n.housingDrawBallotNote
                  : l10n.housingDrawPriorityNote,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            HousingStepper(
              label: l10n.housingDrawSeats,
              value: seats,
              max: free,
              step: 5,
              onChanged: (value) => setState(() => _seats = value),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.lg),
        FilledButton.icon(
          onPressed: state.drawApplicants == 0 || seats == 0
              ? null
              : () async {
                  final cubit = context.read<HousingCubit>();
                  final confirmed = await confirmHousingAction(
                    context,
                    title: l10n.housingDrawConfirmTitle,
                    body: l10n.housingDrawConfirmBody(
                      seats,
                      state.drawApplicants,
                    ),
                    confirmLabel: l10n.housingDrawRun,
                  );
                  if (confirmed) {
                    cubit.runDraw(method: _method, seats: seats);
                  }
                },
          icon: const Icon(Icons.casino_outlined),
          label: Text(l10n.housingDrawRun),
        ),
        if (outcome != null) ...[
          AppSpacing.verticalGap(AppSpacing.md),
          HousingSection(
            title: l10n.housingDrawResultTitle,
            children: [
              LabelledValueRow(
                label: l10n.housingDrawReference,
                value: outcome.reference,
                isCode: true,
              ),
              LabelledValueRow(
                label: l10n.housingDrawMethodLabel,
                value: HousingLabels.drawMethod(l10n, outcome.method),
              ),
              LabelledValueRow(
                label: l10n.housingDrawWinners,
                value: l10n.housingDrawWinnersValue(
                  outcome.winners,
                  outcome.applicants,
                ),
              ),
              LabelledValueRow(
                label: l10n.housingDrawWaitlisted,
                value: '${outcome.waitlisted}',
              ),
            ],
          ),
        ],
      ],
    );
  }
}
