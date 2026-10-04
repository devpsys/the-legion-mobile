/// View models of the candidate admissions portal.
///
/// These describe what the screens render, not what an API returns: the
/// admissions endpoints are still pending and the feature is fed from
/// `presentation/mock/`. When they land, replace these with domain entities
/// and delete the mock file.
///
/// Models carry no `Color` and no localized string — tone and status map to
/// presentation, copy to the ARB.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/durations.dart';
import 'programme_models.dart';

/// Lifecycle of an application, as the candidate sees it.
///
/// The enum values are the API's; the *labels* are what a person reads, and
/// they differ from the values in two places the README calls out: an `offered`
/// application reads "Admission offered", and an `expired` offer is amber, not
/// red, because the candidate did nothing wrong.
enum ApplicationStatus {
  draft,
  submitted,
  underReview,
  offered,
  accepted,
  declined,
  rejected,
  withdrawn,
  expired,
  matriculated,
}

/// Semantic tone of an [ApplicationStatus].
extension ApplicationStatusTone on ApplicationStatus {
  AppTone get tone => switch (this) {
    ApplicationStatus.draft => AppTone.neutral,
    ApplicationStatus.submitted => AppTone.info,
    ApplicationStatus.underReview => AppTone.info,
    ApplicationStatus.offered => AppTone.warning,
    ApplicationStatus.accepted => AppTone.success,
    ApplicationStatus.matriculated => AppTone.success,
    ApplicationStatus.declined => AppTone.danger,
    ApplicationStatus.rejected => AppTone.danger,
    ApplicationStatus.withdrawn => AppTone.danger,
    // Amber: the deadline passed, not the candidate's doing.
    ApplicationStatus.expired => AppTone.warning,
  };

  /// `true` while the application can still be acted on.
  bool get isOpen =>
      this == ApplicationStatus.draft || this == ApplicationStatus.submitted;

  /// `true` while the application holds a claim on a place: being assembled,
  /// awaiting a decision, or carrying an offer the candidate has not let go
  /// of. This is what stops a second application in the same category — a
  /// refusal, a withdrawal, a lapse and a declined offer have all released
  /// the cycle, and a matriculation has finished with it.
  bool get isActive => switch (this) {
    ApplicationStatus.draft ||
    ApplicationStatus.submitted ||
    ApplicationStatus.underReview ||
    ApplicationStatus.offered ||
    ApplicationStatus.accepted => true,
    ApplicationStatus.declined ||
    ApplicationStatus.rejected ||
    ApplicationStatus.withdrawn ||
    ApplicationStatus.expired ||
    ApplicationStatus.matriculated => false,
  };
}

/// One application in the candidate's list.
///
/// Two screens read it. The overview prints a compact summary of the row; the
/// Applications tab draws the full card the `admissions_my_applications`
/// design gives it — reference, cycle, choices, and whatever the status means
/// for what happens next — which is why the record carries dates and numbers
/// the compact card never shows.
class ApplicationSummary extends Equatable {
  const ApplicationSummary({
    required this.id,
    required this.programmeName,
    required this.department,
    required this.category,
    required this.status,
    required this.submittedOn,
    required this.cycleName,
    required this.cycleSession,
    required this.updatedOn,
    this.trackingCode,
    this.secondChoiceName,
    this.respondBy,
    this.matricNumber,
    this.cycleClosedOn,
  });

  final String id;

  /// e.g. `B.Sc. Computer Science`.
  final String programmeName;

  final String department;

  /// The category of the programme applied to. Carried on the application
  /// rather than looked up: the rule of one live application per category
  /// has to hold for a record whose programme is no longer in the catalogue.
  final ProgrammeCategory category;

  final ApplicationStatus status;
  final DateTime submittedOn;

  /// The cycle it was filed in, e.g. `2026/2027 Undergraduate Admissions`.
  ///
  /// Carried rather than looked up: an applicant's history spans cycles that
  /// are no longer open, and `cycles` only lists what the portal can still
  /// quote a deadline and a fee for.
  final String cycleName;

  /// The academic session of that cycle, e.g. `2026/2027`: the short form a
  /// chip prints where [cycleName] would wrap.
  final String cycleSession;

  /// When the application last changed — the date the card's footer prints.
  final DateTime updatedOn;

  /// Short reference printed on correspondence, e.g. `APP/2026/00042`.
  final String? trackingCode;

