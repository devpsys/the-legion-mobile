import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../widgets/hub_scaffold.dart';

/// The student's landing hub: who they are, what blocks them, and everything
/// else the portal exposes.
///
/// Composition only. The content comes from `presentation/mock/` because the
/// hub's endpoints are still pending, so this page reads fixtures and forwards
/// every tap either to a real route or to the "coming soon" message — no
/// datasource is reachable from here.
class HomeOverviewPage extends StatefulWidget {
  const HomeOverviewPage({this.now, super.key});

  /// Injected so the greeting and the term maths are deterministic in tests.
  final DateTime? now;

  @override
  HomeOverviewPageState createState() => HomeOverviewPageState();
}

class HomeOverviewPageState extends State<HomeOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) {
          // The router only reaches the hub for an authenticated session, so
          // this is a transient state while the session is being restored.
          return Scaffold(
            appBar: AppBar(),
            body: EmptyView(message: context.l10n.profileNotAvailable),
          );
        }

        return HubScaffold(user: user, now: widget.now ?? DateTime.now());
      },
    );
  }
}
