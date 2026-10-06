import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/utils/responsive.dart';
import '../../../../../../core/widgets/responsive_content.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../bloc/staff/registry_cubit.dart';
import '../../../bloc/staff/registry_state.dart';
import '../../../models/staff/registry_models.dart';
import '../../../widgets/registration_card.dart';
import '../../../widgets/registration_chrome.dart';
import '../staff_chrome.dart';
import '../staff_entry_card.dart';
import '../staff_filter_chips.dart';
import '../staff_labels.dart';
import 'registry_search_field.dart';
import 'registry_stats_strip.dart';
import 'registry_student_tile.dart';

/// Scrollable body of the registry students directory.
class StudentsDirectoryBody extends StatelessWidget {
  const StudentsDirectoryBody({
    required this.state,
    required this.cubit,
    super.key,
  });

  final RegistryState state;
  final RegistryCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final visible = state.visibleStudents;

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
                  l10n.staffRegistryStudentsBreadcrumb,
                ],
                title: l10n.staffRegistryStudentsTitle,
                subtitle: l10n.staffRegistryStudentsSubtitle,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistryStatsStrip(stats: state.stats),
              AppSpacing.verticalGap(AppSpacing.md),
              StaffEntryCard(
                icon: Icons.badge_outlined,
                title: l10n.staffRegistryIdCardsEntryTitle,
                body: l10n.staffRegistryIdCardsEntryBody(state.requestedCount),
                onOpen: () => context.goNamed(Routes.staffIdCardsName),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrySearchField(
                initialQuery: state.query,
                onChanged: cubit.setQuery,
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              StaffFilterChips<RegistryDirectoryStatus?>(
                values: [null, ...RegistryDirectoryStatus.values],
                selected: state.statusFilter,
                labelOf: (status) => status == null
                    ? l10n.staffRegistryFilterAll
                    : StaffRegistrationLabels.directoryStatus(l10n, status),
                onSelected: cubit.setStatusFilter,
              ),
              if (state.selectedCount > 0) ...[
                AppSpacing.verticalGap(AppSpacing.md),
                RegistrationCard(
                  clip: false,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.staffRegistrySelectedCount(state.selectedCount),
                          style: AppTextStyles.codeSmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: cubit.requestBatchPromote,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(
                            0,
                            AppDimensions.buttonCompact,
                          ),
                        ),
                        icon: const Icon(
                          Icons.trending_up,
                          size: AppDimensions.iconSmall,
                        ),
                        label: Text(l10n.staffRegistryPromoteAction),
                      ),
                    ],
                  ),
                ),
              ],
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(
                title: l10n.staffRegistryStudentsListTitle,
                countLabel: l10n.staffRegistryStudentsCount(visible.length),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (visible.isEmpty)
                ToneCallout(
                  tone: AppTone.info,
                  icon: Icons.search_off_outlined,
                  title: l10n.staffRegistryStudentsEmptyTitle,
                  body: l10n.staffRegistryStudentsEmptyBody,
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
                        RegistryStudentTile(
                          student: visible[i],
                          onToggle: () => cubit.toggleSelected(visible[i].id),
                          onOpen: () => context.goNamed(
                            Routes.staffStudentRecordName,
                            pathParameters: {
                              Routes.staffRegistrationStudentIdParam:
                                  visible[i].id,
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
