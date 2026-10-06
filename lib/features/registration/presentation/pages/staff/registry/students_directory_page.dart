import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/loading_view.dart';
import '../../../../../../core/widgets/message_feedback.dart';
import '../../../../../../core/widgets/state_views.dart';
import '../../../bloc/staff/registry_cubit.dart';
import '../../../bloc/staff/registry_state.dart';
import '../../../mock/staff/registry_fixtures.dart';
import '../../../widgets/staff/registry/batch_promote_sheet.dart';
import '../../../widgets/staff/registry/students_directory_body.dart';
import '../../../widgets/staff/staff_chrome.dart';

/// Registry directory of matriculated students.
class StudentsDirectoryPage extends StatefulWidget {
  const StudentsDirectoryPage({super.key});

  @override
  StudentsDirectoryPageState createState() => StudentsDirectoryPageState();
}

/// State of [StudentsDirectoryPage].
class StudentsDirectoryPageState extends State<StudentsDirectoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<RegistryCubit>().load();
  }

  Future<void> _presentSheet(RegistryState state) async {
    if (state.sheet != RegistrySheet.batchPromote) return;
    final cubit = context.read<RegistryCubit>();
    final count = state.selectedCount;
    if (count == 0) {
      cubit.cancelSheet();
      return;
    }

    final l10n = context.l10n;
    await BatchPromoteSheet.show(
      context,
      selectedCount: count,
      initialLevel: state.promoteLevel ?? BatchPromoteSheet.levels.last,
      onLevelChanged: cubit.setPromoteLevel,
      onConfirm: () {
        final level = cubit.state.promoteLevel;
        cubit.confirmBatchPromote();
        if (!mounted || level == null) return;
        context.showMessage(l10n.staffRegistryPromotedMessage(count, level));
      },
      onDismissed: () {
        if (cubit.state.sheet != null) cubit.cancelSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<RegistryCubit, RegistryState>(
      listenWhen: (previous, current) =>
          previous.sheet != current.sheet && current.sheet != null,
      listener: (context, state) => _presentSheet(state),
      builder: (context, state) {
        final cubit = context.read<RegistryCubit>();

        return Scaffold(
          backgroundColor: AppColors.canvas(context.theme.brightness),
          appBar: StaffRegistrationTaskBar(
            title: l10n.staffRegistryStudentsTaskTitle,
            subtitle: RegistryFixtures.officerDesk,
            onBack: () => context.goNamed(Routes.homeName),
          ),
          body: switch (state.status) {
            RegistryStatus.initial ||
            RegistryStatus.loading => const LoadingView(),
            RegistryStatus.failure => ErrorView(
              message: state.failureMessage ?? l10n.errorsServer,
              onRetry: cubit.load,
            ),
            RegistryStatus.ready => StudentsDirectoryBody(
              state: state,
              cubit: cubit,
            ),
          },
        );
      },
    );
  }
}
