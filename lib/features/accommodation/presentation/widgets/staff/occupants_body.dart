import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/status_tag.dart';
import '../../../../../core/widgets/surface_card.dart';
import '../../bloc/staff/housing_state.dart';
import 'housing_empty_card.dart';
import 'housing_labels.dart';

/// Who lives in one hostel, or the empty state when nobody does yet.
class OccupantsBody extends StatelessWidget {
  const OccupantsBody({required this.state, required this.hostelId, super.key});

  final HousingState state;
  final String hostelId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.theme;
    final hostel = state.hostelById(hostelId);
    if (hostel == null) {
      return HousingEmptyCard(
        icon: Icons.search_off,
        title: l10n.housingHostelMissingTitle,
        body: l10n.housingHostelMissingBody,
      );
    }
    final occupants = state.occupantsOf(hostelId);
    if (occupants.isEmpty) {
      return HousingEmptyCard(
        icon: Icons.groups_outlined,
        title: l10n.housingOccupantsEmptyTitle,
        body: l10n.housingOccupantsEmptyBody(hostel.name),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.housingOccupantsCount(occupants.length),
          style: AppTextStyles.codeSmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        AppSpacing.verticalGap(AppSpacing.md),
        for (final occupant in occupants) ...[
          SurfaceCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        occupant.studentName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: AppTextStyles.semiBold,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        occupant.matricNumber,
                        style: AppTextStyles.codeSmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      AppSpacing.verticalGap(AppSpacing.xs),
                      Text(
                        l10n.housingOccupantBed(
                          occupant.roomLabel,
                          occupant.bedNumber,
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                StatusTag(
                  label: HousingLabels.allocationState(l10n, occupant.state),
                  tone: HousingLabels.allocationTone(occupant.state),
                ),
              ],
            ),
          ),
          AppSpacing.verticalGap(AppSpacing.sm),
        ],
      ],
    );
  }
}
