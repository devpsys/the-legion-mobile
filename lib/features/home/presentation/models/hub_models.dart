/// View models of the student landing hub.
///
/// These shapes describe what the screen renders, not what an API returns:
/// they exist because the backend is still pending and the hub is fed from
/// `presentation/mock/`. When the endpoints land, replace them with the
/// domain entities of the feature and delete the mock file.
///
/// Each model is immutable so a [Bloc] can rebuild only what changed, and so
/// tests can assert on values without a widget tree.
library;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_tone.dart';

/// Academic term the hub reports progress for.
///
/// Progress and the remaining day count are derived from [startsOn] / [endsOn]
/// rather than stored, so they cannot drift out of sync with the dates.
class HubTerm extends Equatable {
  const HubTerm({
    required this.session,
    required this.semesterShort,
    required this.semesterLong,
    required this.startsOn,
    required this.endsOn,
  });

  /// Academic session, e.g. `2025/2026`.
  final String session;

  /// Abbreviated semester for the header pill, e.g. `2nd Sem`.
  final String semesterShort;

  /// Full semester name for the hero, e.g. `2nd Semester`.
  final String semesterLong;

  final DateTime startsOn;
  final DateTime endsOn;

  /// Share of the term already elapsed, clamped to `0..1`.
  double progressAt(DateTime now) {
    final total = endsOn.difference(startsOn).inSeconds;
    if (total <= 0) return 0;
    final elapsed = now.difference(startsOn).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  /// Whole days left in the term; never negative.
  int daysRemainingAt(DateTime now) {
    final remaining = endsOn.difference(now).inHours;
    return remaining <= 0 ? 0 : (remaining / 24).ceil();
  }

  @override
  List<Object?> get props => [
    session,
    semesterShort,
    semesterLong,
    startsOn,
    endsOn,
  ];
}

/// Academic standing shown under the greeting.
class HubStanding extends Equatable {
  const HubStanding({required this.level, required this.programme});

  /// e.g. `300 Level`.
  final String level;

  /// e.g. `B.Sc. Computer Science`.
  final String programme;

  /// `300 Level · B.Sc. Computer Science`
  String get summary => '$level · $programme';

  @override
  List<Object?> get props => [level, programme];
}

/// Where a step of the "Do this next" flow stands.
///
/// The order matters: the flow renders the steps in the sequence the student
/// must clear them in, and each state drives its own colour and icon.
enum TimelineStepState {
  /// Can be done right now.
  actionable,

  /// Cannot be done until an earlier step clears.
  blocked,

  /// Waiting on the institution, not on the student.
  waiting,

  /// Cleared.
  done,
}

/// Semantic tone of a timeline step, derived from [TimelineStepState].
extension TimelineStepTone on TimelineStepState {
  AppTone get tone => switch (this) {
    TimelineStepState.actionable => AppTone.warning,
    TimelineStepState.blocked => AppTone.danger,
    TimelineStepState.waiting => AppTone.info,
    TimelineStepState.done => AppTone.success,
  };
}

/// One run of text inside a timeline step's detail line.
///
/// The designs set currency amounts in the mono face at a heavier weight while
/// the surrounding sentence stays proportional, so a detail line is a list of
/// segments rather than a single string.
class HubTextRun extends Equatable {
  const HubTextRun(this.text, {this.isEmphasised = false});

  final String text;

  /// Rendered in the mono face, semi-bold — for amounts and reference codes.
  final bool isEmphasised;

  @override
  List<Object?> get props => [text, isEmphasised];
}

/// One step of the sequential "Do this next" flow.
class TimelineStep extends Equatable {
  const TimelineStep({
    required this.id,
    required this.title,
    required this.detail,
    required this.state,
    required this.icon,
    this.dueOn,
    this.isInteractive = true,
  });

  /// Stable identifier used by tests and analytics.
  final String id;

  final String title;

  /// Supporting line, split so amounts can be emphasised.
  final List<HubTextRun> detail;

  final TimelineStepState state;

  /// Leading glyph of the step card.
  final IconData icon;

  /// Deadline for an actionable step, rendered as `Due 3 October`.
  final DateTime? dueOn;

  /// Cleared steps are anchors in the timeline, not links.
  final bool isInteractive;

  @override
  List<Object?> get props => [
    id,
    title,
    detail,
    state,
    icon,
    dueOn,
    isInteractive,
  ];
}

/// A portal reachable from the hub.
class PortalModule extends Equatable {
  const PortalModule({
    required this.id,
    required this.label,
    required this.icon,
    this.routeName,
  });

  final String id;
  final String label;
  final IconData icon;

  /// Named route to open. `null` for portals that are still a row in the
  /// directory rather than a screen.
  final String? routeName;

  @override
  List<Object?> get props => [id, label, icon, routeName];
}

/// A themed group of portals, e.g. "Campus Life & Facilities".
class ModuleCluster extends Equatable {
  const ModuleCluster({
    required this.id,
    required this.label,
    required this.modules,
  });

  final String id;
  final String label;
  final List<PortalModule> modules;

  /// Total number of portals across every cluster — the "Everything Else" count.
  static int countOf(Iterable<ModuleCluster> clusters) =>
      clusters.fold(0, (total, cluster) => total + cluster.modules.length);

  @override
  List<Object?> get props => [id, label, modules];
}

/// Editorial weight of a bulletin.
enum AnnouncementCategory { urgent, notice, information }

/// Semantic tone of a bulletin, mirroring its category.
extension AnnouncementCategoryTone on AnnouncementCategory {
  AppTone get tone => switch (this) {
    AnnouncementCategory.urgent => AppTone.danger,
    AnnouncementCategory.notice => AppTone.warning,
    AnnouncementCategory.information => AppTone.info,
  };
}

/// A bulletin on the hub's announcement board.
class Announcement extends Equatable {
  const Announcement({
    required this.id,
    required this.category,
    required this.publishedLabel,
    required this.title,
    required this.body,
  });

  final String id;
  final AnnouncementCategory category;

  /// Relative timestamp shown next to the category tag, e.g. `3 hours ago`.
  final String publishedLabel;

  final String title;
  final String body;

  @override
  List<Object?> get props => [id, category, publishedLabel, title, body];
}

/// A shortcut in the account panel.
class AccountUtility extends Equatable {
  const AccountUtility({
    required this.id,
    required this.label,
    required this.icon,
    this.routeName,
  });

  final String id;
  final String label;
  final IconData icon;

  /// Named route to open, when the destination already exists. Utilities
  /// without a route fall back to the "coming soon" message.
  final String? routeName;

  @override
  List<Object?> get props => [id, label, icon, routeName];
}
