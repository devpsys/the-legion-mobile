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
import '../widgets/application_detail_body.dart';
import '../widgets/application_detail_top_bar.dart';

/// One application, opened from the record.
///
/// A stack step rather than a fifth tab: it has its own bar with a back
/// chevron and no tab bar, because a candidate reading a checklist is not
/// moving between sections — they are reading one file.
class ApplicationDetailPage extends StatefulWidget {
  const ApplicationDetailPage({
    required this.applicationId,
    this.now,
    super.key,
  });

  /// The record's id as it appears in the path, e.g. `app-00057`.
  final String applicationId;

  /// Injected so the open-cycle reading is deterministic.
  final DateTime? now;

  @override
  ApplicationDetailPageState createState() => ApplicationDetailPageState();
}

/// State of [ApplicationDetailPage].
///
/// Public because private widget classes are banned, and because loading the
/// portal on entry is a behaviour a test should be able to name.
class ApplicationDetailPageState extends State<ApplicationDetailPage> {
  @override
  void initState() {
    super.initState();
    // Idempotent, like the other portal pages: a deep link into the record may
    // be the first thing this session renders, and a record that has not been
    // read yet has nothing to show.
    context.read<AdmissionsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<AdmissionsCubit, AdmissionsState>(
      builder: (context, state) {
        final detail = state.detailFor(widget.applicationId);

        return Scaffold(
          backgroundColor: AppColors.canvas(context.colors.brightness),
          appBar: ApplicationDetailTopBar(
            // `null` while the record loads, in which case the bar shows the
            // screen's name alone rather than a blank space.
            reference: detail?.application.trackingCode,
            onBack: () => context.goNamed(Routes.admissionsApplicationsName),
            user: context.select((AuthCubit cubit) => cubit.state.user),
            onNotifications: () => showNotificationsSheet(context),
            onAvatarTap: () => context.goNamed(Routes.profileName),
          ),
          body: SafeArea(
            top: false,
            child: switch (state.status) {
              AdmissionsStatus.initial ||
              AdmissionsStatus.loading => const LoadingView(),
              AdmissionsStatus.failure => EmptyView(
                message: l10n.errorsServer,
                icon: Icons.cloud_off_outlined,
              ),
              // An id the record does not carry — a stale link, or a record
              // whose detail has not been ported — is answered with the
              // record's own sentence rather than a blank screen.
              AdmissionsStatus.ready =>
                detail == null
                    ? EmptyView(message: l10n.admissionsDetailNotFound)
                    : ApplicationDetailBody(
                        state: state,
                        detail: detail,
                        now: widget.now,
                      ),
            },
          ),
        );
      },
    );
  }
}
