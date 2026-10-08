import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/l10n/gen/app_localizations.dart';
import '../../../../../core/widgets/message_feedback.dart';
import '../../bloc/staff/exam_office_cubit.dart';
import '../../bloc/staff/exam_office_state.dart';

/// Tells the officer the outcome of what they just did, once, then clears it.
class ExamOfficeNoticeListener extends StatelessWidget {
  const ExamOfficeNoticeListener({required this.child, super.key});

  final Widget child;

  /// `true` for the notices that report a refusal rather than a success.
  static bool isRefusal(ExamOfficeNotice notice) {
    return switch (notice) {
      ExamOfficeNotice.sendBlocked ||
      ExamOfficeNotice.cardReasonRequired ||
      ExamOfficeNotice.cancelLocked ||
      ExamOfficeNotice.cancelReasonRequired ||
      ExamOfficeNotice.thresholdsInvalid ||
      ExamOfficeNotice.releaseLocked => true,
      _ => false,
    };
  }

  /// The sentence that reports [notice].
  static String message(AppLocalizations l10n, ExamOfficeNotice notice) {
    return switch (notice) {
      ExamOfficeNotice.sentForApproval => l10n.examOfficeNoticeSent,
      ExamOfficeNotice.sendBlocked => l10n.examOfficeNoticeSendBlocked,
      ExamOfficeNotice.markHeld => l10n.examOfficeNoticeHeld,
      ExamOfficeNotice.holdReleased => l10n.examOfficeNoticeReleased,
      ExamOfficeNotice.sessionOpened => l10n.examOfficeNoticeSessionOpened,
      ExamOfficeNotice.cardWithdrawn => l10n.examOfficeNoticeCardWithdrawn,
      ExamOfficeNotice.cardReasonRequired =>
        l10n.examOfficeNoticeCardReasonRequired,
      ExamOfficeNotice.roomAdded => l10n.examOfficeNoticeRoomAdded,
      ExamOfficeNotice.paperUpdated => l10n.examOfficeNoticePaperUpdated,
      ExamOfficeNotice.cancelLocked => l10n.examOfficeNoticeCancelLocked,
      ExamOfficeNotice.cancelReasonRequired =>
        l10n.examOfficeNoticeCancelReasonRequired,
      ExamOfficeNotice.thresholdsSaved => l10n.examOfficeNoticeThresholdsSaved,
      ExamOfficeNotice.thresholdsInvalid =>
        l10n.examOfficeNoticeThresholdsInvalid,
      ExamOfficeNotice.importDone => l10n.examOfficeNoticeImported,
      ExamOfficeNotice.incidentClosed => l10n.examOfficeNoticeIncidentClosed,
      ExamOfficeNotice.incidentReferred =>
        l10n.examOfficeNoticeIncidentReferred,
      ExamOfficeNotice.releaseLocked => l10n.examOfficeNoticeReleaseLocked,
      ExamOfficeNotice.windowOpened => l10n.examOfficeNoticeWindowOpened,
      ExamOfficeNotice.registrationCancelled =>
        l10n.examOfficeNoticeRegistrationCancelled,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamOfficeCubit, ExamOfficeState>(
      listenWhen: (previous, current) =>
          previous.notice != current.notice && current.notice != null,
      listener: (context, state) {
        final notice = state.notice;
        if (notice == null) return;
        final text = message(context.l10n, notice);
        if (isRefusal(notice)) {
          context.showErrorMessage(text);
        } else {
          context.showMessage(text);
        }
        context.read<ExamOfficeCubit>().clearNotice();
      },
      child: child,
    );
  }
}
