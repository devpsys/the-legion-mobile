import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/dates.dart';
import '../../../../../core/widgets/labelled_value_row.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../registration/presentation/widgets/staff/staff_filter_chips.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import '../../models/staff/housing_models.dart';
import 'housing_empty_card.dart';
import 'housing_labels.dart';
import 'housing_section.dart';
import 'price_row.dart';

/// The tabs of the openings screen.
enum OpeningsTab { openings, prices, refunds }

/// Openings, prices and refunds: when each term books, how, and what it costs.
class OpeningsBody extends StatefulWidget {
  const OpeningsBody({required this.state, super.key});

  final HousingState state;

  @override
  OpeningsBodyState createState() => OpeningsBodyState();
}

/// State of [OpeningsBody]: the selected tab.
class OpeningsBodyState extends State<OpeningsBody> {
  OpeningsTab _tab = OpeningsTab.openings;

  String _tabLabel(OpeningsTab tab) {
    final l10n = context.l10n;
    return switch (tab) {
      OpeningsTab.openings => l10n.housingTabOpenings,
      OpeningsTab.prices => l10n.housingTabPrices,
      OpeningsTab.refunds => l10n.housingTabRefunds,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StaffFilterChips<OpeningsTab>(
          values: OpeningsTab.values,
          selected: _tab,
          labelOf: _tabLabel,
          onSelected: (tab) => setState(() => _tab = tab),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        switch (_tab) {
          OpeningsTab.openings => OpeningsList(openings: widget.state.openings),
          OpeningsTab.prices => PricesList(prices: widget.state.prices),
          OpeningsTab.refunds => RefundSummary(
            policy: widget.state.refundPolicy,
          ),
        },
      ],
    );
  }
}

/// The booking windows, one card per term.
class OpeningsList extends StatelessWidget {
  const OpeningsList({required this.openings, super.key});

  final List<TermOpening> openings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final dates = AppDateFormats.medium(l10n.localeName);

    if (openings.isEmpty) {
      return HousingEmptyCard(
        icon: Icons.event_busy_outlined,
        title: l10n.housingOpeningsEmptyTitle,
        body: l10n.housingOpeningsEmptyBody,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final opening in openings) ...[
          HousingSection(
            title: opening.termLabel,
            description: l10n.housingOpeningWindow(
              dates.format(opening.opensOn),
              dates.format(opening.closesOn),
            ),
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: StatusTag(
                  label: HousingLabels.openingStatus(l10n, opening.status),
                  tone: HousingLabels.openingTone(opening.status),
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              Text(
                l10n.housingOpeningMethod,
                style: context.theme.textTheme.labelMedium,
              ),
              AppSpacing.verticalGap(AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final method in BookingMethod.values)
                    ChoiceChip(
                      label: Text(HousingLabels.bookingMethod(l10n, method)),
                      selected: opening.method == method,
                      onSelected: (_) => context
                          .read<HousingCubit>()
                          .setOpeningMethod(opening.termLabel, method),
                    ),
                ],
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              LabelledValueRow(
                label: l10n.housingOpeningHold,
                value: l10n.housingHours(opening.holdHours),
              ),
              LabelledValueRow(
                label: l10n.housingOpeningGrace,
                value: l10n.housingHours(opening.graceHours),
              ),
              LabelledValueRow(
                label: l10n.housingOpeningQuota,
                value: l10n.housingBeds(opening.freeQuota),
              ),
              LabelledValueRow(
                label: l10n.housingOpeningClosedDays,
                value: opening.closedDays.isEmpty
                    ? l10n.housingNone
                    : opening.closedDays.map(dates.format).join(', '),
              ),
            ],
          ),
          AppSpacing.verticalGap(AppSpacing.md),
        ],
      ],
    );
  }
}

/// The price of a bed by room type.
class PricesList extends StatelessWidget {
  const PricesList({required this.prices, super.key});

  final List<RoomPrice> prices;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingSection(
      title: l10n.housingPricesTitle,
      description: l10n.housingPricesBody,
      children: [
        for (final price in prices) ...[
          PriceRow(price: price),
          AppSpacing.verticalGap(AppSpacing.md),
        ],
      ],
    );
  }
}

/// A read-only line on the refund share, with the way to its screen.
class RefundSummary extends StatelessWidget {
  const RefundSummary({required this.policy, super.key});

  final RefundPolicy policy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return HousingSection(
      title: l10n.housingRefundsTitle,
      description: l10n.housingRefundsIntro,
      children: [
        LabelledValueRow(
          label: l10n.housingRefundShare,
          value: l10n.housingPercent(policy.sharePercent),
          isCode: true,
        ),
        LabelledValueRow(
          label: l10n.housingRefundWindow,
          value: l10n.housingDays(policy.windowDays),
          isCode: true,
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        OutlinedButton.icon(
          onPressed: () => context.goNamed(Routes.staffRefundsName),
          icon: const Icon(Icons.calculate_outlined),
          label: Text(l10n.housingRefundsOpen),
        ),
      ],
    );
  }
}
