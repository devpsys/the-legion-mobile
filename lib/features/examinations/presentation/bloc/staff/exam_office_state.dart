import 'package:equatable/equatable.dart';

import '../../models/staff/exam_office_models.dart';

/// Loading status of the examinations office screens.
enum ExamOfficeStatus { initial, loading, ready, failure }

/// One-off outcome the screen tells the officer about, then clears.
enum ExamOfficeNotice {
  sentForApproval,
  sendBlocked,
  markHeld,
  holdReleased,
  sessionOpened,
  cardWithdrawn,
  cardReasonRequired,
  roomAdded,
  paperUpdated,
  cancelLocked,
  cancelReasonRequired,
  thresholdsSaved,
  thresholdsInvalid,
  importDone,
  incidentClosed,
  incidentReferred,
  releaseLocked,
  windowOpened,
  registrationCancelled,
}

/// State of the examinations office screens.
class ExamOfficeState extends Equatable {
  const ExamOfficeState({
    this.status = ExamOfficeStatus.initial,
    this.officerName = '',
    this.termLabels = const [],
    this.selectedTerm = '',
    this.batches = const [],
    this.markFilter = MarkFilter.all,
    this.blockedSendBatchId,
    this.sessions = const [],
    this.scales = const [],
    this.probationCgpa = 0,
    this.withdrawalCgpa = 0,
    this.overflowRooms = const [],
    this.incidents = const [],
    this.incidentStatusFilter,
    this.incidentKindFilter,
    this.importRows = const [],
    this.importReport = const [],
    this.importStatus = ImportStatus.idle,
    this.windows = const [],
    this.broadsheets = const [],
    this.selectedBroadsheetCourse = '',
    this.dossiers = const [],
    this.notice,
    this.failureMessage,
  });

  final ExamOfficeStatus status;
  final String officerName;
  final List<String> termLabels;
  final String selectedTerm;
  final List<MarkingBatch> batches;
  final MarkFilter markFilter;

  /// The batch the officer tried to send while marks were missing.
  final String? blockedSendBatchId;
  final List<ExamSession> sessions;
  final List<GradingScale> scales;
  final double probationCgpa;
  final double withdrawalCgpa;
  final List<OverflowRoom> overflowRooms;
  final List<ExamIncident> incidents;
  final IncidentStatus? incidentStatusFilter;
  final IncidentKind? incidentKindFilter;
  final List<ImportRow> importRows;
  final List<ImportRowReport> importReport;
  final ImportStatus importStatus;
  final List<ResitWindow> windows;
  final List<CourseBroadsheet> broadsheets;
  final String selectedBroadsheetCourse;
  final List<StudentDossier> dossiers;
  final ExamOfficeNotice? notice;
  final String? failureMessage;

  MarkingBatch? batchById(String id) {
    for (final batch in batches) {
      if (batch.id == id) return batch;
    }
    return null;
  }

  /// Sessions of the selected semester.
  List<ExamSession> get sessionsForTerm => [
    for (final session in sessions)
      if (session.termLabel == selectedTerm) session,
  ];

  ExamSession? sessionById(String id) {
    for (final session in sessions) {
      if (session.id == id) return session;
    }
    return null;
  }

  GradingScale? scaleById(String id) {
    for (final scale in scales) {
      if (scale.id == id) return scale;
    }
    return null;
  }

  /// The scale marks are graded by.
  GradingScale? get defaultScale {
    for (final scale in scales) {
      if (scale.isDefault) return scale;
    }
    return null;
  }

  /// The letter [total] earns on the default scale, or `null` when it has no
  /// total or the scale has no band for it.
  String? gradeFor(int? total) {
    if (total == null) return null;
    return defaultScale?.bandFor(total)?.letter;
  }

  ExamIncident? incidentById(String id) {
    for (final incident in incidents) {
      if (incident.id == id) return incident;
    }
    return null;
  }

  /// Incidents under the status and kind filters, newest sitting first.
  List<ExamIncident> get visibleIncidents {
    final shown = [
      for (final incident in incidents)
        if ((incidentStatusFilter == null ||
                incident.status == incidentStatusFilter) &&
            (incidentKindFilter == null || incident.kind == incidentKindFilter))
          incident,
    ]..sort((a, b) => b.sittingAt.compareTo(a.sittingAt));
    return shown;
  }

  /// Open incidents that are holding a mark back.
  int get holdingIncidentCount => incidents
      .where((incident) => incident.isOpen && incident.holdsMark)
      .length;

