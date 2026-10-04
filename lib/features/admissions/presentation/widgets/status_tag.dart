import '../../../../core/l10n/gen/app_localizations.dart';
import '../models/admissions_models.dart';

// The pill itself now lives in core, where the bursary shares it; exported
// from here so the portal's widgets keep one import for the tag and its label.
export '../../../../core/widgets/status_tag.dart';

/// The localized label for an [ApplicationStatus].
///
/// The label is never derived from the enum's name: `offered` reads "Admission
/// offered", and `expired` reads "Offer expired" so the amber tone is explained
/// rather than looking like a mistake.
String applicationStatusLabel(
  AppLocalizations l10n,
  ApplicationStatus status,
) => switch (status) {
  ApplicationStatus.draft => l10n.admissionsStatusDraft,
  ApplicationStatus.submitted => l10n.admissionsStatusSubmitted,
  ApplicationStatus.underReview => l10n.admissionsStatusUnderReview,
  ApplicationStatus.offered => l10n.admissionsStatusOffered,
  ApplicationStatus.accepted => l10n.admissionsStatusAccepted,
  ApplicationStatus.declined => l10n.admissionsStatusDeclined,
  ApplicationStatus.rejected => l10n.admissionsStatusRejected,
  ApplicationStatus.withdrawn => l10n.admissionsStatusWithdrawn,
  ApplicationStatus.expired => l10n.admissionsStatusExpired,
  ApplicationStatus.matriculated => l10n.admissionsStatusMatriculated,
};
