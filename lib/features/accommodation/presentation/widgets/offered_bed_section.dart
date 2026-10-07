import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/dates.dart';
import '../../../../core/utils/money.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../admissions/presentation/widgets/tone_callout.dart';
import '../bloc/accommodation_cubit.dart';
import '../bloc/accommodation_state.dart';
import '../models/accommodation_models.dart';
import 'accommodation_confirm_sheet.dart';
import 'accommodation_labels.dart';
import 'bed_docket_card.dart';

/// A bed offered from the waitlist: not the student's, and nothing charged,
/// until they accept. Accept raises the invoice; decline leaves the waitlist.
class OfferedBedSection extends StatelessWidget {
  const OfferedBedSection({
    required this.state,
    required this.term,
    required this.cubit,
    super.key,
  });

  final AccommodationState state;
  final TermAccommodation term;
  final AccommodationCubit cubit;

  Future<void> _decline(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await AccommodationConfirmSheet.show(
      context,
      title: l10n.accommodationDeclineTitle,
      body: l10n.accommodationDeclineBody,
      confirmLabel: l10n.accommodationDeclineConfirm,
      keepLabel: l10n.accommodationDeclineKeep,
    );
    if (confirmed) cubit.declineOffer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final bed = term.bed;
    final deadline = term.deadline;
    final fee = term.fee;
    if (bed == null || deadline == null || fee == null) {
      return const SizedBox.shrink();
    }
    final formatter = AppDateFormats.weekdayLongDateTime(l10n.localeName);
    final other = state.terms.where((entry) => entry.term != term.term);
    final otherBed = other.isNotEmpty && other.first.hasBed
        ? other.first
        : null;
    final reference = term.offerReference;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BedDocketCard(
          bed: bed,
          statusLabel: l10n.accommodationStatusOffered,
          tone: AppTone.warning,
          eyebrow: reference == null
              ? l10n.accommodationWaitlistOffer
              : l10n.accommodationOfferReference(reference),
          banner: ToneCallout(
            tone: AppTone.warning,
            icon: Icons.hourglass_top_outlined,
            title: l10n.accommodationLeftToAnswer(
              AccommodationLabels.duration(
                l10n,
                state.remainingUntil(deadline),
              ),
            ),
            body: l10n.accommodationAnswerOnce,
          ),
          sections: [
            Text(
              l10n.accommodationOfferBody(formatter.format(deadline)),
              style: theme.textTheme.bodyMedium?.copyWith(
                height: AppTextStyles.relaxedLineHeight,
              ),
            ),
            if (otherBed != null)
              ToneCallout(
                tone: AppTone.success,
                icon: Icons.verified_user_outlined,
                body: l10n.accommodationOtherTermUnaffected(otherBed.label),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                        l10n.accommodationAcceptRaises(
                          formatNaira(fee.amountMinorUnits),
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                AppSpacing.verticalGap(AppSpacing.md),
                FilledButton.icon(
                  onPressed: cubit.acceptOffer,
                  icon: const Icon(Icons.arrow_forward),
                  label: Text(l10n.accommodationAcceptBed),
                ),
                AppSpacing.verticalGap(AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => _decline(context),
                  icon: const Icon(Icons.close),
                  label: Text(l10n.accommodationDecline),
                ),
              ],
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: AppDimensions.iconDense,
                    color: theme.colorScheme.primary,
                  ),
                  AppSpacing.horizontalGap(AppSpacing.sm),
                  Text(
                    l10n.accommodationOtherOffersTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.accommodationOtherOffersRoommate,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.sm),
              Text(
                l10n.accommodationOtherOffersRetain,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: AppTextStyles.relaxedLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
