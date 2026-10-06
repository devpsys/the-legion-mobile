import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/loading_view.dart';
import '../../../../../../core/widgets/message_feedback.dart';
import '../../../../../../core/widgets/state_views.dart';
import '../../../bloc/staff/staff_approvals_cubit.dart';
import '../../../bloc/staff/staff_approvals_state.dart';
import '../../../mock/staff/approvals_fixtures.dart';
import '../../../widgets/staff/approvals/approval_action_bar.dart';
import '../../../widgets/staff/approvals/registration_decision_body.dart';
import '../../../widgets/staff/approvals/staff_reject_sheet.dart';
import '../../../widgets/staff/staff_chrome.dart';

/// HoD decision screen for one student's course form.
class StudentRegistrationDecisionPage extends StatefulWidget {
  const StudentRegistrationDecisionPage({required this.studentId, super.key});

  final String studentId;

  @override
  StudentRegistrationDecisionPageState createState() =>
      StudentRegistrationDecisionPageState();
}

/// State of [StudentRegistrationDecisionPage].
class StudentRegistrationDecisionPageState
    extends State<StudentRegistrationDecisionPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<StaffApprovalsCubit>();
    cubit
      ..load()
      ..openReview(widget.studentId);
  }

  @override
  void didUpdateWidget(StudentRegistrationDecisionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.studentId != widget.studentId) {
      context.read<StaffApprovalsCubit>().openReview(widget.studentId);
    }
  }

  void _approve(StaffApprovalsCubit cubit) {
    final count = cubit.state.review?.selectedPending.length ?? 0;
    if (cubit.approveSelected()) {
      context.showMessage(context.l10n.staffApprovalsApprovedMessage(count));
    } else {
      context.showErrorMessage(context.l10n.staffApprovalsSelectFirst);
    }
  }

  void _requestReject(StaffApprovalsCubit cubit) {
    if ((cubit.state.review?.selectedPending.length ?? 0) == 0) {
      context.showErrorMessage(context.l10n.staffApprovalsSelectFirst);
      return;
    }
    cubit.requestRejectSelected();
  }

  Future<void> _presentSheet(StaffApprovalsState state) async {
    final cubit = context.read<StaffApprovalsCubit>();
    final review = state.review;
    if (state.sheet != StaffApprovalsSheet.rejectCourses) return;
    if (review == null) {
      cubit.cancelSheet();
      return;
    }

    final l10n = context.l10n;
    final count = review.selectedPending.length;
    await StaffRejectSheet.show(
      context,
      title: l10n.staffApprovalsRejectCoursesTitle,
      body: l10n.staffApprovalsRejectCoursesBody(count, review.name),
      confirmLabel: l10n.staffApprovalsRejectCoursesConfirm,
      reasonLabel: l10n.staffApprovalsRejectReasonLabel,
      reasonHint: l10n.staffApprovalsRejectReasonHint,
      initialReason: review.rejectDraft,
      onReasonChanged: cubit.setRejectDraft,
      onConfirm: () {
        final confirmed = cubit.confirmRejectSelected();
        if (!mounted) return;
        if (confirmed) {
          context.showMessage(l10n.staffApprovalsRejectedMessage(count));
        } else {
          context.showErrorMessage(l10n.staffApprovalsReasonRequired);
        }
      },
      onDismissed: () {
        if (cubit.state.sheet != null) cubit.cancelSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<StaffApprovalsCubit, StaffApprovalsState>(
      listenWhen: (previous, current) =>
          previous.sheet != current.sheet && current.sheet != null,
      listener: (context, state) => _presentSheet(state),
      builder: (context, state) {
        final cubit = context.read<StaffApprovalsCubit>();
        final review = state.review;
        final actionReview =
            review != null && !review.directDepartment && review.pendingCount > 0
            ? review
            : null;

        return Scaffold(
          backgroundColor: AppColors.canvas(context.theme.brightness),
          appBar: StaffRegistrationTaskBar(
            title: l10n.staffApprovalsDecisionTaskTitle,
            subtitle: l10n.registrationSessionLine(
              ApprovalsFixtures.session,
              ApprovalsFixtures.termLabel,
            ),
            onBack: () => context.goNamed(Routes.staffRegistrationApprovalsName),
          ),
          body: switch (state.status) {
            StaffApprovalsStatus.initial ||
            StaffApprovalsStatus.loading => const LoadingView(),
            StaffApprovalsStatus.failure => ErrorView(
              message: state.failureMessage ?? l10n.errorsServer,
              onRetry: cubit.load,
            ),
            StaffApprovalsStatus.ready =>
              review == null
                  ? const LoadingView()
                  : RegistrationDecisionBody(review: review, cubit: cubit),
          },
          bottomNavigationBar: actionReview == null
              ? null
              : ApprovalActionBar(
                  selectedCount: actionReview.selectedPending.length,
                  onSelectAll: cubit.selectAllPending,
                  onApprove: () => _approve(cubit),
                  onReject: () => _requestReject(cubit),
                ),
        );
      },
    );
  }
}
