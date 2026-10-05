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
import '../widgets/study_plan_body.dart';

/// Study plan tab: degree progress, adviser note, term-by-term plan.
class StudyPlanPage extends StatefulWidget {
  const StudyPlanPage({super.key});

  @override
  StudyPlanPageState createState() => StudyPlanPageState();
}

/// State of [StudyPlanPage].
class StudyPlanPageState extends State<StudyPlanPage> {
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
            ? l10n.studyPlanTitle
            : l10n.registrationSessionLine(window.session, window.termLabel);

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
            RegistrationStatus.ready => StudyPlanBody(state: state),
          },
          bottomNavigationBar: RegistrationTabBar(
            selectedIndex: 1,
            onDestinationSelected: (index) =>
                selectRegistrationTab(context, index),
          ),
        );
      },
    );
  }
}
