import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/router/route_names.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/loading_view.dart';
import '../../../../../../core/widgets/state_views.dart';
import '../../../bloc/staff/registry_cubit.dart';
import '../../../bloc/staff/registry_state.dart';
import '../../../mock/staff/registry_fixtures.dart';
import '../../../widgets/staff/registry/student_record_body.dart';
import '../../../widgets/staff/staff_chrome.dart';

/// Registry dossier of one student.
class StudentRecordPage extends StatefulWidget {
  const StudentRecordPage({required this.studentId, super.key});

  final String studentId;

  @override
  StudentRecordPageState createState() => StudentRecordPageState();
}

/// State of [StudentRecordPage].
class StudentRecordPageState extends State<StudentRecordPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<RegistryCubit>();
    cubit
      ..load()
      ..openRecord(widget.studentId);
  }

  @override
  void didUpdateWidget(StudentRecordPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.studentId != widget.studentId) {
      context.read<RegistryCubit>().openRecord(widget.studentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<RegistryCubit, RegistryState>(
      builder: (context, state) {
        final cubit = context.read<RegistryCubit>();
        final record = state.record;

        return Scaffold(
          backgroundColor: AppColors.canvas(context.theme.brightness),
          appBar: StaffRegistrationTaskBar(
            title: l10n.staffRegistryRecordTaskTitle,
            subtitle: RegistryFixtures.officerDesk,
            onBack: () => context.goNamed(Routes.staffStudentsName),
          ),
          body: switch (state.status) {
            RegistryStatus.initial ||
            RegistryStatus.loading => const LoadingView(),
            RegistryStatus.failure => ErrorView(
              message: state.failureMessage ?? l10n.errorsServer,
              onRetry: cubit.load,
            ),
            RegistryStatus.ready =>
              record == null
                  ? const LoadingView()
                  : StudentRecordBody(record: record),
          },
        );
      },
    );
  }
}
