import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/notification_bell.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/fees_cubit.dart';
import '../bloc/fees_state.dart';
import '../widgets/fees_body.dart';
import '../widgets/fees_top_bar.dart';

/// The student's fees: a tab of the student shell.
///
/// Composition only — the bar, and the body for the ledger's stage. The tab
/// bar under it belongs to the shell.
class FeesPage extends StatefulWidget {
  const FeesPage({super.key});

  @override
  FeesPageState createState() => FeesPageState();
}

/// State of [FeesPage].
///
/// Public because private widget classes are banned, and because loading the
/// ledger on entry is a behaviour a test should be able to name.
class FeesPageState extends State<FeesPage> {
  @override
  void initState() {
    super.initState();
    // Idempotent: a deep link to the checkout may have read the ledger first.
    context.read<FeesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<FeesCubit, FeesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.canvas(context.colors.brightness),
          appBar: FeesTopBar(
            onBack: () => context.goNamed(Routes.homeName),
            onNotifications: () => showNotificationsSheet(context),
          ),
          body: SafeArea(
            top: false,
            child: switch (state.status) {
              FeesStatus.initial || FeesStatus.loading => const LoadingView(),
              FeesStatus.failure => EmptyView(
                message: l10n.errorsServer,
                icon: Icons.cloud_off_outlined,
              ),
              FeesStatus.ready => FeesBody(state: state),
            },
          ),
        );
      },
    );
  }
}
