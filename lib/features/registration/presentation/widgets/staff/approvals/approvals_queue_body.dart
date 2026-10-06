import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/theme/app_tone.dart';
import '../../../../../../core/widgets/responsive_content.dart';
import '../../../../../admissions/presentation/widgets/tone_callout.dart';
import '../../../bloc/staff/staff_approvals_cubit.dart';
import '../../../bloc/staff/staff_approvals_state.dart';
import '../../../models/staff/approvals_models.dart';
import '../../../widgets/registration_card.dart';
import '../../../widgets/registration_chrome.dart';
import '../staff_chrome.dart';
import '../staff_entry_card.dart';
import '../staff_filter_chips.dart';
import '../staff_labels.dart';
import 'approval_queue_card.dart';

/// Scrollable body of the HoD registration-approvals queue.
class ApprovalsQueueBody extends StatelessWidget {
  const ApprovalsQueueBody({
    required this.state,
    required this.cubit,
    super.key,
  });

  final StaffApprovalsState state;
  final StaffApprovalsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final visible = state.visibleQueue;
    final hasAwaiting = state.awaitingFormCount > 0;

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
                  l10n.staffApprovalsBreadcrumbRoot,
                  l10n.staffApprovalsBreadcrumb,
                ],
                title: l10n.staffApprovalsTitle,
                subtitle: l10n.staffApprovalsSubtitle,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              ToneCallout(
                tone: hasAwaiting ? AppTone.warning : AppTone.success,
                icon: hasAwaiting
                    ? Icons.pending_actions_outlined
                    : Icons.task_alt_outlined,
                title: l10n.staffApprovalsSummaryTitle(state.awaitingFormCount),
                body: l10n.staffApprovalsSummaryBody(
                  state.awaitingCourseCount,
                ),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              StaffEntryCard(
                icon: Icons.forum_outlined,
                title: l10n.staffApprovalsRequestsEntryTitle,
                body: l10n.staffApprovalsRequestsEntryBody,
                onOpen: () => context.goNamed(Routes.staffStudentRequestsName),
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              StaffFilterChips<ApprovalsQueueFilter>(
                values: ApprovalsQueueFilter.values,
                selected: state.queueFilter,
                labelOf: (filter) =>
                    StaffRegistrationLabels.approvalsFilter(l10n, filter),
                onSelected: cubit.setQueueFilter,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(
                title: l10n.staffApprovalsQueueTitle,
                countLabel: l10n.staffApprovalsQueueCount(visible.length),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (visible.isEmpty)
                ToneCallout(
                  tone: AppTone.info,
                  icon: Icons.inbox_outlined,
                  title: l10n.staffApprovalsEmptyTitle,
                  body: l10n.staffApprovalsEmptyBody,
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
                        ApprovalQueueCard(
                          item: visible[i],
                          onReview: () => context.goNamed(
                            Routes.staffRegistrationDecisionName,
                            pathParameters: {
                              Routes.staffRegistrationStudentIdParam:
                                  visible[i].studentId,
                            },
                          ),
                          onAdvise: () => context.goNamed(
                            Routes.staffStudyPlanAdvisingName,
                            pathParameters: {
                              Routes.staffRegistrationStudentIdParam:
                                  visible[i].studentId,
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationAboutCard(
                title: l10n.staffApprovalsAboutTitle,
                body: l10n.staffApprovalsAboutBody,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
