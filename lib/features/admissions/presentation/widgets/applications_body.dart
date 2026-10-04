import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/admissions_state.dart';
import 'application_list_card.dart';
import 'applications_empty_state.dart';
import 'applications_header.dart';

/// The loaded body of the Applications tab: the record, or the reason there
/// is none.
///
/// Split from the page so the page decides only *which* state to show while
/// this decides what the ready state contains — the same division the
/// overview and the browser use.
class ApplicationsBody extends StatelessWidget {
  const ApplicationsBody({required this.state, required this.now, super.key});

  final AdmissionsState state;

  /// Injected so the footer's age stamp is deterministic.
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final applications = state.applications;

    return SingleChildScrollView(
      child: ResponsiveContent(
        maxWidth: AppDimensions.maxContentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSpacing.verticalGap(AppSpacing.lg),
            const ApplicationsHeader(),
            AppSpacing.verticalGap(AppSpacing.lg),
            if (applications.isEmpty)
              ApplicationsEmptyState(
                openCycleCount: state.openCyclesAt(now).length,
                onBrowse: () =>
                    context.goNamed(Routes.admissionsProgrammesName),
              )
            else
              for (final application in applications)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ApplicationListCard(
                    application: application,
                    now: now,
                    // Only a record with a detail screen behind it opens
                    // one: a status with no design yet keeps the honest
                    // message, so no card leads somewhere it could not fill.
                    onOpen: state.detailFor(application.id) != null
                        ? () => context.goNamed(
                            Routes.admissionsApplicationDetailName,
                            pathParameters: {'id': application.id},
                          )
                        : () => context.showMessage(l10n.commonComingSoon),
                    onOpenPortal: () => context.goNamed(Routes.homeName),
                  ),
                ),
            AppSpacing.verticalGap(AppSpacing.xl),
            // Room for the floating action. At the end of a long record the
            // FAB rests on the last card, and on a matriculated one that card's
            // footer is the button out to the student portal: 44 + 24 clears
            // the button's own height and the margin the Scaffold gives it.
            AppSpacing.verticalGap(AppDimensions.buttonHeight + AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