  /// The marks of [courseCode] are with the approvers or published, so a
  /// mark held for it cannot be released from here.
  bool isResultLocked(String courseCode) {
    for (final batch in batches) {
      if (batch.courseCode == courseCode &&
          (batch.stage == ResultsStage.withApprovers ||
              batch.stage == ResultsStage.published)) {
        return true;
      }
    }
    return false;
  }

  ResitWindow? windowById(String id) {
    for (final window in windows) {
      if (window.id == id) return window;
    }
    return null;
  }

  CourseBroadsheet? get currentBroadsheet {
    for (final sheet in broadsheets) {
      if (sheet.courseCode == selectedBroadsheetCourse) return sheet;
    }
    return broadsheets.isEmpty ? null : broadsheets.first;
  }

  StudentDossier? dossierFor(String matric) {
    for (final dossier in dossiers) {
      if (dossier.matric == matric) return dossier;
    }
    return null;
  }

  /// Every course code any session has a paper for.
  Set<String> get paperCourseCodes => {
    for (final session in sessions)
      for (final paper in session.papers) paper.courseCode,
  };

  /// Every matric number the office's records name.
  Set<String> get knownMatrics => {
    for (final batch in batches)
      for (final entry in batch.entries) entry.matric,
    for (final dossier in dossiers) dossier.matric,
    for (final incident in incidents)
      if (incident.matric != null) incident.matric!,
  };

  ExamOfficeState copyWith({
    ExamOfficeStatus? status,
    String? officerName,
    List<String>? termLabels,
    String? selectedTerm,
    List<MarkingBatch>? batches,
    MarkFilter? markFilter,
    String? blockedSendBatchId,
    List<ExamSession>? sessions,
    List<GradingScale>? scales,
    double? probationCgpa,
    double? withdrawalCgpa,
    List<OverflowRoom>? overflowRooms,
    List<ExamIncident>? incidents,
    IncidentStatus? incidentStatusFilter,
    IncidentKind? incidentKindFilter,
    List<ImportRow>? importRows,
    List<ImportRowReport>? importReport,
    ImportStatus? importStatus,
    List<ResitWindow>? windows,
    List<CourseBroadsheet>? broadsheets,
    String? selectedBroadsheetCourse,
    List<StudentDossier>? dossiers,
    ExamOfficeNotice? notice,
    String? failureMessage,
    bool clearBlockedSend = false,
    bool clearIncidentStatusFilter = false,
    bool clearIncidentKindFilter = false,
    bool clearNotice = false,
    bool clearFailure = false,
  }) {
    return ExamOfficeState(
      status: status ?? this.status,
      officerName: officerName ?? this.officerName,
      termLabels: termLabels ?? this.termLabels,
      selectedTerm: selectedTerm ?? this.selectedTerm,
      batches: batches ?? this.batches,
      markFilter: markFilter ?? this.markFilter,
      blockedSendBatchId: clearBlockedSend
          ? null
          : blockedSendBatchId ?? this.blockedSendBatchId,
      sessions: sessions ?? this.sessions,
      scales: scales ?? this.scales,
      probationCgpa: probationCgpa ?? this.probationCgpa,
      withdrawalCgpa: withdrawalCgpa ?? this.withdrawalCgpa,
      overflowRooms: overflowRooms ?? this.overflowRooms,
      incidents: incidents ?? this.incidents,
      incidentStatusFilter: clearIncidentStatusFilter
          ? null
          : incidentStatusFilter ?? this.incidentStatusFilter,
      incidentKindFilter: clearIncidentKindFilter
          ? null
          : incidentKindFilter ?? this.incidentKindFilter,
      importRows: importRows ?? this.importRows,
      importReport: importReport ?? this.importReport,
      importStatus: importStatus ?? this.importStatus,
      windows: windows ?? this.windows,
      broadsheets: broadsheets ?? this.broadsheets,
      selectedBroadsheetCourse:
          selectedBroadsheetCourse ?? this.selectedBroadsheetCourse,
      dossiers: dossiers ?? this.dossiers,
      notice: clearNotice ? null : notice ?? this.notice,
      failureMessage: clearFailure
          ? null
          : failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    officerName,
    termLabels,
    selectedTerm,
    batches,
    markFilter,
    blockedSendBatchId,
    sessions,
    scales,
    probationCgpa,
    withdrawalCgpa,
    overflowRooms,
    incidents,
    incidentStatusFilter,
    incidentKindFilter,
    importRows,
    importReport,
    importStatus,
    windows,
    broadsheets,
    selectedBroadsheetCourse,
    dossiers,
    notice,
    failureMessage,
  ];
}
