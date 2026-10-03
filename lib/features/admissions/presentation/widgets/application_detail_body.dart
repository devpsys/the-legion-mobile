import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/message_feedback.dart';
import '../../../../core/widgets/responsive_content.dart';
import '../bloc/admissions_cubit.dart';
import '../bloc/admissions_state.dart';
import '../models/application_detail_models.dart';
import 'application_checklist_card.dart';
import 'application_choices_card.dart';
import 'application_detail_header.dart';
import 'application_history_card.dart';
import 'application_submit_card.dart';
import 'application_withdraw_action.dart';
import 'referee_invite_form.dart';
import 'referees_card.dart';
import 'withdraw_application_sheet.dart';

/// The loaded record: header, checklist, choices, referees, submit, log.
///
/// A `StatefulWidget` because this screen is the one place in the portal where
/// the candidate is *changing* something — two choices, a declaration — and
/// none of it belongs in the shared cubit until it is saved. The record itself
/// stays a parameter: this widget renders one application, never edits it.
class ApplicationDetailBody extends StatefulWidget {
  const ApplicationDetailBody({
    required this.state,
    required this.detail,
    super.key,
  });

  /// The portal's state, for the catalogue and the candidate's record.
  final AdmissionsState state;

  final ApplicationDetail detail;

  @override
  ApplicationDetailBodyState createState() => ApplicationDetailBodyState();
}

/// State of [ApplicationDetailBody].
///
/// Public only because private widget classes are banned — the state itself
/// carries no behaviour a caller could use.
class ApplicationDetailBodyState extends State<ApplicationDetailBody> {
  /// The choices as the candidate is leaving them: local until saved, because
  /// a dropdown that writes to the record on every tap makes a half-thought
  /// about a second choice a fact on the reference.
  String? _firstChoiceId;
  String? _secondChoiceId;

  bool _isDeclarationAccepted = false;

  /// Owned here rather than on the page so the checklist's "Invite" action can
  /// bring the candidate to the form without anyone else knowing where it is.
  final GlobalKey<RefereeInviteFormState> _inviteFormKey =
      GlobalKey<RefereeInviteFormState>();

  @override
  void initState() {
    super.initState();
    _firstChoiceId = widget.detail.firstChoiceProgrammeId;
    _secondChoiceId = widget.detail.secondChoiceProgrammeId;
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final detail = widget.detail;
    // Closed programmes are on the record but not on the menu: a candidate
    // cannot choose a programme that stopped taking applications, while the
    // catalogue still lists it so the reason is readable elsewhere.
    final openProgrammes = state.programmes
        .where((programme) => !programme.isClosed)
        .toList();

    return SingleChildScrollView(
      child: ResponsiveContent(
        maxWidth: AppDimensions.maxContentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSpacing.verticalGap(AppSpacing.lg),
            ApplicationDetailHeader(
              application: detail.application,
              submitBy: _submitBy(),
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            ApplicationChecklistCard(
              detail: detail,
              // The gate, not the banner: the overview's copy can be dismissed
              // for the session, and a candidate who hides a nag there must
              // not lose the only way to answer it here.
              showResendAction: state.candidate?.isEmailConfirmed == false,
              isResending: state.isSendingEmailLink,
              onResend: _resendConfirmation,
              onAction: _handleChecklistAction,
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            ApplicationChoicesCard(
              options: openProgrammes,
              firstChoiceId: _firstChoiceId,
              secondChoiceId: _secondChoiceId,
              onFirstChoiceChanged: (id) => setState(() => _firstChoiceId = id),
              onSecondChoiceChanged: (id) =>
                  setState(() => _secondChoiceId = id),
              // Nothing writes to the record yet, so saving says so rather
              // than moving a choice nobody received.
              onSave: _notLiveYet,
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            RefereesCard(
              referees: detail.referees,
              formKey: _inviteFormKey,
              onResend: (_) => _notLiveYet(),
              onRemove: (_) => _notLiveYet(),
              onSendInvitation: _notLiveYet,
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            ApplicationSubmitCard(
              detail: detail,
              isDeclarationAccepted: _isDeclarationAccepted,
              onDeclarationChanged: (value) =>
                  setState(() => _isDeclarationAccepted = value),
              onSubmit: _notLiveYet,
            ),
            AppSpacing.verticalGap(AppSpacing.lg),
            ApplicationHistoryCard(events: detail.history),
            AppSpacing.verticalGap(AppSpacing.lg),
            ApplicationWithdrawAction(onWithdraw: _confirmWithdraw),
            AppSpacing.verticalGap(AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  /// The moment this application stops being submittable: the earlier of the
  /// cycle's own close and the first choice's deadline.
  ///
  /// The *filed* choice rather than the one on screen — the record is what the
  /// countdown is about, and a deadline that moves while a candidate is
  /// hovering a dropdown reads as an instruction rather than a fact. Returns
  /// `null` when neither is known, so the header quotes no date instead of a
  /// guess.
  DateTime? _submitBy() {
    final cycle = widget.state.cycleById(widget.detail.cycleId);
    final firstChoice = applicationChoiceById(
      widget.state.programmes,
      widget.detail.firstChoiceProgrammeId,
    );
    final deadlines = <DateTime>[
      if (cycle != null) cycle.closesOn,
      if (firstChoice != null) firstChoice.closesOn,
    ];
    if (deadlines.isEmpty) return null;
    return deadlines.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  void _handleChecklistAction(ChecklistAction action) {
    switch (action) {
      case ChecklistAction.resendEmail:
        _resendConfirmation();
      case ChecklistAction.inviteReferee:
        _bringIntoView(_inviteFormKey);
      // Everything with no screen behind it yet reports that, so a tap never
      // lands in silence.
      case ChecklistAction.none:
        _notLiveYet();
      case ChecklistAction.completePersonalDetails:
        _notLiveYet();
      case ChecklistAction.claimJamb:
        _notLiveYet();
      case ChecklistAction.uploadDocument:
        _notLiveYet();
      case ChecklistAction.checkPayment:
        _notLiveYet();
    }
  }

  /// The one action on this screen with a service behind it: the banner's own
  /// cubit action, reused so the portal sends the same link from anywhere.
  void _resendConfirmation() {
    final l10n = context.l10n;
    context.read<AdmissionsCubit>().resendEmailLink();
    context.showMessage(l10n.admissionsConfirmEmailSent);
  }

  void _bringIntoView(GlobalKey<RefereeInviteFormState> key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  /// The only action here that asks first: it is the one that cannot be undone.
  void _confirmWithdraw() {
    final l10n = context.l10n;
    WithdrawApplicationSheet.show(
      context,
      onConfirm: () => context.showMessage(l10n.commonComingSoon),
    );
  }

  void _notLiveYet() {
    final l10n = context.l10n;
    context.showMessage(l10n.commonComingSoon);
  }
}
