import 'package:equatable/equatable.dart';

import '../models/admissions_models.dart';
import '../models/programme_models.dart';

/// Stage of the candidate portal.
enum AdmissionsStatus {
  /// Nothing loaded yet.
  initial,

  /// The candidate's record is being read.
  loading,

  /// Ready to render.
  ready,

  /// A request the candidate triggered failed.
  failure,
}

/// Progress of a resend of the email-confirmation link.
enum EmailConfirmationStatus {
  /// Nothing sent yet in this session.
  idle,

  /// A link is being sent.
  sending,

  /// A link was sent; the banner confirms and stays until the next sign-in.
  sent,

  /// The send failed.
  failed,
}

/// State of the candidate overview.
///
/// Presentation only — the admissions endpoints are pending, so the cubit reads
/// fixtures and models the two interactions the screen offers: resending the
/// confirmation link and dismissing it.
class AdmissionsState extends Equatable {
  const AdmissionsState({
    this.status = AdmissionsStatus.initial,
    this.candidate,
    this.cycles = const [],
    this.applications = const [],
    this.bulletins = const [],
    this.programmes = const [],
    this.emailConfirmation = EmailConfirmationStatus.idle,
    this.isEmailBannerDismissed = false,
    this.jambResultPending = false,
    this.failureMessage,
    this.programmeQuery = '',
    this.selectedFaculty,
    this.selectedCycleId,
  });

  final AdmissionsStatus status;

  /// `null` until the record loads, which the page reports as a placeholder.
  final CandidateProfile? candidate;

  final List<AdmissionCycle> cycles;
  final List<ApplicationSummary> applications;
  final List<Bulletin> bulletins;

  /// The whole catalogue, closed programmes included.
  final List<Programme> programmes;

  final EmailConfirmationStatus emailConfirmation;

  /// The banner is a gate, not a nag: a candidate may hide it for this session.
  final bool isEmailBannerDismissed;

  final bool jambResultPending;

  final String? failureMessage;

  /// Free text typed into the browser's search field.
  final String programmeQuery;

  /// `null` means "all faculties", which is why it is nullable rather than
  /// defaulting to the first one.
  final Faculty? selectedFaculty;

  /// The cycle the browser is showing; `null` until one is chosen.
  final String? selectedCycleId;

  /// `true` once the candidate can be greeted.
  bool get hasCandidate => candidate != null;

  /// The confirmation gate is only shown while it still blocks something.
  bool get needsEmailConfirmation =>
      candidate?.isEmailConfirmed == false && !isEmailBannerDismissed;

  /// `true` while the resend is in flight.
  bool get isSendingEmailLink =>
      emailConfirmation == EmailConfirmationStatus.sending;

  /// `true` once a link has been sent this session.
  bool get hasSentEmailLink =>
      emailConfirmation == EmailConfirmationStatus.sent;

  /// The cycle named in the header chip, or the feature's own title while the
  /// record is still loading.
  String cycleLabelFor(String fallback) =>
      cycles.isEmpty ? fallback : cycles.first.label;

  /// Cycles currently accepting applications.
  List<AdmissionCycle> openCyclesAt(DateTime now) =>
      cycles.where((cycle) => cycle.isOpenAt(now)).toList();

  /// The cycle the browser is showing, or `null` before one is chosen.
  AdmissionCycle? get selectedCycle => cycleById(selectedCycleId);

  AdmissionCycle? cycleById(String? id) {
    if (id == null) return null;
    for (final cycle in cycles) {
      if (cycle.id == id) return cycle;
    }
    return null;
  }

  /// Programmes matching the search box and the faculty chip.
  ///
  /// Filtering rather than searching: a closed programme stays in the result,
  /// because hiding it would answer a question the candidate did not ask.
  List<Programme> get visibleProgrammes => programmes.where((programme) {
    if (selectedFaculty != null && programme.faculty != selectedFaculty) {
      return false;
    }
    return programme.matches(programmeQuery);
  }).toList();

  /// Programmes per faculty, in [Faculty] order.
  ///
  /// Every faculty is kept, including one with nothing in it: "Engineering (0)"
  /// is the honest answer, and a chip that appears and disappears as the
  /// catalogue changes makes the filter feel unreliable.
  Map<Faculty, int> get programmeCounts => {
    for (final faculty in Faculty.values)
      faculty: programmes.where((p) => p.faculty == faculty).length,
  };

  AdmissionsState copyWith({
    AdmissionsStatus? status,
    CandidateProfile? candidate,
    List<AdmissionCycle>? cycles,
    List<ApplicationSummary>? applications,
    List<Bulletin>? bulletins,
    List<Programme>? programmes,
    EmailConfirmationStatus? emailConfirmation,
    bool? isEmailBannerDismissed,
    bool? jambResultPending,
    String? failureMessage,
    bool clearFailure = false,
    String? programmeQuery,
    Faculty? selectedFaculty,
    bool clearFaculty = false,
    String? selectedCycleId,
  }) {
    return AdmissionsState(
      status: status ?? this.status,
      candidate: candidate ?? this.candidate,
      cycles: cycles ?? this.cycles,
      applications: applications ?? this.applications,
      bulletins: bulletins ?? this.bulletins,
      programmes: programmes ?? this.programmes,
      emailConfirmation: emailConfirmation ?? this.emailConfirmation,
      isEmailBannerDismissed:
          isEmailBannerDismissed ?? this.isEmailBannerDismissed,
      jambResultPending: jambResultPending ?? this.jambResultPending,
      failureMessage: clearFailure
          ? null
          : (failureMessage ?? this.failureMessage),
      programmeQuery: programmeQuery ?? this.programmeQuery,
      selectedFaculty: clearFaculty
          ? null
          : (selectedFaculty ?? this.selectedFaculty),
      selectedCycleId: selectedCycleId ?? this.selectedCycleId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    candidate,
    cycles,
    applications,
    bulletins,
    programmes,
    emailConfirmation,
    isEmailBannerDismissed,
    jambResultPending,
    failureMessage,
    programmeQuery,
    selectedFaculty,
    selectedCycleId,
  ];
}
