import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_empty_card.dart';
import 'housing_entry_card.dart';
import 'housing_labels.dart';

/// Every hostel with its bed count; tapping one opens its bed grid.
class HostelsBody extends StatelessWidget {
  const HostelsBody({required this.state, super.key});

  final HousingState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (state.hostels.isEmpty) {
      return HousingEmptyCard(
        icon: Icons.apartment_outlined,
        title: l10n.housingHostelsEmptyTitle,
        body: l10n.housingHostelsEmptyBody,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final hostel in state.hostels) ...[
          HousingEntryCard(
            icon: Icons.apartment_outlined,
            title: hostel.name,
            body: l10n.housingHostelSummary(
              hostel.blocks.length,
              hostel.rooms.length,
              hostel.freeBeds,
              hostel.totalBeds,
            ),
            trailing: StatusTag(
              label: HousingLabels.gender(l10n, hostel.gender),
              tone: AppTone.neutral,
            ),
            onOpen: () => context.goNamed(
              Routes.staffHostelName,
              pathParameters: {Routes.staffHostelIdParam: hostel.id},
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.md),
        ],
      ],
    );
  }
}
