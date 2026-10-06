import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/widgets/responsive_content.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../bloc/staff/registry_cubit.dart';
import '../../../bloc/staff/registry_state.dart';
import '../../../models/registration_models.dart';
import '../../../models/staff/registry_models.dart';
import '../../../widgets/registration_card.dart';
import '../../../widgets/registration_chrome.dart';
import '../staff_chrome.dart';
import '../staff_filter_chips.dart';
import '../staff_labels.dart';
import 'id_card_queue_tile.dart';

/// Scrollable body of the ID card production queue.
class IdCardProductionBody extends StatelessWidget {
  const IdCardProductionBody({
    required this.state,
    required this.cubit,
    required this.onPreview,
    required this.onMarkPrinted,
    required this.onMarkCollected,
    required this.onCancel,
    super.key,
  });

  final RegistryState state;
  final RegistryCubit cubit;
  final ValueChanged<IdCardProductionItem> onPreview;
  final ValueChanged<IdCardProductionItem> onMarkPrinted;
  final ValueChanged<IdCardProductionItem> onMarkCollected;
  final ValueChanged<IdCardProductionItem> onCancel;

  int _count(IdCardQueueTab tab) => switch (tab) {
    IdCardQueueTab.requested => state.requestedCount,
    IdCardQueueTab.readyForCollection => state.readyCount,
    IdCardQueueTab.collected => state.collectedCount,
  };

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final visible = state.visibleIdCards;

    return SingleChildScrollView(
      child: ResponsiveContent(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            0,
            AppSpacing.md,
            0,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StaffPageHeader(
                breadcrumb: [
                  l10n.staffRegistryBreadcrumbRoot,
                  l10n.staffRegistryIdCardsBreadcrumb,
                ],
                title: l10n.staffRegistryIdCardsTitle,
                subtitle: l10n.staffRegistryIdCardsSubtitle,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              StaffFilterChips<IdCardQueueTab>(
                values: IdCardQueueTab.values,
                selected: state.idCardTab,
                labelOf: (tab) =>
                    StaffRegistrationLabels.idCardTab(l10n, tab, _count(tab)),
                onSelected: cubit.setIdCardTab,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(
                title: l10n.staffRegistryIdCardsListTitle,
                countLabel: l10n.staffRegistryIdCardsCount(visible.length),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (visible.isEmpty)
                ToneCallout(
                  tone: AppTone.info,
                  icon: Icons.inbox_outlined,
                  title: l10n.staffRegistryIdCardsEmptyTitle,
                  body: l10n.staffRegistryIdCardsEmptyBody,
                )
              else
                RegistrationCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < visible.length; i++) ...[
                        if (i > 0)
                          Divider(
                            height: 1,
                            color: theme.colorScheme.outlineVariant,
                          ),
                        IdCardQueueTile(
                          item: visible[i],
                          onPreview: () => onPreview(visible[i]),
                          onMarkPrinted:
                              visible[i].status == IdCardStatus.requested
                              ? () => onMarkPrinted(visible[i])
                              : null,
                          onMarkCollected:
                              visible[i].status == IdCardStatus.printed
                              ? () => onMarkCollected(visible[i])
                              : null,
                          onCancel: visible[i].status == IdCardStatus.requested
                              ? () => onCancel(visible[i])
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationAboutCard(
                title: l10n.staffRegistryIdCardsAboutTitle,
                body: l10n.staffRegistryIdCardsAboutBody,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
