import '../../../../core/utils/money.dart';
import '../models/admissions_models.dart';
import '../models/application_detail_models.dart';
import '../models/jamb_models.dart';
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

  /// The academic session of [currentCycle], as an application quotes it.
  static const String currentSession = '2026/2027';

  /// The cycle named in the header chip.
  static final AdmissionCycle currentCycle = AdmissionCycle(
    id: ProgrammeFixtures.defaultCycleId,
    name: '2026/2027 Undergraduate Admissions',
    label: '2026/2027 Cycle',
    session: currentSession,
    opensOn: DateTime(2026, 6),
    closesOn: ProgrammeFixtures.cycleDeadline,
    formFeeMinorUnits: ProgrammeFixtures.formFeeMinorUnits,
  );

  /// A second open cycle, which is what makes the empty state say "2".
  static final AdmissionCycle postgraduateCycle = AdmissionCycle(
    id: 'postgraduate-2026',
    name: '2026/2027 Postgraduate Admissions',
    label: '2026/2027 PG Cycle',
    session: currentSession,
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
  /// gives a card, and every ending the application detail screen draws: an
  /// outstanding offer with a response deadline, an unopened draft, a
  /// withdrawal, a rejection and a lapsed offer from cycles that have since
  /// closed, and a matriculation that hands over to the student portal. Newest
  /// change first.
  static final List<ApplicationSummary> applications = [
    offeredApplication,
    draftApplication,
    withdrawnApplication,
    rejectedApplication,
    expiredApplication,
    matriculatedApplication,
  ];

  /// The offer waiting on the current cycle — the one with a deadline on it.
  static final ApplicationSummary offeredApplication = ApplicationSummary(
    id: 'app-00042',
    trackingCode: 'APP/2026/00042',
    programmeName: 'B.Sc. Computer Science',
    department: 'Department of Computer Science',
    category: ProgrammeCategory.undergraduate,
    secondChoiceName: 'B.Sc. Data Science',
    status: ApplicationStatus.offered,
    submittedOn: DateTime(2026, 9, 12),
    // Midday, so a test that reads the screen in the afternoon of the same
    // day sees the "3 hours ago" stamp the design draws.
    updatedOn: DateTime(2026, 10, 3, 12),
    cycleName: currentCycle.name,
    cycleSession: currentSession,
    respondBy: DateTime(2027, 2, 28, 23, 59),
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
    category: ProgrammeFixtures.english.category,
    status: ApplicationStatus.draft,
    // "Application started", the first line of the activity log.
    submittedOn: DateTime(2026, 9, 12),
    // The screening note, the most recent line of it.
    updatedOn: DateTime(2026, 9, 20),
    cycleName: currentCycle.name,
    cycleSession: currentSession,
  );

  /// A refusal from the cycle that has since closed, which is why it carries
  /// the line printed underneath the card.
  static final ApplicationSummary rejectedApplication = ApplicationSummary(
    id: 'app-00918',
    trackingCode: 'APP/2025/00918',
    programmeName: 'B.A. English',
    department: 'Department of English',
    category: ProgrammeCategory.undergraduate,
    status: ApplicationStatus.rejected,
    // The time of day is part of the record: the decision notice prints it.
    submittedOn: DateTime(2025, 9, 1, 14, 22),
    updatedOn: DateTime(2026, 9, 14),
    cycleName: '2025/2026 Undergraduate Admissions',
    cycleSession: '2025/2026',
    cycleClosedOn: DateTime(2026, 2, 28),
  );

  /// An offer the candidate left unanswered until the deadline passed.
  static final ApplicationSummary expiredApplication = ApplicationSummary(
    id: 'app-00611',
    trackingCode: 'APP/2025/00611',
    programmeName: ProgrammeFixtures.law.title,
    department: ProgrammeFixtures.law.department,
    category: ProgrammeFixtures.law.category,
    status: ApplicationStatus.expired,
    submittedOn: DateTime(2025, 10, 2),
    updatedOn: DateTime(2026, 2, 28, 23, 59),
    cycleName: '2025/2026 Undergraduate Admissions',
    cycleSession: '2025/2026',
    cycleClosedOn: DateTime(2026, 2, 28),
  );

  /// An application the candidate withdrew of their own accord.
  static final ApplicationSummary withdrawnApplication = ApplicationSummary(
    id: 'app-00733',
    trackingCode: 'APP/2026/00733',
    programmeName: ProgrammeFixtures.dataScience.title,
    department: ProgrammeFixtures.dataScience.department,
    category: ProgrammeFixtures.dataScience.category,
    status: ApplicationStatus.withdrawn,
    submittedOn: DateTime(2026, 9, 2),
    updatedOn: DateTime(2026, 9, 14),
    cycleName: currentCycle.name,
    cycleSession: currentSession,
  );

  /// The one that ended in a matriculation: the bridge to the student portal.
  static final ApplicationSummary matriculatedApplication = ApplicationSummary(
    id: 'app-00377',
    trackingCode: 'APP/2024/00377',
    programmeName: 'B.Sc. Accounting',
    department: 'Department of Accounting',
    category: ProgrammeCategory.undergraduate,
    status: ApplicationStatus.matriculated,
    submittedOn: DateTime(2024, 8, 20),
    updatedOn: DateTime(2025, 9, 16),
    cycleName: '2024/2025 Undergraduate Admissions',
    cycleSession: '2024/2025',
    matricNumber: '25/ACC/0087',
  );

  /// A sample summary for the list widget and its tests, not shipped on the
  /// overview.
  static final ApplicationSummary sampleApplication = ApplicationSummary(
    id: 'app-00014',
    programmeName: 'B.Sc. Computer Science',
    department: 'Department of Computer Science',
    category: ProgrammeCategory.undergraduate,
    status: ApplicationStatus.underReview,
    submittedOn: DateTime(2026, 9, 12),
    updatedOn: DateTime(2026, 9, 15),
    cycleName: currentCycle.name,
    cycleSession: currentSession,
    trackingCode: 'APP/2026/00014',
  );

  // --- Application detail -------------------------------------------------

  /// How many referees an application names.
  static const int refereesRequired = 2;

  /// The checklist row for referees, as the record counts them.
  static String refereesDetail({
    required int invited,
    required int responded,
  }) => '$invited of $refereesRequired invited | $responded responded.';

  /// The readiness checklist of an application to [firstChoice].
  ///
  /// Most of it is the candidate's standing, not the application's — the
  /// address he has not confirmed, the documents he has uploaded — which is
  /// why a draft opened today starts with the same ticks and gaps as the one
  /// he opened in September. The two rows that belong to the application
  /// itself are the referees, counted by [refereesDetail], and the form fee,
  /// quoted from the first choice. The JAMB row is met once a result is on
  /// the record, whichever draft asks.
  ///
  /// Three green ticks, four known gaps and two the bursary cannot answer —
  /// the shape the `application_detail` designs are drawn around, and the
  /// reason submit stays disabled: 4 items are outstanding, while the two
  /// amber ones do not count against the candidate at all.
  static List<ChecklistItem> candidateChecklist({
    required Programme firstChoice,
    required String refereesDetail,
    JambResult? linkedJambResult,
  }) => [
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
    if (linkedJambResult == null)
      ChecklistItem(
        id: 'jamb-caps',
        state: RequirementState.notTracked,
        title: 'JAMB result from CAPS',
        detail: 'Claim the JAMB result the university received from CAPS.',
        action: ChecklistAction.claimJamb,
      )
    else
      ChecklistItem(
        id: 'jamb-caps',
        state: RequirementState.met,
        title: 'JAMB result from CAPS',
        detail: jambLinkedChecklistDetail(linkedJambResult),
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
      detail: refereesDetail,
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
          '${formatNaira(firstChoice.formFeeMinorUnits)}. '
          'Online payment opens when the bursary goes live; you can submit '
          'meanwhile.',
      action: ChecklistAction.checkPayment,
    ),
  ];

  /// The draft the `application_detail` designs draw: the checklist above,
  /// one referee invited of the two, and a log that has been running since
  /// September.
  static final ApplicationDetail draftDetail = ApplicationDetail(
    application: draftApplication,
    cycleId: currentCycle.id,
    firstChoiceProgrammeId: ProgrammeFixtures.english.id,
    checklist: candidateChecklist(
      firstChoice: ProgrammeFixtures.english,
      refereesDetail: refereesDetail(invited: 1, responded: 0),
    ),
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

  // --- Letters ------------------------------------------------------------

  /// Where every letter says it can be checked, as printed at its foot.
  static const String verificationUrl = 'thelegion.edu.ng/verify/admission';

  /// The two offices that sign an admission letter.
  static const List<LetterSignatory> letterSignatories = [
    LetterSignatory(
      signature: 'Amina Yusuf',
      name: 'Dr Amina Yusuf',
      title: 'Registrar',
    ),
    LetterSignatory(
      signature: 'I. Garba',
      name: 'Prof Ibrahim Garba',
      title: 'Vice-Chancellor',
      onBehalfOf: 'for The Legion University',
    ),
  ];

  /// The candidate's postal address, as the letter is addressed.
  static const List<String> candidateAddress = [
    'Plot 14, Gwarinpa Estate',
    'Federal Capital Territory, Abuja',
  ];

  /// The terms of the outstanding offer — shared by the card that answers
  /// them and the letter that sets them out, so the two cannot disagree.
  static final OfferTerms offeredTerms = OfferTerms(
    level: 100,
    session: currentSession,
    // Quoted from the filed first choice so the fee on the offer cannot
    // drift from the one the browser quotes for the same programme.
    formFeeMinorUnits: ProgrammeFixtures.computerScience.formFeeMinorUnits,
    formFeePaidOn: DateTime(2026, 9, 12),
    acceptanceFeeMinorUnits: 500000,
    acceptBy: DateTime(2027, 2, 28, 23, 59),
  );

  /// The letter behind [offeredDetail], issued the day the offer was made.
  static final AdmissionLetter offeredLetter = AdmissionLetter(
    issuedOn: DateTime(2026, 10),
    verificationCode: '7KQ2M9XW4HPA',
    verificationUrl: verificationUrl,
    addressLines: candidateAddress,
    terms: offeredTerms,
    signatories: letterSignatories,
  );

  /// The letter that offered the place [matriculatedDetail] took up — a year
  /// older, and still the document the student is asked to produce.
  static final AdmissionLetter matriculatedLetter = AdmissionLetter(
    issuedOn: DateTime(2025, 8, 20),
    verificationCode: 'P3HD7VQ2TM8K',
    verificationUrl: verificationUrl,
    addressLines: candidateAddress,
    terms: OfferTerms(
      level: 100,
      session: '2025/2026',
      formFeeMinorUnits: ProgrammeFixtures.accounting.formFeeMinorUnits,
      formFeePaidOn: DateTime(2024, 8, 20),
      acceptanceFeeMinorUnits: 500000,
      acceptBy: DateTime(2025, 9, 1, 23, 59),
    ),
    signatories: letterSignatories,
  );

  /// The offer the detail screen answers: the terms, and nothing else on
  /// the page to compete with the date.
  static final ApplicationDetail offeredDetail = ApplicationDetail(
    application: offeredApplication,
    cycleId: currentCycle.id,
    firstChoiceProgrammeId: ProgrammeFixtures.computerScience.id,
    secondChoiceProgrammeId: ProgrammeFixtures.dataScience.id,
    offer: offeredTerms,
    letter: offeredLetter,
    history: [
      ApplicationHistoryEvent(
        id: 'offer-event-0004',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 10, 3),
        title: 'Admission offered',
      ),
      ApplicationHistoryEvent(
        id: 'offer-event-0003',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 18),
        title: 'Birth certificate uploaded',
      ),
      ApplicationHistoryEvent(
        id: 'offer-event-0002',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 18),
        title: 'Referee invited: Dr Amina Yusuf',
      ),
      ApplicationHistoryEvent(
        id: 'offer-event-0001',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 12),
        title: 'Application started',
      ),
    ],
  );

  /// The refusal, with the committee's reasons: a figure per criterion rather
  /// than a verdict, so the decision reads as something that can be answered.
  static final ApplicationDetail rejectedDetail = ApplicationDetail(
    application: rejectedApplication,
    cycleId: 'undergraduate-2025',
    firstChoiceProgrammeId: ProgrammeFixtures.english.id,
    rejection: RejectionNotice(
      decidedOn: DateTime(2026, 9, 14, 9),
      determination:
          'Quota capacity exhausted for Department of English; verified '
          'academic composite score remains below the statutory departmental '
          'merit threshold of 260.',
      criteria: const [
        RejectionCriterion(
          kind: RejectionCriterionKind.utme,
          outcome: RejectionOutcome.belowCutoff,
          submitted: '242 / 400',
          required: '260',
          progress: 242 / 400,
        ),
        RejectionCriterion(
          kind: RejectionCriterionKind.olevelEnglish,
          outcome: RejectionOutcome.deficit,
          submitted: 'Grade C5',
          required: 'Grade B3',
        ),
        RejectionCriterion(
          kind: RejectionCriterionKind.directEntry,
          outcome: RejectionOutcome.incomplete,
          note:
              'Transcript lacked mandatory Registrar endorsement stamp at the '
              'closure of evaluation cycle (28 February 2026).',
        ),
      ],
      verificationHash: 'SHA256:7b91c...00918e2a',
      faqs: const [
        AdmissionFaq(
          question: 'Direct entry transcript retrieval',
          answer:
              'Physical transcripts submitted for the 2025/2026 cycle remain '
              'archived with the Bursary & Records Division. Candidate can '
              'request electronic re-indexing for the 2026/2027 cycle without '
              'paying full courier fees.',
        ),
        AdmissionFaq(
          question: 'Eligible alternative programmes',
          answer:
              'With a UTME score of 242, candidate falls within the threshold '
              'for B.A. History & Strategic Studies (Cutoff: 230) and B.A. '
              'Philosophy (Cutoff: 225) in subsequent cycles.',
        ),
      ],
    ),
    history: [
      ApplicationHistoryEvent(
        id: 'rejected-event-0003',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 14),
        title: 'Decision: not successful',
      ),
      ApplicationHistoryEvent(
        id: 'rejected-event-0002',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2025, 9, 1),
        title: 'Application submitted',
      ),
      ApplicationHistoryEvent(
        id: 'rejected-event-0001',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2025, 8, 20),
        title: 'Application started',
      ),
    ],
  );

  /// The ending: a matric number, and the door to the student portal.
  static final ApplicationDetail matriculatedDetail = ApplicationDetail(
    application: matriculatedApplication,
    cycleId: 'undergraduate-2024',
    firstChoiceProgrammeId: ProgrammeFixtures.accounting.id,
    letter: matriculatedLetter,
    history: [
      ApplicationHistoryEvent(
        id: 'matric-event-0004',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2025, 9, 16),
        title: 'Matriculated: student portal opened',
      ),
      ApplicationHistoryEvent(
        id: 'matric-event-0003',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2025, 9, 1),
        title: 'Offer accepted',
      ),
      ApplicationHistoryEvent(
        id: 'matric-event-0002',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2025, 8, 20),
        title: 'Admission offered',
      ),
      ApplicationHistoryEvent(
        id: 'matric-event-0001',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2024, 8, 20),
        title: 'Application submitted',
      ),
    ],
  );

  /// An offer that was never answered: amber, not red, because the deadline
  /// passed and nothing the candidate did was wrong.
  static final ApplicationDetail expiredDetail = ApplicationDetail(
    application: expiredApplication,
    cycleId: 'undergraduate-2025',
    firstChoiceProgrammeId: ProgrammeFixtures.law.id,
    expiredOn: DateTime(2026, 2, 28, 23, 59),
    history: [
      ApplicationHistoryEvent(
        id: 'expired-event-0003',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 2, 28),
        title: 'Offer expired',
      ),
      ApplicationHistoryEvent(
        id: 'expired-event-0002',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 1, 20),
        title: 'Admission offered',
      ),
      ApplicationHistoryEvent(
        id: 'expired-event-0001',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2025, 10, 2),
        title: 'Application submitted',
      ),
    ],
  );

  /// A withdrawal, with the reason the candidate gave quoted back to them.
  static final ApplicationDetail withdrawnDetail = ApplicationDetail(
    application: withdrawnApplication,
    cycleId: currentCycle.id,
    firstChoiceProgrammeId: ProgrammeFixtures.dataScience.id,
    withdrawal: WithdrawalRecord(
      withdrawnOn: DateTime(2026, 9, 14),
      reason: 'I accepted a place at another university.',
    ),
    history: [
      ApplicationHistoryEvent(
        id: 'withdrawn-event-0002',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 14),
        title: 'Application withdrawn',
      ),
      ApplicationHistoryEvent(
        id: 'withdrawn-event-0001',
        kind: ApplicationHistoryKind.activity,
        occurredOn: DateTime(2026, 9, 2),
        title: 'Application started',
      ),
    ],
  );

  /// Every detail the portal can open, keyed by application id.
  ///
  /// Every status the designs draw has one. The statuses between draft and
  /// offer (submitted, under review) and the offer's own answers (accepted,
  /// declined) are not drawn yet, so no record carries them and no card offers
  /// a detail screen it could not fill.
  static final Map<String, ApplicationDetail> applicationDetails = {
    for (final detail in [
      offeredDetail,
      draftDetail,
      withdrawnDetail,
      rejectedDetail,
      expiredDetail,
      matriculatedDetail,
    ])
      detail.application.id: detail,
  };

  // --- Starting an application --------------------------------------------

  /// Width of the serial in an id and a reference, e.g. `00057`.
  static const int serialWidth = 5;

  /// The serial the registry would issue next: one above the highest on the
  /// record, whatever year it was filed in — a reference is never reused.
  static int nextSerial(Iterable<ApplicationSummary> existing) {
    var highest = 0;
    for (final application in existing) {
      final digits = RegExp(r'\d+$').firstMatch(application.id)?.group(0);
      final serial = digits == null ? null : int.tryParse(digits);
      if (serial != null && serial > highest) highest = serial;
    }
    return highest + 1;
  }

  /// A draft to [programme] under [cycle], as the registry would open one:
  /// the next reference, the candidate's standing on every checklist row,
  /// nobody invited yet, and a log that starts today.
  ///
  /// The reference carries the year the cycle opened, which is how the
  /// existing ones read (`APP/2026/…` for the 2026/2027 session), and the
  /// draft starts at the top of the record because the record is newest first.
  static ApplicationDetail startDraft({
    required Programme programme,
    required AdmissionCycle cycle,
    required DateTime startedOn,
    required Iterable<ApplicationSummary> existing,
    JambResult? linkedJambResult,
  }) {
    final serial = nextSerial(existing).toString().padLeft(serialWidth, '0');
    final id = 'app-$serial';
    final application = ApplicationSummary(
      id: id,
      trackingCode: 'APP/${cycle.opensOn.year}/$serial',
      programmeName: programme.title,
      department: programme.department,
      category: programme.category,
      status: ApplicationStatus.draft,
      submittedOn: startedOn,
      updatedOn: startedOn,
      cycleName: cycle.name,
      cycleSession: cycle.session,
    );

    return ApplicationDetail(
      application: application,
      cycleId: cycle.id,
      firstChoiceProgrammeId: programme.id,
      checklist: candidateChecklist(
        firstChoice: programme,
        refereesDetail: refereesDetail(invited: 0, responded: 0),
        linkedJambResult: linkedJambResult,
      ),
      // Newest first, like every log: the choice was made at the start.
      history: [
        ApplicationHistoryEvent(
          id: '$id-event-0002',
          kind: ApplicationHistoryKind.activity,
          occurredOn: startedOn,
          title: 'First choice set to ${programme.title}',
        ),
        ApplicationHistoryEvent(
          id: '$id-event-0001',
          kind: ApplicationHistoryKind.activity,
          occurredOn: startedOn,
          title: 'Application started',
        ),
      ],
    );
  }

  // --- Public verification ------------------------------------------------

  /// What the registry answers for each verification code it has issued:
  /// the letter's own facts and nothing the letter does not print.
  ///
  /// Keyed by the code as printed. The lookup normalises case and spacing,
  /// so a code typed from a photocopy still resolves.
  static final Map<String, AdmissionVerificationResult> verificationRegister = {
    offeredLetter.verificationCode: AdmissionVerificationResult(
      candidateName: candidate.displayName,
      programmeName: offeredApplication.programmeName,
      department: offeredApplication.department,
      level: offeredTerms.level,
      session: offeredTerms.session,
      status: ApplicationStatus.offered,
      issuedOn: offeredLetter.issuedOn,
    ),
    matriculatedLetter.verificationCode: AdmissionVerificationResult(
      candidateName: candidate.displayName,
      programmeName: matriculatedApplication.programmeName,
      department: matriculatedApplication.department,
      level: matriculatedLetter.terms.level,
      session: matriculatedLetter.terms.session,
      status: ApplicationStatus.matriculated,
      issuedOn: matriculatedLetter.issuedOn,
      matricNumber: matriculatedApplication.matricNumber,
    ),
  };

  /// The register's answer for [code], or `null` for a code it never issued.
  static AdmissionVerificationResult? verify(String code) =>
      verificationRegister[normaliseVerificationCode(code)];

  // --- JAMB ---------------------------------------------------------------

  /// A result imported from CAPS, waiting to be claimed.
  static const bool jambResultPending = true;

  /// The candidate's own UTME result, as CAPS sent it — the record the
  /// `claim_jamb_result` design draws once the three facts match.
  static final JambResult jambResult = JambResult(
    registrationNumber: '202630112233AB',
    candidateName: candidate.displayName,
    surname: 'Ibrahim',
    dateOfBirth: DateTime(2008, 5, 2),
    examinationYear: 2026,
    aggregateScore: 312,
    subjects: const [
      JambSubjectScore(subject: 'English', score: 74),
      JambSubjectScore(subject: 'Mathematics', score: 82),
      JambSubjectScore(subject: 'Physics', score: 78),
      JambSubjectScore(subject: 'Chemistry', score: 78),
    ],
  );

  /// Every result the import holds for this candidate — one, in the mock.
  static final List<JambResult> jambImport = [jambResult];

  /// The import's answer for [request], or `null` when nothing matches.
  static JambResult? matchJambResult(JambClaimRequest request) {
    for (final result in jambImport) {
      if (result.matches(request)) return result;
    }
    return null;
  }

  /// The application a claimed result is linked to: the draft, whose
  /// checklist is waiting on it. The design's binding notice names the
  /// outstanding offer instead, but an offer already made has no use for a
  /// score; the record that does is the one still being assembled.
  static final String jambLinkApplicationId = draftApplication.id;

  /// The checklist row's detail once the result is linked.
  static String jambLinkedChecklistDetail(JambResult result) =>
      '${result.examinationYear} UTME, aggregate ${result.aggregateScore}. '
      'Linked from CAPS.';

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
