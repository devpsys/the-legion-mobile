import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/widgets/labelled_value_row.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/accommodation_cubit.dart';
import '../bloc/accommodation_state.dart';
import '../models/accommodation_models.dart';
import 'accommodation_confirm_sheet.dart';
import 'accommodation_labels.dart';
import 'bed_docket_card.dart';
import 'next_steps_card.dart';
import 'slip_code_row.dart';
import 'swap_composer_card.dart';

/// A confirmed bed, paid or free (a scholarship quota): the docket, the
/// allocation slip, the price, what happens next, and cancel and swap.
class ConfirmedBedSection extends StatelessWidget {
  const ConfirmedBedSection({
    required this.state,
    required this.term,
    required this.cubit,
    super.key,
  });

  final AccommodationState state;
  final TermAccommodation term;
  final AccommodationCubit cubit;

  Future<void> _cancel(BuildContext context, bool isFree) async {
    final l10n = context.l10n;
    final confirmed = await AccommodationConfirmSheet.show(
      context,
      title: l10n.accommodationCancelConfirmedTitle,
      body: isFree
          ? l10n.accommodationCancelFreeBody
          : l10n.accommodationCancelPaidBody,
      confirmLabel: l10n.accommodationCancelForfeit,
      keepLabel: l10n.accommodationCancelKeepBed,
    );
    if (confirmed) cubit.cancelBooking();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final bed = term.bed;
    if (bed == null) return const SizedBox.shrink();
    final fee = term.fee;
    final isFree = term.isFree;
    final code = term.slipCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BedDocketCard(
          bed: bed,
          statusLabel: l10n.accommodationStatusConfirmed,
          tone: AppTone.success,
          eyebrow: isFree ? l10n.accommodationScholarshipQuota : null,
          sections: [
            Text(
              l10n.accommodationYoursFor(
                AccommodationLabels.bedFull(l10n, bed),
                term.label,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            if (code != null)
              SlipCodeRow(
                code: code,
                hint: l10n.accommodationSlipHint,
                downloadLabel: l10n.accommodationSlipDownload,
              ),
            if (fee != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LabelledValueRow(
                    label: l10n.accommodationPrice,
                    value: isFree
                        ? l10n.accommodationPriceFree
                        : formatNaira(fee.amountMinorUnits),
                    isCode: true,
                  ),
                  if (isFree) ...[
                    AppSpacing.verticalGap(AppSpacing.md),
                    ToneCallout(
                      tone: AppTone.success,
                      icon: Icons.verified_user_outlined,
                      body: l10n.accommodationFreeNote,
                    ),
                  ],
                ],
              ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        NextStepsCard(term: term),
        AppSpacing.verticalGap(AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () => _cancel(context, isFree),
          icon: const Icon(Icons.cancel_outlined),
          label: Text(l10n.accommodationCancelBooking),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        SwapComposerCard(
          lookup: state.swapLookup,
          onVerify: cubit.lookupSwapTarget,
          onPropose: cubit.proposeSwap,
        ),
      ],
    );
  }
}
