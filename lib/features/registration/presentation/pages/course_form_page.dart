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
import '../widgets/course_form_body.dart';
import '../widgets/registration_tab_bar.dart';
import '../widgets/registration_task_bar.dart';

/// Course form tab: the official registry document once submitted.
class CourseFormPage extends StatefulWidget {
  const CourseFormPage({super.key});

  @override
  CourseFormPageState createState() => CourseFormPageState();
}

/// State of [CourseFormPage].
class CourseFormPageState extends State<CourseFormPage> {
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
            ? l10n.navCourseForm
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
            RegistrationStatus.ready => CourseFormBody(state: state),
          },
          bottomNavigationBar: RegistrationTabBar(
            selectedIndex: 2,
            onDestinationSelected: (index) =>
                selectRegistrationTab(context, index),
          ),
        );
      },
    );
  }
}
