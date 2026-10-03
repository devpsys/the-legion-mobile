import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/admissions_cubit.dart';
import '../bloc/admissions_state.dart';
import '../widgets/admissions_tab_bar.dart';
import '../widgets/admissions_task_bar.dart';
import '../widgets/overview_body.dart';

/// The candidate's admissions overview: who they are, what is blocking them,
/// and what the university has told them.
///
/// Composition only. Content comes from `presentation/mock/` because the
/// admissions endpoints are pending, so every tap here either routes to a
/// screen that exists or says it is not live yet.
class AdmissionsOverviewPage extends StatefulWidget {
  const AdmissionsOverviewPage({this.now, super.key});

  /// Injected so the greeting and the open-cycle count are deterministic.
  final DateTime? now;

  @override
  AdmissionsOverviewPageState createState() => AdmissionsOverviewPageState();
}

class AdmissionsOverviewPageState extends State<AdmissionsOverviewPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdmissionsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // The system back gesture returns to the hub rather than leaving the app:
    // the portal was pushed on top of it, and `context.pop()` would be a no-op
    // when the portal was reached by a deep link.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        context.goNamed(Routes.homeName);
      },
      child: BlocBuilder<AdmissionsCubit, AdmissionsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.canvas(context.colors.brightness),
            appBar: AdmissionsTaskBar(
              cycleLabel: state.cycleLabelFor(l10n.admissionsTitle),
              onBack: () => context.goNamed(Routes.homeName),
              onNotifications: () => showNotificationsSheet(context),
            ),
            body: switch (state.status) {
              AdmissionsStatus.initial ||
              AdmissionsStatus.loading => const LoadingView(),
              AdmissionsStatus.failure => EmptyView(message: l10n.errorsServer),
              AdmissionsStatus.ready => OverviewBody(
                state: state,
                now: widget.now ?? DateTime.now(),
              ),
            },
            bottomNavigationBar: AdmissionsTabBar(
              selectedIndex: 0,
              jambBadge: state.jambResultPending,
              onDestinationSelected: (index) =>
                  selectAdmissionsTab(context, index),
            ),
          );
        },
      ),
    );
  }
}
