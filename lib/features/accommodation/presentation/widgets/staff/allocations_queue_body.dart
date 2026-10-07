import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../registration/presentation/widgets/staff/staff_filter_chips.dart';
import '../../bloc/staff/housing_cubit.dart';
import '../../bloc/staff/housing_state.dart';
import '../../models/staff/housing_models.dart';
import 'allocation_tile.dart';
import 'housing_empty_card.dart';
import 'housing_entry_card.dart';
import 'housing_labels.dart';
import 'housing_section.dart';

/// The allocations queue: the tools the office reaches for, then every
/// allocation under a state filter.
class AllocationsQueueBody extends StatelessWidget {
  const AllocationsQueueBody({required this.state, super.key});

  final HousingState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final records = state.visibleAllocations;

    final tools = <({IconData icon, String title, String body, String route})>[
      (
        icon: Icons.apartment_outlined,
        title: l10n.housingToolHostelsTitle,
        body: l10n.housingToolHostelsBody,
        route: Routes.staffHostelsName,
      ),
      (
        icon: Icons.event_available_outlined,
        title: l10n.housingToolOpeningsTitle,
        body: l10n.housingToolOpeningsBody,
        route: Routes.staffOpeningsName,
      ),
      (
        icon: Icons.upload_file_outlined,
        title: l10n.housingToolUploadTitle,
        body: l10n.housingToolUploadBody,
        route: Routes.staffUploadName,
      ),
      (
        icon: Icons.person_add_alt_outlined,
        title: l10n.housingToolAllocateTitle,
        body: l10n.housingToolAllocateBody,
        route: Routes.staffAllocateName,
      ),
      (
        icon: Icons.auto_fix_high_outlined,
        title: l10n.housingToolAutoTitle,
        body: l10n.housingToolAutoBody(state.waitlistCount),
        route: Routes.staffAutoAllocationName,
      ),
      (
        icon: Icons.casino_outlined,
        title: l10n.housingToolDrawTitle,
        body: l10n.housingToolDrawBody(state.drawApplicants),
        route: Routes.staffDrawName,
      ),
      (
        icon: Icons.key_outlined,
        title: l10n.housingToolKeepTitle,
        body: l10n.housingToolKeepBody(state.keepEligible),
        route: Routes.staffKeepMyRoomName,
      ),
      (
        icon: Icons.gavel_outlined,
        title: l10n.housingToolAgreementTitle,
        body: l10n.housingToolAgreementBody,
        route: Routes.staffAgreementName,
      ),
      (
        icon: Icons.campaign_outlined,
        title: l10n.housingToolNoticesTitle,
        body: l10n.housingToolNoticesBody,
        route: Routes.staffNoticesName,
      ),
      (
        icon: Icons.category_outlined,
        title: l10n.housingToolCategoriesTitle,
        body: l10n.housingToolCategoriesBody,
        route: Routes.staffCategoriesName,
      ),
      (
        icon: Icons.block_outlined,
        title: l10n.housingToolBansTitle,
        body: l10n.housingToolBansBody(state.bans.length),
        route: Routes.staffBansName,
      ),
      (
        icon: Icons.payments_outlined,
        title: l10n.housingToolRefundsTitle,
        body: l10n.housingToolRefundsBody(state.refundPolicy.sharePercent),
        route: Routes.staffRefundsName,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HousingSection(
          title: l10n.housingQueueSummaryTitle,
          children: [
            HousingMetricRow(
              metrics: [
                HousingMetric(
                  value: '${state.allocations.length}',
                  caption: l10n.housingMetricAllocations,
                ),
                HousingMetric(
                  value: '${state.freeBedTotal}',
                  caption: l10n.housingMetricFreeBeds,
                ),
                HousingMetric(
                  value: '${state.waitlistCount}',
                  caption: l10n.housingMetricWaitlist,
                ),
              ],
            ),
          ],
        ),
        AppSpacing.verticalGap(AppSpacing.xl),
        Text(l10n.housingToolsTitle, style: theme.textTheme.titleMedium),
        AppSpacing.verticalGap(AppSpacing.md),
        for (final tool in tools) ...[
          HousingEntryCard(
            icon: tool.icon,
            title: tool.title,
            body: tool.body,
            onOpen: () => context.goNamed(tool.route),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
        AppSpacing.verticalGap(AppSpacing.lg),
        Text(l10n.housingQueueTitle, style: theme.textTheme.titleMedium),
        AppSpacing.verticalGap(AppSpacing.md),
        StaffFilterChips<AllocationQueueFilter>(
          values: AllocationQueueFilter.values,
          selected: state.filter,
          labelOf: (filter) => HousingLabels.filter(l10n, filter),
          onSelected: context.read<HousingCubit>().setFilter,
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        if (records.isEmpty)
          HousingEmptyCard(
            icon: Icons.inbox_outlined,
            title: l10n.housingQueueEmptyTitle,
            body: l10n.housingQueueEmptyBody,
          )
        else
          for (final record in records) ...[
            AllocationTile(record: record),
            AppSpacing.verticalGap(AppSpacing.md),
          ],
      ],
    );
  }
}
