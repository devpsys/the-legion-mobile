import '../../../../../core/l10n/gen/app_localizations.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../../../../core/utils/dates.dart';
import '../../models/staff/exam_office_models.dart';

/// Words and tones for the examinations office enums, in one place so every
/// screen says "sent back" and "held back" the same way.
abstract final class ExamOfficeLabels {
  static String date(AppLocalizations l10n, DateTime value) =>
      AppDateFormats.medium(l10n.localeName).format(value);

  static String dateTime(AppLocalizations l10n, DateTime value) =>
      AppDateFormats.longDateTime(l10n.localeName).format(value);

  static String time(AppLocalizations l10n, DateTime value) =>
      AppDateFormats.time(l10n.localeName).format(value);

  static String stage(AppLocalizations l10n, ResultsStage stage) {
    return switch (stage) {
      ResultsStage.beingMarked => l10n.examOfficeStageBeingMarked,
      ResultsStage.sentBack => l10n.examOfficeStageSentBack,
      ResultsStage.withApprovers => l10n.examOfficeStageWithApprovers,
      ResultsStage.published => l10n.examOfficeStagePublished,
    };
  }

  static AppTone stageTone(ResultsStage stage) {
    return switch (stage) {
      ResultsStage.beingMarked => AppTone.info,
      ResultsStage.sentBack => AppTone.warning,
      ResultsStage.withApprovers => AppTone.neutral,
      ResultsStage.published => AppTone.success,
    };
  }

  static String markFilter(AppLocalizations l10n, MarkFilter filter) {
    return switch (filter) {
      MarkFilter.all => l10n.examOfficeFilterAll,
      MarkFilter.unmarked => l10n.examOfficeFilterUnmarked,
      MarkFilter.heldBack => l10n.examOfficeFilterHeld,
      MarkFilter.marked => l10n.examOfficeFilterMarked,
    };
  }

  static String sessionStatus(AppLocalizations l10n, SessionStatus status) {
    return switch (status) {
      SessionStatus.scheduled => l10n.examOfficeSessionScheduled,
      SessionStatus.live => l10n.examOfficeSessionLive,
      SessionStatus.closed => l10n.examOfficeSessionClosed,
    };
  }

  static AppTone sessionTone(SessionStatus status) {
    return switch (status) {
      SessionStatus.scheduled => AppTone.info,
      SessionStatus.live => AppTone.success,
      SessionStatus.closed => AppTone.neutral,
    };
  }

  static String paperStatus(AppLocalizations l10n, PaperStatus status) {
    return switch (status) {
      PaperStatus.scheduled => l10n.examOfficePaperScheduled,
      PaperStatus.inProgress => l10n.examOfficePaperInProgress,
      PaperStatus.sat => l10n.examOfficePaperSat,
      PaperStatus.cancelled => l10n.examOfficePaperCancelled,
    };
  }

  static AppTone paperTone(PaperStatus status) {
    return switch (status) {
      PaperStatus.scheduled => AppTone.info,
      PaperStatus.inProgress => AppTone.warning,
      PaperStatus.sat => AppTone.success,
      PaperStatus.cancelled => AppTone.danger,
    };
  }

  static String seating(AppLocalizations l10n, SeatingStatus status) {
    return switch (status) {
      SeatingStatus.notSeated => l10n.examOfficeSeatingNone,
      SeatingStatus.partial => l10n.examOfficeSeatingPartial,
      SeatingStatus.seated => l10n.examOfficeSeatingFull,
    };
  }

  static AppTone seatingTone(SeatingStatus status) {
    return switch (status) {
      SeatingStatus.notSeated => AppTone.danger,
      SeatingStatus.partial => AppTone.warning,
      SeatingStatus.seated => AppTone.success,
    };
  }

  static String incidentKind(AppLocalizations l10n, IncidentKind kind) {
    return switch (kind) {
      IncidentKind.malpractice => l10n.examOfficeKindMalpractice,
      IncidentKind.absence => l10n.examOfficeKindAbsence,
      IncidentKind.illness => l10n.examOfficeKindIllness,
      IncidentKind.disruption => l10n.examOfficeKindDisruption,
      IncidentKind.other => l10n.examOfficeKindOther,
    };
  }

  static String incidentStatus(AppLocalizations l10n, IncidentStatus status) {
    return switch (status) {
      IncidentStatus.reported => l10n.examOfficeIncidentReported,
      IncidentStatus.underReview => l10n.examOfficeIncidentUnderReview,
      IncidentStatus.referred => l10n.examOfficeIncidentReferredStatus,
      IncidentStatus.closed => l10n.examOfficeIncidentClosedStatus,
    };
  }

  static AppTone incidentTone(IncidentStatus status) {
    return switch (status) {
      IncidentStatus.reported => AppTone.info,
      IncidentStatus.underReview => AppTone.warning,
      IncidentStatus.referred => AppTone.danger,
      IncidentStatus.closed => AppTone.neutral,
    };
  }

  static String importAction(AppLocalizations l10n, ImportAction action) {
    return switch (action) {
      ImportAction.importIt => l10n.examOfficeImportActionImport,
      ImportAction.importUnattached => l10n.examOfficeImportActionUnattached,
      ImportAction.leave => l10n.examOfficeImportActionLeave,
    };
  }

  static AppTone importTone(ImportAction action) {
    return switch (action) {
      ImportAction.importIt => AppTone.success,
      ImportAction.importUnattached => AppTone.warning,
      ImportAction.leave => AppTone.danger,
    };
  }

  static String importReason(AppLocalizations l10n, ImportReason reason) {
    return switch (reason) {
      ImportReason.ready => l10n.examOfficeImportReasonReady,
      ImportReason.missingDescription =>
        l10n.examOfficeImportReasonMissingDescription,
      ImportReason.unknownKind => l10n.examOfficeImportReasonUnknownKind,
      ImportReason.duplicateInBatch => l10n.examOfficeImportReasonDuplicate,
      ImportReason.alreadyImported =>
        l10n.examOfficeImportReasonAlreadyImported,
      ImportReason.noMatchingPaper => l10n.examOfficeImportReasonNoPaper,
      ImportReason.noStudentNamed => l10n.examOfficeImportReasonNoStudent,
      ImportReason.studentNotFound => l10n.examOfficeImportReasonNotFound,
    };
  }

  static String verdict(AppLocalizations l10n, ScoreVerdict verdict) {
    return switch (verdict) {
      ScoreVerdict.cleared => l10n.examOfficeVerdictCleared,
      ScoreVerdict.heldBack => l10n.examOfficeVerdictHeld,
      ScoreVerdict.notAPass => l10n.examOfficeVerdictNotPass,
      ScoreVerdict.marginal => l10n.examOfficeVerdictMarginal,
    };
  }

  static AppTone verdictTone(ScoreVerdict verdict) {
    return switch (verdict) {
      ScoreVerdict.cleared => AppTone.success,
      ScoreVerdict.heldBack => AppTone.warning,
      ScoreVerdict.notAPass => AppTone.danger,
      ScoreVerdict.marginal => AppTone.info,
    };
  }
}