  /// The programme the candidate named as a second choice, when the cycle
  /// records one.
  final String? secondChoiceName;

  /// The deadline on an outstanding offer: the candidate answers before it or
  /// the offer lapses. `null` once the offer is off the table, and for every
  /// status that never carried one.
  final DateTime? respondBy;

  /// Set only once the candidate has matriculated; the card then prints the
  /// number and links to the student portal instead of offering a tap-through
  /// to an application that is finished.
  final String? matricNumber;

  /// When the cycle behind a terminal decision closed, printed *below* the
  /// card. A rejection with no reason attached reads as a verdict on the
  /// candidate; the cycle closing is a fact about the calendar.
  final DateTime? cycleClosedOn;

  @override
  List<Object?> get props => [
    id,
    programmeName,
    department,
    category,
    status,
    submittedOn,
    cycleName,
    cycleSession,
    updatedOn,
    trackingCode,
    secondChoiceName,
    respondBy,
    matricNumber,
    cycleClosedOn,
  ];
}

/// Editorial weight of a bulletin on the candidate board.
enum BulletinCategory {
  /// A deadline or requirement change.
  information,

  /// Something completed, usually in the university's favour.
  success,

  /// An action the candidate must take.
  warning,
}

/// Semantic tone of a [BulletinCategory].
extension BulletinCategoryTone on BulletinCategory {
  AppTone get tone => switch (this) {
    BulletinCategory.information => AppTone.info,
    BulletinCategory.success => AppTone.success,
    BulletinCategory.warning => AppTone.warning,
  };
}

/// A bulletin on the candidate's announcement board.
class Bulletin extends Equatable {
  const Bulletin({
    required this.id,
    required this.category,
    required this.publishedLabel,
    required this.title,
    required this.body,
  });

  final String id;
  final BulletinCategory category;

  /// Relative timestamp, e.g. `2 days ago`.
  final String publishedLabel;

  final String title;
  final String body;

  @override
  List<Object?> get props => [id, category, publishedLabel, title, body];
}

/// An admissions cycle the candidate can apply to.
class AdmissionCycle extends Equatable {
  const AdmissionCycle({
    required this.id,
    required this.name,
    required this.label,
    required this.session,
    required this.opensOn,
    required this.closesOn,
    required this.formFeeMinorUnits,
  });

  final String id;

  /// Full name of the cycle, e.g. `2026/2027 Undergraduate Admissions`.
  ///
  /// Separate from [label] because the two are drawn in very different rooms:
  /// the notice on Programmes has a whole line for it, while the app bar chip
  /// is capped at 180px and has to ellipsize.
  final String name;

  /// Compact name for the app bar chip, e.g. `2026/2027 Cycle`.
  final String label;

  /// The academic session admitted to, e.g. `2026/2027` — what an
  /// application's [ApplicationSummary.cycleSession] is compared against when
  /// the portal asks whether the candidate has already applied this session.
  final String session;

  final DateTime opensOn;
  final DateTime closesOn;

  /// The cycle's application form fee, in kobo. See `core/utils/money.dart`.
  final int formFeeMinorUnits;

  /// `true` while [now] is inside the window. A closed cycle is still shown —
  /// hiding it would tell a candidate the programme does not exist.
  bool isOpenAt(DateTime now) =>
      !now.isBefore(opensOn) && now.isBefore(closesOn);

  /// Days until the cycle closes; never negative.
  int daysUntilClose(DateTime now) => daysUntil(now, closesOn);

  @override
  List<Object?> get props => [
    id,
    name,
    label,
    session,
    opensOn,
    closesOn,
    formFeeMinorUnits,
  ];
}

/// What the candidate portal needs to know about the person signed in.
///
/// Deliberately narrower than `User`: a candidate's identity is an email that
/// may not be confirmed yet, which is what gates the whole module.
class CandidateProfile extends Equatable {
  const CandidateProfile({
    required this.displayName,
    required this.email,
    required this.isEmailConfirmed,
  });

  final String displayName;
  final String email;

  /// Unconfirmed email blocks applying and claiming a JAMB result.
  final bool isEmailConfirmed;

  /// First name, for the greeting.
  String get firstName {
    final words = displayName.split(RegExp(r'\s+'));
    return words.isEmpty ? displayName : words.first;
  }

  @override
  List<Object?> get props => [displayName, email, isEmailConfirmed];
}
