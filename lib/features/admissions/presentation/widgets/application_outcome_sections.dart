import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../bloc/admissions_state.dart';
import '../models/admissions_models.dart';
import '../models/application_detail_models.dart';
import 'application_attestation_card.dart';
import 'application_choices_card.dart';
import 'application_faq_card.dart';
import 'application_history_card.dart';
import 'application_next_cycle_card.dart';
import 'application_rejection_audit_card.dart';
import 'application_rejection_notice_card.dart';
import 'closed_state_cards.dart';
import 'matriculated_card.dart';
import 'offer_card.dart';
import 'rejected_card.dart';

/// Everything an application shows once it is no longer a draft.
///
/// A draft is a form and keeps its own state; every other status is a record
/// with something to say about how it stands, so it is drawn from the record
/// alone and nothing here is edited. Each status gets the sections its design
/// gives it: an offer is one card with its two answers, a refusal is the
/// committee's decision from headline to way forward, and the endings that
/// carry no decision — a lapsed offer, a withdrawal, a matriculation — are one
/// card and the history behind it.
///
/// A status with no design yet (submitted, under review, accepted, declined)
/// shows the history and nothing invented: the record is the only part of those
/// screens that exists.
class ApplicationOutcomeSections extends StatelessWidget {
  const ApplicationOutcomeSections({
    required this.detail,
    required this.state,
    required this.now,
    super.key,
  });

  final ApplicationDetail detail;

  /// The portal, for the catalogue and the candidate the record belongs to.
  final AdmissionsState state;

  /// Injected so "is a cycle open?" reads the same clock as the rest of the
  /// screen rather than the device's.
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final sections = _sections(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, section) in sections.indexed) ...[
          if (index > 0) AppSpacing.verticalGap(AppSpacing.lg),
          section,
        ],
      ],
    );
  }

  List<Widget> _sections(BuildContext context) {
    final application = detail.application;
    final history = ApplicationHistoryCard(events: detail.history);
    final programme = applicationChoiceById(
      state.programmes,
      detail.firstChoiceProgrammeId,
    );

    switch (application.status) {
      case ApplicationStatus.offered:
        final offer = detail.offer;
        if (offer == null) return [history];
        return [
          ApplicationOfferCard(
            detail: detail,
            offer: offer,
            programme: programme,
            onReadLetter: () => _openLetter(context, application.id),
            onAccept: () => _notLiveYet(context),
            onDecline: () => _notLiveYet(context),
          ),
        ];
      case ApplicationStatus.rejected:
        final notice = detail.rejection;
        // A refusal with no written decision falls back to the short form.
        if (notice == null) {
          return [
            ApplicationRejectedClosedCard(
              detail: detail,
              onBrowse: () => _browseProgrammes(context),
            ),
            history,
          ];
        }
        final openCycle = state.openCyclesAt(now).firstOrNull;
        return [
          ApplicationDecisionStrip(cycleSession: application.cycleSession),
          ApplicationRejectedBanner(
            application: application,
            notice: notice,
            programme: programme,
            applicantName: state.candidate?.displayName,
          ),
          ApplicationRejectionNoticeCard(
            cycleName: application.cycleName,
            notice: notice,
          ),
          ApplicationRejectionAuditCard(criteria: notice.criteria),
          ApplicationAttestationCard(
            verificationHash: notice.verificationHash,
            cycleName: application.cycleName,
          ),
          // Only while there is a cycle to apply to: the card's whole claim is
          // that the door is open.
          if (openCycle != null)
            ApplicationNextCycleCard(
              cycleLabel: openCycle.label,
              onStartNew: () => _browseProgrammes(context),
              onDownloadNotice: () => _notLiveYet(context),
            ),
          ApplicationFaqCard(
            faqs: notice.faqs,
            onReturn: () => context.goNamed(Routes.admissionsApplicationsName),
            onHelpDesk: () => _notLiveYet(context),
          ),
        ];
      case ApplicationStatus.matriculated:
        final matricNumber = application.matricNumber;
        return [
          if (matricNumber != null)
            ApplicationMatriculatedCard(
              matricNumber: matricNumber,
              // The student portal is the hub the candidate came from.
              onOpenPortal: () => context.goNamed(Routes.homeName),
              // The letter screen is where the document is read and saved
              // from, so "download" opens it rather than fetching a file
              // blind.
              onDownloadLetter: () => _openLetter(context, application.id),
            ),
          history,
        ];
      case ApplicationStatus.expired:
        return [
          ApplicationExpiredCard(
            detail: detail,
            onBrowse: () => _browseProgrammes(context),
          ),
          history,
        ];
      case ApplicationStatus.withdrawn:
        return [
          ApplicationWithdrawnCard(
            detail: detail,
            onStartNew: () => _browseProgrammes(context),
          ),
          history,
        ];
      case ApplicationStatus.draft ||
          ApplicationStatus.submitted ||
          ApplicationStatus.underReview ||
          ApplicationStatus.accepted ||
          ApplicationStatus.declined:
        return [history];
    }
  }

  /// Starting an application is choosing a programme, so both "start a new
  /// application" and "browse programmes" lead to the browser.
  void _browseProgrammes(BuildContext context) =>
      context.goNamed(Routes.admissionsProgrammesName);

  /// The admission letter for this record — the offer reads it before
  /// answering, the matriculated student comes back for a copy.
  void _openLetter(BuildContext context, String applicationId) =>
      context.goNamed(
        Routes.admissionsAdmissionLetterName,
        pathParameters: {'id': applicationId},
      );

  /// Everything with no service behind it yet reports that, so a tap never
  /// lands in silence.
  void _notLiveYet(BuildContext context) =>
      context.showMessage(context.l10n.commonComingSoon);
}
