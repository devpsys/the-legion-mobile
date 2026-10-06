import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/loading_view.dart';
import '../../../../../../core/widgets/state_views.dart';
import '../../../bloc/staff/staff_approvals_cubit.dart';
import '../../../bloc/staff/staff_approvals_state.dart';
import '../../../mock/staff/approvals_fixtures.dart';
import '../../../widgets/staff/approvals/approvals_queue_body.dart';
import '../../../widgets/staff/staff_chrome.dart';

/// HoD queue of course forms waiting for registration approval.
class RegistrationApprovalsPage extends StatefulWidget {
  const RegistrationApprovalsPage({super.key});

  @override
  RegistrationApprovalsPageState createState() =>
      RegistrationApprovalsPageState();
}

/// State of [RegistrationApprovalsPage].
class RegistrationApprovalsPageState extends State<RegistrationApprovalsPage> {
  @override
  void initState() {
    super.initState();
    context.read<StaffApprovalsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<StaffApprovalsCubit, StaffApprovalsState>(
      builder: (context, state) {
        final cubit = context.read<StaffApprovalsCubit>();

        return Scaffold(
          backgroundColor: AppColors.canvas(context.theme.brightness),
          appBar: StaffRegistrationTaskBar(
            title: l10n.staffApprovalsTaskTitle,
            subtitle: l10n.registrationSessionLine(
              ApprovalsFixtures.session,
              ApprovalsFixtures.termLabel,
            ),
            onBack: () => context.goNamed(Routes.homeName),
          ),
          body: switch (state.status) {
            StaffApprovalsStatus.initial ||
            StaffApprovalsStatus.loading => const LoadingView(),
            StaffApprovalsStatus.failure => ErrorView(
              message: state.failureMessage ?? l10n.errorsServer,
              onRetry: cubit.load,
            ),
            StaffApprovalsStatus.ready => ApprovalsQueueBody(
              state: state,
              cubit: cubit,
            ),
          },
        );
      },
    );
  }
}
