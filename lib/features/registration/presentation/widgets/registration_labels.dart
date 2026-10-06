import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/utils/money.dart';
import '../models/registration_models.dart';

/// Localised labels for registration enums.
///
/// Kept next to the screens so status vocabulary stays in one place — the
/// README's "Awaiting approval" / "Clash accepted" / "Ready for collection"
/// wording lives here.
abstract final class RegistrationLabels {
  static String windowState(AppLocalizations l10n, RegistrationWindow window) {
    if (window.isPersonalOverride && window.state == WindowState.open) {
      return l10n.registrationWindowOpenForYou;
    }
    return switch (window.state) {
      WindowState.upcoming => l10n.registrationWindowUpcoming,
      WindowState.open => l10n.registrationWindowOpen,
      WindowState.addDropOnly => l10n.registrationWindowAddDropOnly,
      WindowState.closed => l10n.registrationWindowClosed,
    };
  }

  static String courseStatus(
    AppLocalizations l10n,
    CourseApprovalStatus status,
  ) {
    return switch (status) {
      CourseApprovalStatus.approved => l10n.registrationStatusApproved,
      CourseApprovalStatus.pending => l10n.registrationStatusAwaiting,
      CourseApprovalStatus.rejected => l10n.registrationStatusRejected,
      CourseApprovalStatus.dropped => l10n.registrationStatusDropped,
      CourseApprovalStatus.clashAccepted =>
        l10n.registrationStatusClashAccepted,
    };
  }

  static String formStatus(AppLocalizations l10n, CourseFormStatus status) {
    return switch (status) {
      CourseFormStatus.notSubmitted => l10n.registrationFormNotSubmitted,
      CourseFormStatus.draft => l10n.registrationFormDraft,
      CourseFormStatus.submitted => l10n.registrationFormSubmitted,
    };
  }

  static String? catalogueBlock(AppLocalizations l10n, CatalogueBlock? block) {
    return switch (block) {
      null => null,
      CatalogueBlock.timetableClash => l10n.registrationCatalogueClash,
      CatalogueBlock.full => l10n.registrationCatalogueFull,
      CatalogueBlock.missingPrerequisite =>
        l10n.registrationMissingPrerequisite,
      CatalogueBlock.notOpenYet => l10n.registrationCatalogueNotOpen,
      CatalogueBlock.outsidePlan => l10n.registrationCatalogueOutsidePlan,
    };
  }

  static String weekdayShort(AppLocalizations l10n, int weekday) {
    return switch (weekday) {
      1 => l10n.registrationWeekdayMon,
      2 => l10n.registrationWeekdayTue,
      3 => l10n.registrationWeekdayWed,
      4 => l10n.registrationWeekdayThu,
      5 => l10n.registrationWeekdayFri,
      6 => l10n.registrationWeekdaySat,
      _ => '',
    };
  }

  static String weekdayLong(AppLocalizations l10n, int weekday) {
    return switch (weekday) {
      1 => l10n.registrationWeekdayMonday,
      2 => l10n.registrationWeekdayTuesday,
      3 => l10n.registrationWeekdayWednesday,
      4 => l10n.registrationWeekdayThursday,
      5 => l10n.registrationWeekdayFriday,
      6 => l10n.registrationWeekdaySaturday,
      _ => '',
    };
  }

  static String idCardStatus(AppLocalizations l10n, IdCardStatus status) {
    return switch (status) {
      IdCardStatus.none => l10n.idCardStatusNone,
      IdCardStatus.requested => l10n.idCardStatusRequested,
      IdCardStatus.printed => l10n.idCardStatusReadyForCollection,
      IdCardStatus.collected => l10n.idCardStatusCollected,
    };
  }

  static String idCardHistoryStatus(
    AppLocalizations l10n,
    IdCardHistoryStatus status,
  ) {
    return switch (status) {
      IdCardHistoryStatus.collected => l10n.idCardStatusCollected,
      IdCardHistoryStatus.replaced => l10n.idCardStatusReplaced,
    };
  }

  static String idCardReason(AppLocalizations l10n, IdCardReason reason) {
    return switch (reason) {
      IdCardReason.firstCard => l10n.idCardReasonFirstCard,
      IdCardReason.lostOrStolen => l10n.idCardReasonLostOrStolen,
      IdCardReason.damaged => l10n.idCardReasonDamaged,
      IdCardReason.nameOrProgrammeUpdate => l10n.idCardReasonNameOrProgramme,
    };
  }

  static String academicRequestStatus(
    AppLocalizations l10n,
    AcademicRequestStatus status,
  ) {
    return switch (status) {
      AcademicRequestStatus.pending => l10n.requestsStatusPending,
      AcademicRequestStatus.rejected => l10n.requestsStatusRejected,
      AcademicRequestStatus.withdrawn => l10n.requestsStatusWithdrawn,
    };
  }

