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
import '../bloc/examinations_cubit.dart';
import '../bloc/examinations_state.dart';
import 'examinations_notice_listener.dart';
import 'examinations_preview_menu.dart';
import 'examinations_tab_bar.dart';
import 'examinations_task_bar.dart';

/// The frame every student examinations tab shares: task bar, loading and
/// failure states, the debug preview button and the tab bar.
///
/// Asks the cubit to load once; the body is built from the loaded state.
class ExaminationsPageFrame extends StatefulWidget {
  const ExaminationsPageFrame({
    required this.destination,
    required this.builder,
    super.key,
  });

  final ExaminationsDestination destination;
  final Widget Function(BuildContext context, ExaminationsState state) builder;

  @override
  ExaminationsPageFrameState createState() => ExaminationsPageFrameState();
}

/// State of [ExaminationsPageFrame].
class ExaminationsPageFrameState extends State<ExaminationsPageFrame> {
  @override
  void initState() {
    super.initState();
    context.read<ExaminationsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ExaminationsNoticeListener(
      child: BlocBuilder<ExaminationsCubit, ExaminationsState>(
        builder: (context, state) {
          final cubit = context.read<ExaminationsCubit>();

          return Scaffold(
            backgroundColor: AppColors.canvas(context.colors.brightness),
            appBar: ExaminationsTaskBar(
              sessionLabel: state.sessionLabel.isEmpty
                  ? l10n.examTitle
                  : state.sessionLabel,
              user: context.select((AuthCubit cubit) => cubit.state.user),
              onAvatarTap: () => context.goNamed(Routes.profileName),
              onNotifications: () => showNotificationsSheet(context),
            ),
            body: switch (state.status) {
              ExaminationsStatus.initial ||
              ExaminationsStatus.loading => const LoadingView(),
              ExaminationsStatus.failure => ErrorView(
                message: state.failureMessage ?? l10n.errorsServer,
                onRetry: cubit.load,
              ),
              ExaminationsStatus.ready => widget.builder(context, state),
            },
            floatingActionButton: const ExaminationsPreviewFab(),
            bottomNavigationBar: ExaminationsTabBar(
              selectedIndex: widget.destination.index,
              onDestinationSelected: (index) =>
                  selectExaminationsTab(context, index),
            ),
          );
        },
      ),
    );
  }
}
