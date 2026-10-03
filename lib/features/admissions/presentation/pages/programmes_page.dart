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
import '../widgets/programmes_body.dart';

/// The programme browser: what the university teaches, and whether this
/// candidate may apply to it.
///
/// Composition only, like the overview. It shares the portal's cubit, so the
/// cycle chosen here is still chosen when the candidate goes back, and the
/// catalogue survives the round trip instead of being refetched on every tab
/// tap.
class ProgrammesPage extends StatefulWidget {
  const ProgrammesPage({this.now, super.key});

  /// Injected so the countdown and the open/closed reading are deterministic.
  final DateTime? now;

  @override
  ProgrammesPageState createState() => ProgrammesPageState();
}

class ProgrammesPageState extends State<ProgrammesPage> {
  @override
  void initState() {
    super.initState();
    // Idempotent: the overview has usually loaded the portal already, and
    // going back to it must not throw the catalogue away.
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
            AdmissionsStatus.ready => ProgrammesBody(
              state: state,
              now: widget.now ?? DateTime.now(),
            ),
          },
          bottomNavigationBar: AdmissionsTabBar(
            selectedIndex: 1,
            jambBadge: state.jambResultPending,
            onDestinationSelected: (index) =>
                selectAdmissionsTab(context, index),
          ),
        );
      },
    );
  }
}
