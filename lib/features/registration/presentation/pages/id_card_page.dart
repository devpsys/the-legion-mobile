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
import '../widgets/cancel_id_card_sheet.dart';
import '../widgets/id_card_body.dart';
import '../widgets/registration_tab_bar.dart';
import '../widgets/registration_task_bar.dart';

/// Student ID card request screen — sibling of Requests (tab stays selected).
class IdCardPage extends StatefulWidget {
  const IdCardPage({super.key});

  @override
  IdCardPageState createState() => IdCardPageState();
}

/// State of [IdCardPage].
class IdCardPageState extends State<IdCardPage> {
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
    if (state.sheet != RegistrationSheet.cancelIdCardRequest) return;

    final serial = state.idCard?.activeRequest?.serial;
    if (serial == null) {
      cubit.cancelSheet();
      return;
    }
    await CancelIdCardSheet.show(
      context,
      serial: serial,
      onConfirm: cubit.confirmCancelIdCard,
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
            ? l10n.idCardTitle
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
            RegistrationStatus.ready => IdCardBody(
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
