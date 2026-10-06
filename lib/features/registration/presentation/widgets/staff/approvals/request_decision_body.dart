import 'package:flutter/material.dart';

import '../../../../../../core/extensions/context_extensions.dart';
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
import '../staff_filter_chips.dart';
import '../staff_labels.dart';
import 'request_decision_card.dart';

/// Scrollable body of the HoD student-requests decision queue.
class RequestDecisionBody extends StatelessWidget {
  const RequestDecisionBody({
    required this.state,
    required this.cubit,
    required this.onApprove,
    required this.onReject,
    super.key,
  });

  final StaffApprovalsState state;
  final StaffApprovalsCubit cubit;
  final ValueChanged<RequestDecisionItem> onApprove;
  final ValueChanged<RequestDecisionItem> onReject;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final l10n = context.l10n;
    final visible = state.visibleRequests;

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
                  l10n.staffApprovalsRequestsBreadcrumb,
                ],
                title: l10n.staffApprovalsRequestsTitle,
                subtitle: l10n.staffApprovalsRequestsSubtitle,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              StaffFilterChips<RequestDecisionFilter>(
                values: RequestDecisionFilter.values,
                selected: state.requestFilter,
                labelOf: (filter) =>
                    StaffRegistrationLabels.requestFilter(l10n, filter),
                onSelected: cubit.setRequestFilter,
              ),
              AppSpacing.verticalGap(AppSpacing.lg),
              RegistrationSectionHeader(
                title: l10n.staffApprovalsRequestsListTitle,
                countLabel: l10n.staffApprovalsRequestsCount(visible.length),
              ),
              AppSpacing.verticalGap(AppSpacing.md),
              if (visible.isEmpty)
                ToneCallout(
                  tone: AppTone.info,
                  icon: Icons.inbox_outlined,
                  title: l10n.staffApprovalsRequestsEmptyTitle,
                  body: l10n.staffApprovalsRequestsEmptyBody,
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
                        RequestDecisionCard(
                          key: ValueKey(visible[i].id),
                          item: visible[i],
                          onApprove: () => onApprove(visible[i]),
                          onReject: () => onReject(visible[i]),
                          onReasonChanged: (value) =>
                              cubit.setRequestRejectDraft(
                                visible[i].id,
                                value,
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
