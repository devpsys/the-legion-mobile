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
import '../widgets/discipline_body.dart';
import '../widgets/registration_tab_bar.dart';
import '../widgets/registration_task_bar.dart';

/// Discipline list: cases and sanctions (sibling of Registration; not a tab).
class DisciplinePage extends StatefulWidget {
  const DisciplinePage({super.key});

  @override
  DisciplinePageState createState() => DisciplinePageState();
}

/// State of [DisciplinePage].
class DisciplinePageState extends State<DisciplinePage> {
  @override
  void initState() {
    super.initState();
    context.read<RegistrationCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        final window = state.window;
        final sessionLabel = window == null
            ? l10n.disciplineTitle
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
            RegistrationStatus.ready => DisciplineBody(
              state: state,
              cubit: cubit,
            ),
          },
          bottomNavigationBar: RegistrationTabBar(
            selectedIndex: RegistrationDestination.registration.index,
            onDestinationSelected: (index) =>
                selectRegistrationTab(context, index),
          ),
        );
      },
    );
  }
}
