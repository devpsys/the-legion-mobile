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
import '../../../models/staff/approvals_models.dart';
import '../../../widgets/staff/approvals/request_decision_body.dart';
import '../../../widgets/staff/approvals/staff_reject_sheet.dart';
import '../../../widgets/staff/staff_chrome.dart';

/// HoD queue of student petitions: approve, or reject with a reason.
class StudentRequestsDecisionPage extends StatefulWidget {
  const StudentRequestsDecisionPage({super.key});

  @override
  StudentRequestsDecisionPageState createState() =>
      StudentRequestsDecisionPageState();
}

/// State of [StudentRequestsDecisionPage].
class StudentRequestsDecisionPageState
    extends State<StudentRequestsDecisionPage> {
  @override
  void initState() {
    super.initState();
    context.read<StaffApprovalsCubit>().load();
  }

  void _approve(RequestDecisionItem item) {
    final cubit = context.read<StaffApprovalsCubit>();
    if (cubit.approveRequest(item.id)) {
      context.showMessage(
        context.l10n.staffApprovalsRequestApprovedMessage(item.studentName),
      );
    } else {
      context.showErrorMessage(context.l10n.errorsServer);
    }
  }

  void _reject(RequestDecisionItem item) {
    final cubit = context.read<StaffApprovalsCubit>();
    if (!cubit.requestRejectRequest(item.id)) {
      context.showErrorMessage(context.l10n.staffApprovalsReasonRequired);
    }
  }

  Future<void> _presentSheet(StaffApprovalsState state) async {
    if (state.sheet != StaffApprovalsSheet.rejectRequest) return;
    final cubit = context.read<StaffApprovalsCubit>();
    RequestDecisionItem? item;
    for (final request in state.requests) {
      if (request.id == state.sheetId) {
        item = request;
        break;
      }
    }
    if (item == null) {
      cubit.cancelSheet();
      return;
    }

    final l10n = context.l10n;
    final studentName = item.studentName;
    await StaffRejectSheet.show(
      context,
      title: l10n.staffApprovalsRejectRequestTitle,
      body: l10n.staffApprovalsRejectRequestBody(studentName),
      confirmLabel: l10n.staffApprovalsRejectRequestConfirm,
      quote: item.rejectDraft,
      onConfirm: () {
        final confirmed = cubit.confirmRejectRequest();
        if (!mounted) return;
        if (confirmed) {
          context.showMessage(
            l10n.staffApprovalsRequestRejectedMessage(studentName),
          );
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

        return Scaffold(
          backgroundColor: AppColors.canvas(context.theme.brightness),
          appBar: StaffRegistrationTaskBar(
            title: l10n.staffApprovalsRequestsTaskTitle,
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
            StaffApprovalsStatus.ready => RequestDecisionBody(
              state: state,
              cubit: cubit,
              onApprove: _approve,
              onReject: _reject,
            ),
          },
        );
      },
    );
  }
}
