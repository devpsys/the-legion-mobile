import '../../../../core/l10n/gen/app_localizations.dart';
import '../models/registration_models.dart';

/// Localised labels for registration enums.
///
/// Kept next to the screens so status vocabulary stays in one place — the
/// README's "Awaiting approval" / "Clash accepted" wording lives here.
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
}
