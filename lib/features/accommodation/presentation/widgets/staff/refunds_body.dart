import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/money.dart';
import '../../../../../core/widgets/labelled_value_row.dart';
import '../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_field.dart';
import 'housing_section.dart';

/// Cancellation refunds: the share and window, and a simulator that shows what
/// one cancellation would hand back.
class RefundsBody extends StatefulWidget {
  const RefundsBody({required this.state, super.key});

  final HousingState state;

  @override
  RefundsBodyState createState() => RefundsBodyState();
}

/// State of [RefundsBody]: the drafted share, window and simulation inputs.
class RefundsBodyState extends State<RefundsBody> {
  late int _share = widget.state.refundPolicy.sharePercent;
  late int _window = widget.state.refundPolicy.windowDays;
  int _daysBefore = 21;
  late final TextEditingController _paid = TextEditingController(
    text: formatNairaFigure(7500000),
  );
  bool _paidInvalid = false;

  @override
  void dispose() {
    _paid.dispose();
    super.dispose();
  }

  void _simulate() {
    final amount = parseNaira(_paid.text);
    setState(() => _paidInvalid = amount == null);
    if (amount == null) return;
    context.read<HousingCubit>().simulateRefund(
      paidMinorUnits: amount,
      daysBeforeCheckIn: _daysBefore,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final policy = widget.state.refundPolicy;
    final simulation = widget.state.refundSimulation;
    final changed =
        _share != policy.sharePercent || _window != policy.windowDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: l10n.housingRefundsTitle,
          description: l10n.housingRefundsIntro,
          children: [
            HousingStepper(
              label: l10n.housingRefundShare,
              value: _share,
              max: 100,
              step: 5,
              suffix: l10n.housingPercentSign,
              onChanged: (value) => setState(() => _share = value),
            ),
            AppSpacing.verticalGap(AppSpacing.sm),
            HousingStepper(
              label: l10n.housingRefundWindow,
              value: _window,
              max: 90,
              suffix: l10n.housingDaysSuffix,
              onChanged: (value) => setState(() => _window = value),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            FilledButton(
              onPressed: changed
                  ? () => context.read<HousingCubit>().setRefundPolicy(
                      sharePercent: _share,
                      windowDays: _window,
                    )
                  : null,
              child: Text(l10n.housingSave),
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        HousingSection(
          title: l10n.housingSimulateTitle,
          description: l10n.housingSimulateBody,
          children: [
            HousingField(
              label: l10n.housingSimulatePaid,
              controller: _paid,
              prefixText: nairaSymbol,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              errorText: _paidInvalid ? l10n.housingPriceInvalid : null,
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            HousingStepper(
              label: l10n.housingSimulateDays,
              value: _daysBefore,
              max: 120,
              suffix: l10n.housingDaysSuffix,
              onChanged: (value) => setState(() => _daysBefore = value),
            ),
            AppSpacing.verticalGap(AppSpacing.md),
            OutlinedButton.icon(
              onPressed: _simulate,
              icon: const Icon(Icons.calculate_outlined),
              label: Text(l10n.housingSimulateRun),
            ),
            if (simulation != null) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              LabelledValueRow(
                label: l10n.housingSimulatePaid,
                value: formatNaira(simulation.paidMinorUnits),
                isCode: true,
              ),
              LabelledValueRow(
                label: l10n.housingSimulateRefund,
                value: formatNaira(simulation.refundMinorUnits),
                isCode: true,
              ),
              LabelledValueRow(
                label: l10n.housingSimulateCharge,
                value: formatNaira(simulation.chargeMinorUnits),
                isCode: true,
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              ToneCallout(
                tone: simulation.refundMinorUnits > 0
                    ? AppTone.success
                    : AppTone.warning,
                icon: simulation.refundMinorUnits > 0
                    ? Icons.check_circle_outline
                    : Icons.info_outline,
                body: simulation.refundMinorUnits > 0
                    ? l10n.housingSimulateWithin(policy.windowDays)
                    : l10n.housingSimulateOutside(policy.windowDays),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
