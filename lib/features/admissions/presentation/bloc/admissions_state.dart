import 'package:equatable/equatable.dart';

import '../models/admissions_models.dart';

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
    this.emailConfirmation = EmailConfirmationStatus.idle,
    this.isEmailBannerDismissed = false,
    this.jambResultPending = false,
    this.failureMessage,
  });

  final AdmissionsStatus status;

  /// `null` until the record loads, which the page reports as a placeholder.
  final CandidateProfile? candidate;

  final List<AdmissionCycle> cycles;
  final List<ApplicationSummary> applications;
  final List<Bulletin> bulletins;

  final EmailConfirmationStatus emailConfirmation;

  /// The banner is a gate, not a nag: a candidate may hide it for this session.
  final bool isEmailBannerDismissed;

  final bool jambResultPending;

  final String? failureMessage;

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

  AdmissionsState copyWith({
    AdmissionsStatus? status,
    CandidateProfile? candidate,
    List<AdmissionCycle>? cycles,
    List<ApplicationSummary>? applications,
    List<Bulletin>? bulletins,
    EmailConfirmationStatus? emailConfirmation,
    bool? isEmailBannerDismissed,
    bool? jambResultPending,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return AdmissionsState(
      status: status ?? this.status,
      candidate: candidate ?? this.candidate,
      cycles: cycles ?? this.cycles,
      applications: applications ?? this.applications,
      bulletins: bulletins ?? this.bulletins,
      emailConfirmation: emailConfirmation ?? this.emailConfirmation,
      isEmailBannerDismissed:
          isEmailBannerDismissed ?? this.isEmailBannerDismissed,
      jambResultPending: jambResultPending ?? this.jambResultPending,
      failureMessage: clearFailure
          ? null
          : (failureMessage ?? this.failureMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    candidate,
    cycles,
    applications,
    bulletins,
    emailConfirmation,
    isEmailBannerDismissed,
    jambResultPending,
    failureMessage,
  ];
}
