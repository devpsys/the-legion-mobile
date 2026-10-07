import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/accommodation_cubit.dart';
import '../bloc/accommodation_state.dart';
import '../widgets/accommodation_notice_listener.dart';
import '../widgets/accommodation_rooms_body.dart';
import '../widgets/accommodation_task_bar.dart';

/// The rooms a student can book, as a screen of its own.
class AccommodationRoomsPage extends StatefulWidget {
  const AccommodationRoomsPage({super.key});

  @override
  AccommodationRoomsPageState createState() => AccommodationRoomsPageState();
}

/// State of [AccommodationRoomsPage].
class AccommodationRoomsPageState extends State<AccommodationRoomsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AccommodationCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AccommodationNoticeListener(
      onNotice: (context, notice) {
        if (notice == AccommodationNotice.bedHeld) {
          context.goNamed(Routes.accommodationName);
        }
      },
      child: BlocBuilder<AccommodationCubit, AccommodationState>(
        builder: (context, state) {
          final cubit = context.read<AccommodationCubit>();
          final termLabel = state.current?.label ?? state.sessionLabel;

          return Scaffold(
            backgroundColor: AppColors.canvas(context.colors.brightness),
            appBar: AccommodationBackBar(
              title: l10n.accommodationRoomsPageTitle,
              subtitle: l10n.accommodationSubtitle(termLabel),
              onBack: () => context.goNamed(Routes.accommodationName),
            ),
            body: switch (state.status) {
              AccommodationStatus.initial ||
              AccommodationStatus.loading => const LoadingView(),
              AccommodationStatus.failure => ErrorView(
                message: state.failureMessage ?? l10n.errorsServer,
                onRetry: cubit.load,
              ),
              AccommodationStatus.ready => AccommodationRoomsBody(
                state: state,
                cubit: cubit,
              ),
            },
          );
        },
      ),
    );
  }
}
