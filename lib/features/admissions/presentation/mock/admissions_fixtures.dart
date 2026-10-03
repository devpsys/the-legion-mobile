import '../models/admissions_models.dart';

/// Sample content for the candidate admissions portal.
///
/// Presentation-only placeholders: delete this file once the admissions
/// endpoints exist and feed the models from a repository. The names, dates and
/// announcements are invented for the mock.
abstract final class AdmissionsFixtures {
  // --- Candidate ----------------------------------------------------------

  static const CandidateProfile candidate = CandidateProfile(
    displayName: 'Musa Ibrahim',
    email: 'amusa.ibrahim@example.com',
    // The design's gate: an unconfirmed address blocks applying and claiming.
    isEmailConfirmed: false,
  );

  // --- Cycles -------------------------------------------------------------

  /// The cycle named in the header chip.
  static final AdmissionCycle currentCycle = AdmissionCycle(
    id: 'undergraduate-2026',
    label: '2026/2027 Cycle',
    opensOn: DateTime(2026, 6),
    closesOn: DateTime(2027, 2, 28),
  );

  /// A second open cycle, which is what makes the empty state say "2".
  static final AdmissionCycle postgraduateCycle = AdmissionCycle(
    id: 'postgraduate-2026',
    label: '2026/2027 Postgraduate Cycle',
    opensOn: DateTime(2026, 8),
    closesOn: DateTime(2027, 1, 31),
  );

  /// Every cycle the portal knows about, newest first.
  static final List<AdmissionCycle> cycles = [currentCycle, postgraduateCycle];

  /// Cycles open on [now].
  static List<AdmissionCycle> openCyclesAt(DateTime now) =>
      cycles.where((cycle) => cycle.isOpenAt(now)).toList();

  // --- Applications -------------------------------------------------------

  /// No applications, which is the state the design shows. The README lists
  /// "with an application in progress" as a variant still to be designed, so
  /// the fixture deliberately does not invent one.
  static const List<ApplicationSummary> applications = [];

  /// A sample summary for the list widget and its tests, not shipped on the
  /// overview.
  static final ApplicationSummary sampleApplication = ApplicationSummary(
    id: 'app-00014',
    programmeName: 'B.Sc. Computer Science',
    department: 'Department of Computer Science',
    status: ApplicationStatus.underReview,
    submittedOn: DateTime(2026, 9, 12),
    trackingCode: 'ADM-2026-00014',
  );

  // --- JAMB ---------------------------------------------------------------

  /// A result imported from CAPS, waiting to be claimed.
  static const bool jambResultPending = true;

  static const String jambCandidateScore = '248';

  // --- Bulletins ----------------------------------------------------------

  static const List<Bulletin> bulletins = [
    Bulletin(
      id: 'deadline-extension',
      category: BulletinCategory.information,
      publishedLabel: '2 days ago',
      title: 'Extended application deadline',
      body:
          'The 2026/2027 Undergraduate cycle now closes on 28 February. The '
          'Department of Computer Science is accepting applications to 14 '
          'February.',
    ),
    Bulletin(
      id: 'jamb-received',
      category: BulletinCategory.success,
      publishedLabel: '6 days ago',
      title: 'JAMB results received',
      body:
          'Our CAPS import for the 2026 examination is complete. Log in and '
          'claim your result to begin an application.',
    ),
  ];
}
