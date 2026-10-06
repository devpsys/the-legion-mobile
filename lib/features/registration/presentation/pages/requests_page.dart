import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/registration_cubit.dart';
import '../bloc/registration_state.dart';
import '../widgets/registration_tab_bar.dart';
import '../widgets/registration_task_bar.dart';
import '../widgets/requests_body.dart';
import '../widgets/withdraw_request_sheet.dart';

/// Requests tab: academic petitions and entry to the ID card screen.
class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  RequestsPageState createState() => RequestsPageState();
}

/// State of [RequestsPage].
class RequestsPageState extends State<RequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RegistrationCubit>().load();
  }

  Future<void> _presentSheet(
    BuildContext context,
    RegistrationState state,
  ) async {
    final cubit = context.read<RegistrationCubit>();
    if (state.sheet != RegistrationSheet.withdrawAcademicRequest) return;

    final request = state.sheetCourseId == null
        ? null
        : state.academicRequestById(state.sheetCourseId!);
    if (request == null) {
      cubit.cancelSheet();
      return;
    }
    await WithdrawRequestSheet.show(
      context,
      title: request.title,
      onConfirm: cubit.confirmWithdrawAcademic,
      onCancel: cubit.cancelSheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.sheet != current.sheet,
      listener: (context, state) {
        if (state.sheet != null) {
          _presentSheet(context, state);
        }
      },
      builder: (context, state) {
        final window = state.window;
        final sessionLabel = window == null
            ? l10n.requestsTitle
            : l10n.registrationSessionLine(window.session, window.termLabel);
        final cubit = context.read<RegistrationCubit>();

        return Scaffold(
          backgroundColor: AppColors.canvas(context.colors.brightness),
          appBar: RegistrationTaskBar(
            sessionLabel: sessionLabel,
            user: context.select((AuthCubit cubit) => cubit.state.user),
            onAvatarTap: () => context.goNamed(Routes.profileName),
            onNotifications: () => showNotificationsSheet(context),
          ),
          body: switch (state.status) {
            RegistrationStatus.initial ||
            RegistrationStatus.loading => const LoadingView(),
            RegistrationStatus.failure => EmptyView(
              message: l10n.errorsServer,
              icon: Icons.cloud_off_outlined,
            ),
            RegistrationStatus.ready => RequestsBody(
              state: state,
              cubit: cubit,
            ),
          },
          bottomNavigationBar: RegistrationTabBar(
            selectedIndex: RegistrationDestination.requests.index,
            onDestinationSelected: (index) =>
                selectRegistrationTab(context, index),
          ),
        );
      },
    );
  }
}
