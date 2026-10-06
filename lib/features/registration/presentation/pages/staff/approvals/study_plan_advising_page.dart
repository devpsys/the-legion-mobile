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
import '../../../widgets/staff/approvals/study_plan_advising_body.dart';
import '../../../widgets/staff/staff_chrome.dart';

/// Advising view of one student's study plan, with a note back to them.
class StudyPlanAdvisingPage extends StatefulWidget {
  const StudyPlanAdvisingPage({required this.studentId, super.key});

  final String studentId;

  @override
  StudyPlanAdvisingPageState createState() => StudyPlanAdvisingPageState();
}

/// State of [StudyPlanAdvisingPage].
class StudyPlanAdvisingPageState extends State<StudyPlanAdvisingPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<StaffApprovalsCubit>();
    cubit
      ..load()
      ..openAdvice(widget.studentId);
  }

  @override
  void didUpdateWidget(StudyPlanAdvisingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.studentId != widget.studentId) {
      context.read<StaffApprovalsCubit>().openAdvice(widget.studentId);
    }
  }

  void _save(StaffApprovalsCubit cubit) {
    final l10n = context.l10n;
    if (cubit.saveAdvice()) {
      context.showMessage(l10n.staffApprovalsAdviceSaved);
    } else {
      context.showErrorMessage(l10n.staffApprovalsAdviceRequired);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<StaffApprovalsCubit, StaffApprovalsState>(
      builder: (context, state) {
        final cubit = context.read<StaffApprovalsCubit>();
        final advice = state.advice;

        return Scaffold(
          backgroundColor: AppColors.canvas(context.theme.brightness),
          appBar: StaffRegistrationTaskBar(
            title: l10n.staffApprovalsAdvisingTaskTitle,
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
              advice == null
                  ? const LoadingView()
                  : StudyPlanAdvisingBody(
                      advice: advice,
                      onAdviceChanged: cubit.setAdviceDraft,
                      onSave: () => _save(cubit),
                    ),
          },
        );
      },
    );
  }
}
