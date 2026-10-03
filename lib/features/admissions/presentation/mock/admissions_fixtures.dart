import '../../../../core/utils/money.dart';
import '../models/admissions_models.dart';
import '../models/application_detail_models.dart';
import '../models/programme_models.dart';
import 'programme_fixtures.dart';

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
    id: ProgrammeFixtures.defaultCycleId,
    name: '2026/2027 Undergraduate Admissions',
    label: '2026/2027 Cycle',
    opensOn: DateTime(2026, 6),
    closesOn: ProgrammeFixtures.cycleDeadline,
    formFeeMinorUnits: ProgrammeFixtures.formFeeMinorUnits,
  );

  /// A second open cycle, which is what makes the empty state say "2".
  static final AdmissionCycle postgraduateCycle = AdmissionCycle(
    id: 'postgraduate-2026',
    name: '2026/2027 Postgraduate Admissions',
    label: '2026/2027 PG Cycle',
    opensOn: DateTime(2026, 8),
    closesOn: DateTime(2027, 1, 31),
    formFeeMinorUnits: 125000,
  );

  /// Every cycle the portal knows about, newest first.
  static final List<AdmissionCycle> cycles = [currentCycle, postgraduateCycle];

  /// Cycles open on [now].
  static List<AdmissionCycle> openCyclesAt(DateTime now) =>
      cycles.where((cycle) => cycle.isOpenAt(now)).toList();

  // --- Applications -------------------------------------------------------

  /// The applications on the candidate's record, newest first.
  ///
  /// Chosen to exercise every footer the `admissions_my_applications` design
  /// gives a card: an outstanding offer with a response deadline, an unopened
  /// draft, a rejection from a cycle that has since closed, and a
  /// matriculation that hands over to the student portal. Newest change first.
  static final List<ApplicationSummary> applications = [
    offeredApplication,
    draftApplication,
    rejectedApplication,
    matriculatedApplication,
  ];

  /// The offer waiting on the current cycle — the one with a deadline on it.
  static final ApplicationSummary offeredApplication = ApplicationSummary(
    id: 'app-00042',
    trackingCode: 'APP/2026/00042',
    programmeName: 'B.Sc. Computer Science',
    department: 'Department of Computer Science',
    secondChoiceName: 'B.Sc. Data Science',
    status: ApplicationStatus.offered,
    submittedOn: DateTime(2026, 9, 12),
    // Midday, so a test that reads the screen in the afternoon of the same
    // day sees the "3 hours ago" stamp the design draws.
    updatedOn: DateTime(2026, 10, 3, 12),
    cycleName: currentCycle.name,
    respondBy: DateTime(2027, 2, 28),
  );

  /// The application the candidate started and has not submitted — the record
  /// the `application_detail` design draws: a nine-item checklist three parts
  /// complete, four items genuinely missing, and two the bursary cannot
  /// answer for at all.
  ///
  /// Filed against B.A. English, the programme he was refused last cycle, so
  /// the draft reads as a reapplication rather than a second bite at the
  /// Computer Science offer sitting beside it.
  static final ApplicationSummary draftApplication = ApplicationSummary(
    id: 'app-00057',
    trackingCode: 'APP/2026/00057',
    programmeName: ProgrammeFixtures.english.title,
    department: ProgrammeFixtures.english.department,
    status: ApplicationStatus.draft,
    // "Application started", the first line of the activity log.
    submittedOn: DateTime(2026, 9, 12),
    // The screening note, the most recent line of it.
    updatedOn: DateTime(2026, 9, 20),
    cycleName: currentCycle.name,
  );

  /// A refusal from the cycle that has since closed, which is why it carries
  /// the line printed underneath the card.
  static final ApplicationSummary rejectedApplication = ApplicationSummary(
    id: 'app-00918',
    trackingCode: 'APP/2025/00918',
    programmeName: 'B.A. English',
    department: 'Department of English',
    status: ApplicationStatus.rejected,
    submittedOn: DateTime(2025, 9, 1),
    updatedOn: DateTime(2026, 9, 14),
    cycleName: '2025/2026 Undergraduate Admissions',
    cycleClosedOn: DateTime(2026, 2, 28),
  );

  /// The one that ended in a matriculation: the bridge to the student portal.
  static final ApplicationSummary matriculatedApplication = ApplicationSummary(
    id: 'app-00377',
    trackingCode: 'APP/2024/00377',
    programmeName: 'B.Sc. Accounting',
    department: 'Department of Accounting',
    status: ApplicationStatus.matriculated,
    submittedOn: DateTime(2024, 8, 20),
    updatedOn: DateTime(2025, 9, 16),
    cycleName: '2024/2025 Undergraduate Admissions',
    matricNumber: '25/ACC/0087',
  );

  /// A sample summary for the list widget and its tests, not shipped on the
  /// overview.
  static final ApplicationSummary sampleApplication = ApplicationSummary(
    id: 'app-00014',
    programmeName: 'B.Sc. Computer Science',
    department: 'Department of Computer Science',
    status: ApplicationStatus.underReview,
    submittedOn: DateTime(2026, 9, 12),
    updatedOn: DateTime(2026, 9, 15),
    cycleName: currentCycle.name,
    trackingCode: 'APP/2026/00014',
  );

  // --- Application detail -------------------------------------------------

  /// The readiness checklist of [draftApplication].
  ///
  /// Three green ticks, four known gaps and two the bursary cannot answer —
  /// the shape the `application_detail` designs are drawn around, and the
  /// reason submit stays disabled: 4 items are outstanding, while the two
  /// amber ones do not count against the candidate at all.
  static final ApplicationDetail draftDetail = ApplicationDetail(
    application: draftApplication,
    cycleId: currentCycle.id,
    firstChoiceProgrammeId: ProgrammeFixtures.english.id,
    checklist: [
      ChecklistItem(
        id: 'verified-email',
        state: RequirementState.notMet,
        title: 'Verified email address',
        // Interpolated rather than written twice: the address on screen has to
        // be the one on the candidate's record.
        detail: 'Open the confirmation link we emailed to ${candidate.email}.',
        action: ChecklistAction.resendEmail,
      ),
      ChecklistItem(
        id: 'personal-details',
        state: RequirementState.notMet,
        title: 'Personal details',
        detail: 'Add your date of birth, gender, country, contact address.',
        action: ChecklistAction.completePersonalDetails,
      ),
      ChecklistItem(
        id: 'olevel-results',
        state: RequirementState.met,
        title: "O'level results",
        detail: '1 sitting added.',
      ),
      ChecklistItem(
        id: 'jamb-caps',
        state: RequirementState.notTracked,
        title: 'JAMB result from CAPS',
        detail: 'Claim the JAMB result the university received from CAPS.',
        action: ChecklistAction.claimJamb,
      ),
      ChecklistItem(
        id: 'birth-certificate',
        state: RequirementState.met,
        title: 'Birth certificate',
        detail: 'Uploaded.',
      ),
      ChecklistItem(
        id: 'waec-neco',
        state: RequirementState.met,
        title: 'WAEC/NECO result',
        detail: 'Uploaded.',
      ),
      ChecklistItem(
        id: 'passport',
        state: RequirementState.notMet,
        title: 'Passport photograph',
        detail: 'Upload it under Documents.',
        action: ChecklistAction.uploadDocument,
      ),
      ChecklistItem(
        id: 'referees',
        state: RequirementState.notMet,
        title: 'Referees',
        detail: '1 of 2 invited | 0 responded.',
        action: ChecklistAction.inviteReferee,
      ),
      ChecklistItem(
        id: 'form-fee',
        state: RequirementState.notTracked,
        title: 'Application form fee',
        // The fee this application owes, quoted from the filed first choice so
        // it cannot drift from the catalogue. The browser quotes the same fee
        // for the same programme.
        detail:
            '${formatNaira(ProgrammeFixtures.english.formFeeMinorUnits)}. '
            'Online payment opens when the bursary goes live; you can submit '
            'meanwhile.',
        action: ChecklistAction.checkPayment,
      ),
    ],
    referees: [
      Referee(
        id: 'referee-0001',
        name: 'Dr Amina Yusuf',
        email: 'amina.yusuf@uniabuja.edu.ng',
        role: 'Senior Lecturer, Department of Computer Science, ABU Zaria',
        status: RefereeStatus.awaiting,
      ),
    ],
    // Newest first, which is how the log reads.
    history: [
      ApplicationHistoryEvent(
        id: 'event-0005',
        kind: ApplicationHistoryKind.screeningNote,
        occurredOn: DateTime(2026, 9, 20),
        title: 'Screening note',
        note: 'Awaiting your WAEC/NECO result to be verified.',
      ),
      ApplicationHistoryEvent(
        id: 'event-0004',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 18),
        title: 'Birth certificate uploaded',
      ),
      ApplicationHistoryEvent(
        id: 'event-0003',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 18),
        title: 'Referee invited: Dr Amina Yusuf',
      ),
      ApplicationHistoryEvent(
        id: 'event-0002',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 14),
        title: 'First choice set to B.A. English',
      ),
      ApplicationHistoryEvent(
        id: 'event-0001',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 12),
        title: 'Application started',
      ),
    ],
  );

  /// Every detail the portal can open, keyed by application id.
  ///
  /// Only the draft has one today: the offered, rejected and matriculated
  /// records have designs of their own that are not ported yet, so their cards
  /// do not offer a detail screen they could not fill.
  static final Map<String, ApplicationDetail> applicationDetails = {
    draftDetail.application.id: draftDetail,
  };

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
