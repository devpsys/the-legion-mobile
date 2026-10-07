import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/accommodation_cubit.dart';
import '../bloc/accommodation_state.dart';
import '../models/accommodation_models.dart';
import 'accommodation_confirm_sheet.dart';
import 'accommodation_labels.dart';
import 'bed_docket_card.dart';
import 'next_steps_card.dart';
import 'swap_composer_card.dart';
import 'swap_proposal_card.dart';

/// A bed reserved and waiting for its fee: the compact docket, the deadline,
/// the grace clause, the invoice, Pay and Cancel, what happens next, and the
/// swap tools.
///
/// When one fee covers the whole session the same docket reads as a session
/// booking.
class HeldBedSection extends StatelessWidget {
  const HeldBedSection({
    required this.state,
    required this.term,
    required this.cubit,
    super.key,
  });

  final AccommodationState state;
  final TermAccommodation term;
  final AccommodationCubit cubit;

  Future<void> _cancel(BuildContext context, BedLocation bed) async {
    final l10n = context.l10n;
    final confirmed = await AccommodationConfirmSheet.show(
      context,
      title: l10n.accommodationCancelTitle,
      body: l10n.accommodationCancelBody(
        AccommodationLabels.roomBed(l10n, bed),
      ),
      confirmLabel: l10n.accommodationCancelConfirm,
      keepLabel: l10n.accommodationCancelKeep,
    );
    if (confirmed) cubit.cancelBooking();
  }

  void _pay(BuildContext context) {
    final reference = cubit.pay();
    if (reference == null) return;
    context.goNamed(Routes.feesName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final bed = term.bed;
    final fee = term.fee;
    final deadline = term.deadline;
    if (bed == null || fee == null || deadline == null) {
      return const SizedBox.shrink();
    }
    final grace = term.graceUntil;
    final formatter = AppDateFormats.weekdayLongDateTime(l10n.localeName);
    final amount = formatNaira(fee.amountMinorUnits);
    final swap = term.swap;
    final reference = fee.invoiceReference;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (swap != null) ...[
          SwapProposalCard(
            proposal: swap,
            onAccept: () => cubit.respondToSwap(accept: true),
            onDecline: () => cubit.respondToSwap(accept: false),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
        ],
        if (fee.coversSession) ...[
          ToneCallout(
            tone: AppTone.info,
            icon: Icons.calendar_month_outlined,
            title: l10n.accommodationSessionCoverTitle,
            body: l10n.accommodationSessionCoverBody(
              state.terms.first.label,
              state.terms.last.label,
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
        ],
        BedDocketCard(
          bed: bed,
          statusLabel: l10n.accommodationStatusHeld,
          tone: AppTone.warning,
          eyebrow: l10n.accommodationPortalLock,
          banner: ToneCallout(
            tone: AppTone.warning,
            icon: Icons.alarm,
            title: l10n.accommodationLeftToPay(
              AccommodationLabels.duration(
                l10n,
                state.remainingUntil(deadline),
              ),
            ),
            body: l10n.accommodationLockLapses,
          ),
          sections: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        fee.coversSession
                            ? l10n.accommodationSessionFee
                            : l10n.accommodationTotalFee,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Text(
                      amount,
                      style: AppTextStyles.tabular(
                        theme.textTheme.headlineSmall!.copyWith(
                          fontFamily: AppTextStyles.monoFontFamily,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                Text(
                  l10n.accommodationPayBy(amount, formatter.format(deadline)),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            if (grace != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: AppRadii.blockRadius,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.policy_outlined,
                      size: AppDimensions.iconDense,
                      color: theme.colorScheme.primary,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.accommodationGraceTitle,
                            style: theme.textTheme.labelLarge,
                          ),
                          AppSpacing.verticalGap(AppSpacing.xs),
                          Text(
                            l10n.accommodationGraceBody(
                              formatter.format(grace),
                            ),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: AppTextStyles.relaxedLineHeight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (reference != null)
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: AppDimensions.iconDense,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.accommodationInvoice(reference),
                      style: AppTextStyles.codeMedium,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _pay(context),
                    icon: const Icon(Icons.north_east),
                    label: Text(l10n.accommodationOpenPayments),
                  ),
                ],
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: () => _pay(context),
                  icon: const Icon(Icons.account_balance_wallet_outlined),
                  label: Text(l10n.accommodationPay(amount)),
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => _cancel(context, bed),
                  icon: const Icon(Icons.cancel_outlined),
                  label: Text(l10n.accommodationCancelBooking),
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: AppDimensions.iconSmall,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    AppSpacing.horizontalGap(AppSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.accommodationCancelWalletNote,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: AppTextStyles.relaxedLineHeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        NextStepsCard(term: term),
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
