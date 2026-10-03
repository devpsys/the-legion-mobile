import '../models/programme_models.dart';

/// Sample catalogue for the programme browser.
///
/// Presentation-only placeholders: delete this file once the catalogue
/// endpoint exists and feed the models from a repository. The programmes, fees
/// and cutoffs are invented for the mock.
///
/// The set is chosen to exercise every state the card has to tell apart — a
/// fully eligible programme, two that need checking because a result has not
/// been verified, and one that has closed for the session.
abstract final class ProgrammeFixtures {
  /// The cycle the browser opens on, matching the overview's chip.
  static const String defaultCycleId = 'undergraduate-2026';

  /// ₦7,500.00.
  static const int formFeeMinorUnits = 750000;

  /// The programme's own deadline matches the cycle's.
  /// The cycle closes at the *end* of its last day, not at its start: the
  /// detail screen quotes the hour ("Submit by Feb 28, 2027, 23:59"), and a
  /// deadline stored as midnight would read 00:00 — twelve hours before the
  /// portal actually shuts.
  static final DateTime cycleDeadline = DateTime(2027, 2, 28, 23, 59);

  /// One day short of the cycle's own deadline, which is what earns the
  /// "ahead of the cycle" notice.
  static final DateTime earlyDeadline = DateTime(2027, 2, 14, 23, 59);

  /// When this programme stops accepting applications for the session.
  static final DateTime lawClosedOn = DateTime(2027, 1, 31);

  static final Programme computerScience = Programme(
    id: 'csc',
    code: 'CSC',
    title: 'B.Sc. Computer Science',
    department: 'Department of Computer Science',
    faculty: Faculty.science,
    durationYears: 5,
    studyMode: StudyMode.undergraduateFullTime,
    formFeeMinorUnits: formFeeMinorUnits,
    closesOn: cycleDeadline,
    requirements: [
      ProgrammeRequirement(
        id: 'olevel-credits',
        // The bursary module is not installed here, so nobody can answer this —
        // amber, and it does not block.
        state: RequirementState.notTracked,
        detail:
            "Requires five O'level credits including Mathematics and English. "
            'WAEC results are pending verification.',
      ),
      ProgrammeRequirement(
        id: 'utme-aggregate',
        state: RequirementState.met,
        detail: 'Minimum UTME aggregate of 240 — your score is 312 ✓',
      ),
    ],
  );

  static final Programme accounting = Programme(
    id: 'acc',
    code: 'ACC',
    title: 'B.Sc. Accounting',
    department: 'Department of Accounting',
    faculty: Faculty.science,
    durationYears: 4,
    studyMode: StudyMode.undergraduateFullTime,
    formFeeMinorUnits: formFeeMinorUnits,
    closesOn: cycleDeadline,
    requirements: [
      ProgrammeRequirement(
        id: 'utme-cutoff',
        state: RequirementState.met,
        detail: 'UTME cutoff met — 312 against a cutoff of 200 ✓',
      ),
      ProgrammeRequirement(
        id: 'prerequisites',
        state: RequirementState.met,
        detail: 'All prerequisites satisfied ✓',
      ),
    ],
  );

  static final Programme english = Programme(
    id: 'eng',
    code: 'ENG',
    title: 'B.A. English',
    department: 'Department of English',
    faculty: Faculty.arts,
    durationYears: 3,
    studyMode: StudyMode.directEntryFullTime,
    formFeeMinorUnits: 600000,
    // Ahead of the cycle, so the card has to say so rather than let a
    // candidate assume 28 February applies here too.
    closesOn: earlyDeadline,
    requirements: [
      ProgrammeRequirement(
        id: 'literature-credit',
        state: RequirementState.notTracked,
        detail:
            'Requires Literature in English at the O\'level sitting. WAEC '
            'results are pending verification.',
      ),
    ],
  );

  static final Programme law = Programme(
    id: 'law',
    code: 'LAW',
    title: 'B.Sc. Law',
    department: 'Department of Law',
    faculty: Faculty.law,
    durationYears: 5,
    studyMode: StudyMode.undergraduateFullTime,
    formFeeMinorUnits: formFeeMinorUnits,
    closesOn: lawClosedOn,
    isClosed: true,
    closedOn: lawClosedOn,
    requirements: [
      ProgrammeRequirement(
        id: 'quota',
        state: RequirementState.notMet,
        detail: 'The quota for this session is full.',
      ),
    ],
  );

  /// Every programme, in catalogue order.
  ///
  /// Not `const`: Dart has no constant [DateTime], and a catalogue that carries
  /// a deadline cannot be immutable at compile time.
  ///
  /// The closed one is deliberately kept in the list: a candidate who cannot
  /// find Law at all assumes the university does not teach it, while one who
  /// sees "Closed 31 January 2027" knows what happened and when to come back.
  static final List<Programme> programmes = [
    computerScience,
    accounting,
    english,
    law,
  ];
}
