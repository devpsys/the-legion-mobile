import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/registration_cubit.dart';
import '../bloc/registration_state.dart';
import '../widgets/discipline_case_body.dart';
import '../widgets/lodge_appeal_sheet.dart';
import '../widgets/registration_tab_bar.dart';
import '../widgets/registration_task_bar.dart';

/// Detail screen for one disciplinary case (sibling of Discipline tab).
class DisciplineCasePage extends StatefulWidget {
  const DisciplineCasePage({required this.caseId, super.key});

  final String caseId;

  @override
  DisciplineCasePageState createState() => DisciplineCasePageState();
}

/// State of [DisciplineCasePage].
class DisciplineCasePageState extends State<DisciplineCasePage> {
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
    if (state.sheet != RegistrationSheet.lodgeDisciplineAppeal) return;

    final grounds = state.discipline?.appealDraft.trim() ?? '';
    if (grounds.isEmpty) {
      cubit.cancelSheet();
      return;
    }

    await LodgeAppealSheet.show(
      context,
      grounds: grounds,
      onConfirm: () {
        final lodged = cubit.confirmLodgeAppeal();
        if (lodged && context.mounted) {
          context.showMessage(context.l10n.disciplineAppealLodgedSnack);
        }
      },
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
            RegistrationStatus.ready => DisciplineCaseBody(
              state: state,
              cubit: cubit,
              caseId: widget.caseId,
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
