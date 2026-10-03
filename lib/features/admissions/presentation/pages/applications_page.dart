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
import '../bloc/admissions_cubit.dart';
import '../bloc/admissions_state.dart';
import '../widgets/admissions_tab_bar.dart';
import '../widgets/admissions_task_bar.dart';
import '../widgets/applications_body.dart';
import '../widgets/new_application_fab.dart';

/// The Applications tab: every application on the candidate's record, and
/// what each one is waiting on.
///
/// Composition only, like the overview and the browser. It shares the portal's
/// cubit, so a cycle chosen on Programmes is still chosen here and the record
/// survives the round trip instead of being reloaded on every tab tap.
class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({this.now, super.key});

  /// Injected so the footer's age stamp is deterministic.
  final DateTime? now;

  @override
  ApplicationsPageState createState() => ApplicationsPageState();
}

class ApplicationsPageState extends State<ApplicationsPage> {
  @override
  void initState() {
    super.initState();
    // Idempotent: the overview has usually loaded the portal already, and
    // going back to it must not throw the record away.
    context.read<AdmissionsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Back is handled by `AdmissionsShell`, which sits in the root navigator.
    return BlocBuilder<AdmissionsCubit, AdmissionsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.canvas(context.colors.brightness),
          appBar: AdmissionsTaskBar(
            cycleLabel: state.cycleLabelFor(l10n.admissionsTitle),
            user: context.select((AuthCubit cubit) => cubit.state.user),
            onAvatarTap: () => context.goNamed(Routes.profileName),
            onNotifications: () => showNotificationsSheet(context),
          ),
          body: switch (state.status) {
            AdmissionsStatus.initial ||
            AdmissionsStatus.loading => const LoadingView(),
            AdmissionsStatus.failure => EmptyView(message: l10n.errorsServer),
            AdmissionsStatus.ready => ApplicationsBody(
              state: state,
              now: widget.now ?? DateTime.now(),
            ),
          },
          // Only once there is a record to add to: a floating action over the
          // loading placeholder would promise something the screen cannot yet
          // do. Applying is done by choosing a programme, so it goes to the
          // browser.
          floatingActionButton: state.status == AdmissionsStatus.ready
              ? NewApplicationFab(
                  onPressed: () =>
                      context.goNamed(Routes.admissionsProgrammesName),
                )
              : null,
          bottomNavigationBar: AdmissionsTabBar(
            // The third of the portal's four tabs, as on the overview (first)
            // and the browser (second).
            selectedIndex: 2,
            jambBadge: state.jambResultPending,
            onDestinationSelected: (index) =>
                selectAdmissionsTab(context, index),
          ),
        );
      },
    );
  }
}
