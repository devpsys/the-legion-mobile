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
import '../widgets/clash_course_sheet.dart';
import '../widgets/drop_minimum_sheet.dart';
import '../widgets/registration_body.dart';
import '../widgets/registration_tab_bar.dart';
import '../widgets/registration_task_bar.dart';

/// Course registration tab: units, courses, week, catalogue, submit.
class CourseRegistrationPage extends StatefulWidget {
  const CourseRegistrationPage({super.key});

  @override
  CourseRegistrationPageState createState() => CourseRegistrationPageState();
}

/// State of [CourseRegistrationPage].
class CourseRegistrationPageState extends State<CourseRegistrationPage> {
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
    final sheet = state.sheet;
    if (sheet == null) return;

    switch (sheet) {
      case RegistrationSheet.timetableClash:
        final offer = state.sheetCourseId == null
            ? null
            : state.catalogueById(state.sheetCourseId!);
        if (offer == null) {
          cubit.cancelSheet();
          return;
        }
        await ClashCourseSheet.show(
          context,
          course: offer,
          onConfirm: cubit.confirmAddAnyway,
          onCancel: cubit.cancelSheet,
        );
      case RegistrationSheet.dropBelowMinimum:
        final course = state.sheetCourseId == null
            ? null
            : state.registeredById(state.sheetCourseId!);
        if (course == null) {
          cubit.cancelSheet();
          return;
        }
        await DropMinimumSheet.show(
          context,
          course: course,
          nextUnits: state.registeredUnits - course.units,
          minimumUnits: state.minimumUnits,
          onConfirm: cubit.confirmDrop,
          onCancel: cubit.cancelSheet,
        );
    }
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
            ? l10n.registrationTitle
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
            RegistrationStatus.ready => RegistrationBody(
              state: state,
              cubit: cubit,
            ),
          },
          bottomNavigationBar: RegistrationTabBar(
            selectedIndex: 0,
            onDestinationSelected: (index) =>
                selectRegistrationTab(context, index),
          ),
        );
      },
    );
  }
}
