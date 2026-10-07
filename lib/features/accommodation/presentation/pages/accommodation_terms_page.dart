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
import '../models/accommodation_models.dart';
import '../widgets/accommodation_notice_listener.dart';
import '../widgets/accommodation_task_bar.dart';
import '../widgets/accommodation_terms_body.dart';

/// Accept the accommodation agreement before booking a room.
class AccommodationTermsPage extends StatefulWidget {
  const AccommodationTermsPage({super.key});

  @override
  AccommodationTermsPageState createState() => AccommodationTermsPageState();
}

/// State of [AccommodationTermsPage].
class AccommodationTermsPageState extends State<AccommodationTermsPage> {
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
        if (notice == AccommodationNotice.termsAccepted) {
          context.goNamed(Routes.accommodationName);
        }
      },
      child: BlocBuilder<AccommodationCubit, AccommodationState>(
        builder: (context, state) {
          final cubit = context.read<AccommodationCubit>();
          final agreement = state.agreement;
          final waiting = state.terms.any(
            (term) => term.phase == AllocationPhase.needsTerms,
          );
          final termLabel = state.current?.label ?? state.sessionLabel;

          return Scaffold(
            backgroundColor: AppColors.canvas(context.colors.brightness),
            appBar: AccommodationBackBar(
              title: l10n.accommodationTermsPageTitle,
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
              AccommodationStatus.ready =>
                agreement == null
                    ? const SizedBox.shrink()
                    : AccommodationTermsBody(
                        agreement: agreement,
                        termLabel: termLabel,
                        alreadyAccepted: !waiting,
                        onAccept: cubit.acceptTerms,
                      ),
            },
          );
        },
      ),
    );
  }
}
