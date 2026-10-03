/// View models of the programme browser.
///
/// Presentation only, like the rest of the admissions feature: the catalogue
/// endpoint does not exist yet, so these describe what the cards render rather
/// than what an API returns. When it lands, replace them with domain entities
/// and delete `../mock/programme_fixtures.dart`.
///
/// Models carry no `Color` and no localized string — the faculty, the study
/// mode and the verdict all map to the ARB in the widgets.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/theme/app_tone.dart';
import '../../../../core/utils/durations.dart';

/// A faculty of the university, as the catalogue groups programmes.
///
/// The order is the order the filter chips run in.
enum Faculty { science, arts, law, engineering }

/// Non-localized keywords the free-text search matches a faculty by.
///
/// An index, not copy: a query typed in another language will not match a
/// faculty here. The catalogue endpoint's full-text search is the real answer,
/// and this exists only so the placeholder search is not a dead control.
extension FacultySearchTerms on Faculty {
  List<String> get searchTerms => switch (this) {
    Faculty.science => const ['science', 'faculty of science'],
    Faculty.arts => const ['arts', 'faculty of arts'],
    Faculty.law => const ['law', 'faculty of law'],
    Faculty.engineering => const ['engineering', 'faculty of engineering'],
  };
}

/// How a candidate studies a programme.
///
/// An enum rather than free text because it is a closed vocabulary the
/// certificate is printed against, and because the design pairs it with the
/// duration in one metadata row.
enum StudyMode { undergraduateFullTime, directEntryFullTime }

/// Where a candidate stands against one admission requirement.
///
/// Three states, not two — see the module README. [notTracked] is a third fact,
/// not a mild failure: the bursary module is not installed on the server that
/// would have answered, so *nobody* can. Painting it red tells a candidate they
/// are blocked when they are not, so it stays amber and does not block.
enum RequirementState { met, notMet, notTracked }

/// Semantic tone and blocking behaviour of a [RequirementState].
extension RequirementStateRules on RequirementState {
  AppTone get tone => switch (this) {
    RequirementState.met => AppTone.success,
    RequirementState.notMet => AppTone.danger,
    RequirementState.notTracked => AppTone.warning,
  };

  /// Only a *known* failure blocks. An unverified requirement never does —
  /// the README is explicit that it must not stop a submission.
  bool get blocksSubmission => this == RequirementState.notMet;
}

/// One admission requirement of a programme, and where the candidate stands.
class ProgrammeRequirement extends Equatable {
  const ProgrammeRequirement({
    required this.id,
    required this.state,
    required this.detail,
  });

  /// Stable identifier, e.g. `utme-aggregate`.
  final String id;

  final RequirementState state;

  /// One sentence naming the requirement and the candidate's standing, e.g.
  /// `UTME cutoff met — 312 against a cutoff of 200 ✓`. The card joins these
  /// into the evaluation summary, so each has to stand on its own.
  final String detail;

  @override
  List<Object?> get props => [id, state, detail];
}

/// What a programme's card says about eligibility.
///
/// Derived from the requirements rather than stored, so a card can never
/// claim "you meet the requirements" while one requirement says otherwise.
enum ProgrammeVerdict { eligible, needsChecking, notEligible, closed }

/// Semantic tone of a [ProgrammeVerdict].
extension ProgrammeVerdictTone on ProgrammeVerdict {
  AppTone get tone => switch (this) {
    ProgrammeVerdict.eligible => AppTone.success,
    ProgrammeVerdict.needsChecking => AppTone.warning,
    ProgrammeVerdict.notEligible => AppTone.danger,
    ProgrammeVerdict.closed => AppTone.danger,
  };
}

/// One degree programme in the catalogue.
class Programme extends Equatable {
  const Programme({
    required this.id,
    required this.code,
    required this.title,
    required this.department,
    required this.faculty,
    required this.durationYears,
    required this.studyMode,
    required this.formFeeMinorUnits,
    required this.closesOn,
    required this.requirements,
    this.isClosed = false,
    this.closedOn,
  });

  final String id;

  /// Short course code a candidate searches for, e.g. `CSC`.
  final String code;

  /// e.g. `B.Sc. Computer Science`.
  final String title;

  /// e.g. `Department of Computer Science`.
  final String department;

  final Faculty faculty;
  final int durationYears;
  final StudyMode studyMode;

  /// In kobo. See `core/utils/money.dart`.
  final int formFeeMinorUnits;

  /// This programme's own deadline, which may fall before the cycle's.
  final DateTime closesOn;

  final List<ProgrammeRequirement> requirements;

  /// Applications are no longer accepted for this session.
  final bool isClosed;

  /// When they closed, so a candidate who cannot find the programme still
  /// learns what happened and when to come back.
  final DateTime? closedOn;

  /// The card's eligibility headline, derived from [requirements].
  ///
  /// A closed programme says so regardless of its requirements: the
  /// evaluation is no longer the reason it cannot be applied to.
  ProgrammeVerdict get verdict {
    if (isClosed) return ProgrammeVerdict.closed;

    final states = requirements.map((r) => r.state);
    if (states.contains(RequirementState.notMet)) {
      return ProgrammeVerdict.notEligible;
    }
    if (states.contains(RequirementState.notTracked)) {
      return ProgrammeVerdict.needsChecking;
    }
    return ProgrammeVerdict.eligible;
  }

  /// Whether an application can be started.
  ///
  /// An untracked requirement does not stop one — see [RequirementStateRules].
  bool get canApply =>
      !isClosed && !requirements.any((r) => r.state.blocksSubmission);

  /// The prose under the evaluation headline: every requirement's own sentence.
  String get evaluationSummary => requirements.map((r) => r.detail).join(' ');

  /// Days until this programme's own deadline; never negative.
  int daysUntilClose(DateTime now) => daysUntil(now, closesOn);

  /// `true` when [needle] names the programme, its code, its department or its
  /// faculty. An empty or whitespace query matches everything.
  bool matches(String needle) {
    final query = needle.trim().toLowerCase();
    if (query.isEmpty) return true;

    return title.toLowerCase().contains(query) ||
        code.toLowerCase().contains(query) ||
        department.toLowerCase().contains(query) ||
        faculty.searchTerms.any((term) => term.contains(query));
  }

  @override
  List<Object?> get props => [
    id,
    code,
    title,
    department,
    faculty,
    durationYears,
    studyMode,
    formFeeMinorUnits,
    closesOn,
    requirements,
    isClosed,
    closedOn,
  ];
}
