import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../../../../core/widgets/state_views.dart';
import '../bloc/admissions_cubit.dart';
import '../bloc/admissions_state.dart';
import 'announcements_section.dart';
import 'applicant_strip.dart';
import 'applications_section.dart';
import 'email_confirmation_banner.dart';
import 'jamb_claim_card.dart';

/// The loaded body of the candidate overview: identity, the confirmation gate,
/// applications, the pending JAMB claim, and the announcement board.
///
/// Split from the page so the page itself only decides *which* state to show
/// while this decides what the ready state contains.
class OverviewBody extends StatelessWidget {
  const OverviewBody({required this.state, required this.now, super.key});

  final AdmissionsState state;

  /// Injected so the greeting and the open-cycle count are deterministic.
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AdmissionsCubit>();
    final candidate = state.candidate;

    // The record always carries a candidate once ready; guard anyway, because a
    // half-built state should not crash the portal's entry screen.
    if (candidate == null) {
      return EmptyView(message: context.l10n.errorsServer);
    }

    final l10n = context.l10n;

    return SingleChildScrollView(
      child: ResponsiveContent(
        maxWidth: AppDimensions.maxContentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSpacing.verticalGap(AppSpacing.lg),
            ApplicantStrip(candidate: candidate, now: now),
            if (state.needsEmailConfirmation) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              EmailConfirmationBanner(
                email: candidate.email,
                isSending: state.isSendingEmailLink,
                hasSent: state.hasSentEmailLink,
                onResend: cubit.resendEmailLink,
                onDismiss: cubit.dismissEmailBanner,
              ),
            ],
            AppSpacing.verticalGap(AppSpacing.md),
            ApplicationsSection(
              applications: state.applications,
              openCycleCount: state.openCyclesAt(now).length,
              onApply: () => context.showMessage(l10n.commonComingSoon),
              // Real, unlike Apply: the browser exists, and an empty list whose
              // only exit says "coming soon" strands the candidate.
              onBrowse: () => context.goNamed(Routes.admissionsProgrammesName),
            ),
            if (state.jambResultPending) ...[
              AppSpacing.verticalGap(AppSpacing.md),
              JambClaimCard(
                onClaim: () => context.goNamed(Routes.admissionsJambName),
              ),
            ],
            AppSpacing.verticalGap(AppSpacing.md),
            AnnouncementsSection(
              bulletins: state.bulletins,
              onSeeAll: () => context.showMessage(l10n.commonComingSoon),
              onBulletinTap: (_) => context.showMessage(l10n.commonComingSoon),
            ),
            AppSpacing.verticalGap(AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
