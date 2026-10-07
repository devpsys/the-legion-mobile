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
import '../bloc/accommodation_cubit.dart';
import '../bloc/accommodation_state.dart';
import '../widgets/accommodation_body.dart';
import '../widgets/accommodation_notice_listener.dart';
import '../widgets/accommodation_preview_menu.dart';
import '../widgets/accommodation_tab_bar.dart';
import '../widgets/accommodation_task_bar.dart';

/// Accommodation hub: the term selector and the selected term's bed.
class AccommodationPage extends StatefulWidget {
  const AccommodationPage({super.key});

  @override
  AccommodationPageState createState() => AccommodationPageState();
}

/// State of [AccommodationPage].
class AccommodationPageState extends State<AccommodationPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccommodationCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AccommodationNoticeListener(
      child: BlocBuilder<AccommodationCubit, AccommodationState>(
        builder: (context, state) {
          final cubit = context.read<AccommodationCubit>();
          final label = state.current?.label ?? state.sessionLabel;

          return Scaffold(
            backgroundColor: AppColors.canvas(context.colors.brightness),
            appBar: AccommodationTaskBar(
              termLabel: label.isEmpty ? l10n.accommodationTitle : label,
              user: context.select((AuthCubit cubit) => cubit.state.user),
              onAvatarTap: () => context.goNamed(Routes.profileName),
              onNotifications: () => showNotificationsSheet(context),
            ),
            body: switch (state.status) {
              AccommodationStatus.initial ||
              AccommodationStatus.loading => const LoadingView(),
              AccommodationStatus.failure => ErrorView(
                message: state.failureMessage ?? l10n.errorsServer,
                onRetry: cubit.load,
              ),
              AccommodationStatus.ready => AccommodationBody(
                state: state,
                cubit: cubit,
              ),
            },
            floatingActionButton: const AccommodationPreviewFab(),
            bottomNavigationBar: AccommodationTabBar(
              selectedIndex: AccommodationDestination.accommodation.index,
              onDestinationSelected: (index) =>
                  selectAccommodationTab(context, index),
            ),
          );
        },
      ),
    );
  }
}
