import '../../../../../core/l10n/gen/app_localizations.dart';
import '../../../../../core/theme/app_tone.dart';
import '../../models/registration_models.dart';
import '../../models/staff/approvals_models.dart';
import '../../models/staff/registry_models.dart';

/// Localised labels and tones for the staff Registration & Records enums.
///
/// Student-facing vocabulary (course status, ID card status, request type)
/// stays in `RegistrationLabels`; this holds only what staff screens add.
abstract final class StaffRegistrationLabels {
  static String approvalsFilter(
    AppLocalizations l10n,
    ApprovalsQueueFilter filter,
  ) {
    return switch (filter) {
      ApprovalsQueueFilter.awaiting => l10n.staffApprovalsFilterAwaiting,
      ApprovalsQueueFilter.approved => l10n.staffApprovalsFilterApproved,
      ApprovalsQueueFilter.all => l10n.staffApprovalsFilterAll,
    };
  }

  static String requestFilter(
    AppLocalizations l10n,
    RequestDecisionFilter filter,
  ) {
    return switch (filter) {
      RequestDecisionFilter.all => l10n.staffApprovalsRequestFilterAll,
      RequestDecisionFilter.pending => l10n.staffApprovalsRequestFilterPending,
      RequestDecisionFilter.decided => l10n.staffApprovalsRequestFilterDecided,
    };
  }

  static String directoryStatus(
    AppLocalizations l10n,
    RegistryDirectoryStatus status,
  ) {
    return switch (status) {
      RegistryDirectoryStatus.active => l10n.staffRegistryStatusActive,
      RegistryDirectoryStatus.suspended => l10n.staffRegistryStatusSuspended,
      RegistryDirectoryStatus.withdrawn => l10n.staffRegistryStatusWithdrawn,
      RegistryDirectoryStatus.expelled => l10n.staffRegistryStatusExpelled,
      RegistryDirectoryStatus.graduated => l10n.staffRegistryStatusGraduated,
    };
  }

  static String idCardTab(
    AppLocalizations l10n,
    IdCardQueueTab tab,
    int count,
  ) {
    return switch (tab) {
      IdCardQueueTab.requested => l10n.staffRegistryTabRequested(count),
      IdCardQueueTab.readyForCollection =>
        l10n.staffRegistryTabReadyForCollection(count),
      IdCardQueueTab.collected => l10n.staffRegistryTabCollected(count),
    };
  }

  static String feePayment(AppLocalizations l10n, IdCardFeePayment payment) {
    return switch (payment) {
      IdCardFeePayment.notRequired => l10n.staffRegistryFeeNotRequired,
      IdCardFeePayment.unpaid => l10n.staffRegistryFeeUnpaid,
      IdCardFeePayment.paid => l10n.staffRegistryFeePaid,
    };
  }

  static AppTone feePaymentTone(IdCardFeePayment payment) {
    return switch (payment) {
      IdCardFeePayment.notRequired => AppTone.neutral,
      IdCardFeePayment.unpaid => AppTone.warning,
      IdCardFeePayment.paid => AppTone.success,
    };
  }

  static AppTone standingTone(StudentStanding standing) {
    return switch (standing) {
      StudentStanding.active => AppTone.success,
      StudentStanding.suspended => AppTone.warning,
      StudentStanding.expelled => AppTone.danger,
    };
  }
}
