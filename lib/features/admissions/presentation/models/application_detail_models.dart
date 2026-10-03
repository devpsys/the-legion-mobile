/// View models of the application detail screen.
///
/// Presentation only, like the rest of the admissions feature: the checklist,
/// the referees and the activity log are drawn from `presentation/mock/` until
/// the admissions endpoints exist. When they land, replace these with domain
/// entities and delete the mock file.
///
/// Models carry no `Color` and no localized string — tone maps to
/// presentation, copy to the ARB, and the fixture supplies the content that is
/// genuinely data (a referee's title, what was uploaded, what a note says).
library;

import 'package:equatable/equatable.dart';

import '../../../../core/theme/app_tone.dart';
import 'admissions_models.dart';
import 'programme_models.dart';

/// What tapping a checklist item does.
///
/// The label lives beside the row that draws it (`application_checklist_row`)
/// so an action and its wording cannot drift apart; this enum is only the
/// decision of *which* action a row offers.
enum ChecklistAction {
  /// Nothing to do: the item is complete.
  none,

  /// Emails a fresh confirmation link — the one action with a real service
  /// behind it, since `AdmissionsCubit` already models the send.
  resendEmail,

  /// Opens the personal-details form.
  completePersonalDetails,

  /// Opens the JAMB claim screen.
  claimJamb,

  /// Opens the document upload.
  uploadDocument,

  /// Brings the candidate to the invite form on this same screen.
  inviteReferee,

  /// Asks the bursary about the form fee.
  checkPayment,
}

/// One line of the readiness checklist.
///
/// Three states, not two — see the module README. The state is [RequirementState],
/// the same vocabulary the programme browser evaluates requirements with, so
/// "nobody could check this" is written once and cannot mean amber here and
/// red there. Only [RequirementState.notMet] counts against submission.
class ChecklistItem extends Equatable {
  const ChecklistItem({
    required this.id,
    required this.state,
    required this.title,
    required this.detail,
    this.action = ChecklistAction.none,
  });

  /// Stable identifier, e.g. `verified-email`.
  final String id;

  final RequirementState state;

  /// What the row is called, e.g. `Passport photograph`.
  final String title;

  /// The sentence under it — where to go, or what was recorded.
  final String detail;

  /// The trailing action; [ChecklistAction.none] on a completed row.
  final ChecklistAction action;

  @override
  List<Object?> get props => [id, state, title, detail, action];
}

/// Where a referee stands with the form they were sent.
enum RefereeStatus {
  /// Invited, no answer yet.
  awaiting,

  /// The confidential form came back.
  responded,
}

/// Semantic tone of a [RefereeStatus].
extension RefereeStatusTone on RefereeStatus {
  AppTone get tone => switch (this) {
    RefereeStatus.awaiting => AppTone.warning,
    RefereeStatus.responded => AppTone.success,
  };
}

/// One referee on an application.
class Referee extends Equatable {
  const Referee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });

  final String id;

  /// Full name as given, honorific included, e.g. `Dr Amina Yusuf`.
  final String name;

  /// Institutional address the invitation goes to.
  final String email;

  /// Appointment, printed under the name.
  final String role;

  final RefereeStatus status;

  /// First letter of the first and last word of the *person*, the same rule the
  /// avatar falls back to — so `Dr Amina Yusuf` reads `AY` on the monogram and
  /// nowhere else invents a second abbreviation. A title the record writes
  /// before the name is skipped for the same reason: `DY` would name the rank,
  /// not the referee.
  String get initials {
    final words = name
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '';
    final person =
        words.length > 1 && _titles.contains(words.first.toLowerCase())
        ? words.sublist(1)
        : words;
    if (person.length == 1) {
      final word = person.first;
      return word.substring(0, word.length > 2 ? 2 : word.length).toUpperCase();
    }
    return '${_firstLetterOf(person.first)}${_firstLetterOf(person.last)}';
  }

  /// Honorifics a record may open a name with, and that a monogram must not.
  static const Set<String> _titles = {
    'dr',
    'prof',
    'mr',
    'mrs',
    'ms',
    'miss',
    'rev',
    'hon',
    'chief',
  };

  static String _firstLetterOf(String value) =>
      value.isEmpty ? '' : value[0].toUpperCase();

  @override
  List<Object?> get props => [id, name, email, role, status];
}

/// What kind of entry an activity log line is.
///
/// Two kinds because the design draws one of them as a callout: a screening
/// note is the university talking about the file, everything else is the file
/// changing.
enum ApplicationHistoryKind {
  /// A note left by whoever is screening the application.
  screeningNote,

  /// Something recorded by the system.
  activity,
}

/// Semantic tone of an [ApplicationHistoryKind].
extension ApplicationHistoryKindTone on ApplicationHistoryKind {
  AppTone get tone => switch (this) {
    ApplicationHistoryKind.screeningNote => AppTone.info,
    ApplicationHistoryKind.activity => AppTone.neutral,
  };
}

/// One entry of the append-only activity log.
class ApplicationHistoryEvent extends Equatable {
  const ApplicationHistoryEvent({
    required this.id,
    required this.kind,
    required this.occurredOn,
    required this.title,
    this.note,
  });

  final String id;
  final ApplicationHistoryKind kind;
  final DateTime occurredOn;

  /// What happened, e.g. `Birth certificate uploaded`.
  final String title;

  /// The body of a screening note; `null` for an ordinary event.
  final String? note;

  @override
  List<Object?> get props => [id, kind, occurredOn, title, note];
}

/// Everything the detail screen draws for one application.
///
/// Separate from [ApplicationSummary]: the list reads the summary on every
/// card, while the checklist, the referees and the log belong to a record the
/// candidate has actually opened.
class ApplicationDetail extends Equatable {
  const ApplicationDetail({
    required this.application,
    required this.cycleId,
    required this.firstChoiceProgrammeId,
    required this.checklist,
    required this.referees,
    required this.history,
    this.secondChoiceProgrammeId,
  });

  final ApplicationSummary application;

  /// The cycle it is filed in, for the deadline quoted in the header.
  final String cycleId;

  /// The programme chosen so far — the dropdowns, the fee line and the
  /// deadline all read the catalogue through it rather than by title, so
  /// renaming a programme cannot orphan an application.
  final String firstChoiceProgrammeId;

  /// `null` while the candidate has picked only one.
  final String? secondChoiceProgrammeId;

  final List<ChecklistItem> checklist;
  final List<Referee> referees;
  final List<ApplicationHistoryEvent> history;

  /// Items with a green tick.
  ///
  /// Derived, never stored: a count kept beside the rows is a second source
  /// of truth that silently disagrees the moment one of them changes.
  int get completedCount =>
      checklist.where((item) => item.state == RequirementState.met).length;

  /// Items that stop submission — the known failures, and only those.
  ///
  /// An unverified item is deliberately absent: the README is explicit that an
  /// unverified requirement does not block a submission, so counting it here
  /// would rebuild the very mistake the three-state check exists to prevent.
  int get outstandingCount =>
      checklist.where((item) => item.state == RequirementState.notMet).length;

  /// `true` once nothing known is missing.
  bool get isChecklistComplete => outstandingCount == 0;

  @override
  List<Object?> get props => [
    application,
    cycleId,
    firstChoiceProgrammeId,
    secondChoiceProgrammeId,
    checklist,
    referees,
    history,
  ];
}