  static String academicRequestType(
    AppLocalizations l10n,
    AcademicRequestType type,
  ) {
    return switch (type) {
      AcademicRequestType.lateRegistration => l10n.requestsTypeLateRegistration,
      AcademicRequestType.addDropAfterDeadline =>
        l10n.requestsTypeAddDropAfterDeadline,
      AcademicRequestType.overload => l10n.requestsTypeOverload,
      AcademicRequestType.underload => l10n.requestsTypeUnderload,
      AcademicRequestType.waivePrerequisite => l10n.requestsTypeWaivePrerequisite,
      AcademicRequestType.changeOfProgramme => l10n.requestsTypeChangeOfProgramme,
    };
  }

  static String academicRequestTypeHint(
    AppLocalizations l10n,
    AcademicRequestType type,
  ) {
    return switch (type) {
      AcademicRequestType.lateRegistration =>
        l10n.requestsTypeHintLateRegistration,
      AcademicRequestType.addDropAfterDeadline =>
        l10n.requestsTypeHintAddDropAfterDeadline,
      AcademicRequestType.overload => l10n.requestsTypeHintOverload,
      AcademicRequestType.underload => l10n.requestsTypeHintUnderload,
      AcademicRequestType.waivePrerequisite =>
        l10n.requestsTypeHintWaivePrerequisite,
      AcademicRequestType.changeOfProgramme =>
        l10n.requestsTypeHintChangeOfProgramme,
    };
  }

  static String idCardFeeLine(AppLocalizations l10n, int feeMinorUnits) {
    return l10n.idCardReplacementFeeLine(formatNaira(feeMinorUnits));
  }

  static String studentStanding(AppLocalizations l10n, StudentStanding standing) {
    return switch (standing) {
      StudentStanding.active => l10n.disciplineStandingActive,
      StudentStanding.suspended => l10n.disciplineStandingSuspended,
      StudentStanding.expelled => l10n.disciplineStandingExpelled,
    };
  }

  static String disciplineCaseStatus(
    AppLocalizations l10n,
    DisciplineCaseStatus status,
  ) {
    return switch (status) {
      DisciplineCaseStatus.underInvestigation =>
        l10n.disciplineCaseStatusUnderInvestigation,
      DisciplineCaseStatus.hearingScheduled =>
        l10n.disciplineCaseStatusHearingScheduled,
      DisciplineCaseStatus.decided => l10n.disciplineCaseStatusDecided,
      DisciplineCaseStatus.underAppeal => l10n.disciplineCaseStatusUnderAppeal,
    };
  }

  static String disciplineSeverity(
    AppLocalizations l10n,
    DisciplineSeverity severity,
  ) {
    return switch (severity) {
      DisciplineSeverity.minor => l10n.disciplineSeverityMinor,
      DisciplineSeverity.major => l10n.disciplineSeverityMajor,
    };
  }

  static String disciplineCategory(
    AppLocalizations l10n,
    DisciplineCategory category,
  ) {
    return switch (category) {
      DisciplineCategory.examinationMisconduct =>
        l10n.disciplineCategoryExamination,
      DisciplineCategory.harassment => l10n.disciplineCategoryHarassment,
    };
  }

  static String disciplineFinding(
    AppLocalizations l10n,
    DisciplineFinding finding,
  ) {
    return switch (finding) {
      DisciplineFinding.foundLiable => l10n.disciplineFindingLiable,
      DisciplineFinding.notLiable => l10n.disciplineFindingNotLiable,
    };
  }

  static String sanctionType(AppLocalizations l10n, SanctionType type) {
    return switch (type) {
      SanctionType.warning => l10n.disciplineSanctionWarning,
      SanctionType.probation => l10n.disciplineSanctionProbation,
      SanctionType.suspension => l10n.disciplineSanctionSuspension,
      SanctionType.expulsion => l10n.disciplineSanctionExpulsion,
    };
  }

  static String sanctionLifecycle(
    AppLocalizations l10n,
    SanctionLifecycle lifecycle,
  ) {
    return switch (lifecycle) {
      SanctionLifecycle.active => l10n.disciplineSanctionActive,
      SanctionLifecycle.served => l10n.disciplineSanctionServed,
      SanctionLifecycle.lifted => l10n.disciplineSanctionLifted,
    };
  }

  static String evidenceKind(AppLocalizations l10n, EvidenceKind kind) {
    return switch (kind) {
      EvidenceKind.document => l10n.disciplineEvidenceDocument,
      EvidenceKind.writtenStatement => l10n.disciplineEvidenceStatement,
    };
  }
}
