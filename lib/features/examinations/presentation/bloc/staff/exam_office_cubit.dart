import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mock/staff/exam_office_fixtures.dart';
import '../../models/staff/exam_office_models.dart';
import 'exam_office_state.dart';

/// Drives the examinations office screens: marking, sessions and papers,
/// grading, incidents, resit windows and the broadsheet.
///
/// Presentation only — fixtures until the endpoints land. The ledger is
/// injected so tests can start the office in any state.
class ExamOfficeCubit extends Cubit<ExamOfficeState> {
  ExamOfficeCubit({ExamOfficeLedger? ledger})
    : _ledger = ledger ?? ExamOfficeFixtures.ledger,
      super(const ExamOfficeState());

  final ExamOfficeLedger _ledger;

  /// Loads the ledger once; later calls keep what the officer already did.
  void load() {
    if (state.status == ExamOfficeStatus.ready) return;
    emit(state.copyWith(status: ExamOfficeStatus.loading, clearFailure: true));
    emit(
      state.copyWith(
        status: ExamOfficeStatus.ready,
        officerName: _ledger.officerName,
        termLabels: _ledger.termLabels,
        selectedTerm: ExamOfficeFixtures.term,
        batches: _ledger.batches,
        sessions: _ledger.sessions,
        scales: _ledger.scales,
        probationCgpa: _ledger.probationCgpa,
        withdrawalCgpa: _ledger.withdrawalCgpa,
        overflowRooms: _ledger.overflowRooms,
        incidents: _ledger.incidents,
        importRows: _ledger.importRows,
        windows: _ledger.windows,
        broadsheets: _ledger.broadsheets,
        selectedBroadsheetCourse: _ledger.broadsheets.isEmpty
            ? ''
            : _ledger.broadsheets.first.courseCode,
        dossiers: _ledger.dossiers,
        clearFailure: true,
        clearNotice: true,
      ),
    );
  }

  void clearNotice() => emit(state.copyWith(clearNotice: true));

  // ---------------------------------------------------------------- results

  void setMarkFilter(MarkFilter filter) =>
      emit(state.copyWith(markFilter: filter));

  /// Records a student's coursework and examination marks on [batchId].
  ///
  /// A part that is `null` is cleared. Returns `false` when the batch is not
  /// open for marking or a part is out of range (coursework 0 to 30, final
  /// examination 0 to 70).
  bool setMarks(String batchId, String matric, {int? coursework, int? exam}) {
    final batch = state.batchById(batchId);
    if (batch == null || !batch.isEditable) return false;
    if (coursework != null &&
        (coursework < 0 || coursework > MarkingBatch.maxCoursework)) {
      return false;
    }
    if (exam != null && (exam < 0 || exam > MarkingBatch.maxExam)) {
      return false;
    }
    _replaceEntry(
      batch,
      matric,
      (entry) => entry.copyWith(
        coursework: coursework,
        exam: exam,
        clearCoursework: coursework == null,
        clearExam: exam == null,
      ),
    );
    return true;
  }

  /// Holds a student's mark back for [reason]; a held mark does not block
  /// sending the batch.
  bool holdMark(String batchId, String matric, String reason) {
    final batch = state.batchById(batchId);
    if (batch == null || !batch.isEditable || reason.trim().isEmpty) {
      return false;
    }
    _replaceEntry(
      batch,
      matric,
      (entry) => entry.copyWith(holdReason: reason.trim()),
    );
    emit(state.copyWith(notice: ExamOfficeNotice.markHeld));
    return true;
  }

  bool releaseHold(String batchId, String matric) {
    final batch = state.batchById(batchId);
    if (batch == null || !batch.isEditable) return false;
    _replaceEntry(batch, matric, (entry) => entry.copyWith(clearHold: true));
    emit(state.copyWith(notice: ExamOfficeNotice.holdReleased));
    return true;
  }

  /// Sends [batchId] to the approvers. The marks are fixed from then on.
  ///
  /// Refused while any student has no mark and no reason for none: the batch
  /// stays with the officer and the screen shows who is missing.
  bool sendForApproval(String batchId) {
    final batch = state.batchById(batchId);
    if (batch == null || !batch.isEditable) return false;
    if (batch.unmarkedCount > 0) {
      emit(
        state.copyWith(
          blockedSendBatchId: batchId,
          notice: ExamOfficeNotice.sendBlocked,
        ),
      );
      return false;
    }
    _replaceBatch(batch.copyWith(stage: ResultsStage.withApprovers));
    emit(
      state.copyWith(
        clearBlockedSend: true,
        notice: ExamOfficeNotice.sentForApproval,
      ),
    );
    return true;
  }

  void _replaceEntry(
    MarkingBatch batch,
    String matric,
    StudentMark Function(StudentMark entry) change,
  ) {
    _replaceBatch(
      batch.copyWith(
        entries: [
          for (final entry in batch.entries)
            entry.matric == matric ? change(entry) : entry,
        ],
      ),
    );
    // A mark changed, so any earlier refusal to send is stale.
    emit(state.copyWith(clearBlockedSend: true));
  }

  void _replaceBatch(MarkingBatch batch) {
    emit(
      state.copyWith(
        batches: [
          for (final entry in state.batches)
            entry.id == batch.id ? batch : entry,
        ],
      ),
    );
  }

  // --------------------------------------------------------------- sessions

  void selectTerm(String term) => emit(state.copyWith(selectedTerm: term));

  /// Opens a session in the draft's semester.
  ///
  /// Returns the problems with the form; the session is only opened when
  /// there are none.
  Set<SessionDraftError> openSession(SessionDraft draft) {
    final errors = draft.validate();
    if (errors.isNotEmpty) return errors;

    final session = ExamSession(
      id: 'ses-${draft.termLabel}-${state.sessions.length + 1}',
      name: draft.name.trim(),
      termLabel: draft.termLabel,
      startsOn: draft.startsOn!,
      endsOn: draft.endsOn!,
      cardsOpenOn: draft.cardsOpenOn!,
      status: SessionStatus.scheduled,
    );
    emit(
      state.copyWith(
        sessions: [...state.sessions, session],
        selectedTerm: draft.termLabel,
        notice: ExamOfficeNotice.sessionOpened,
      ),
    );
    return errors;
  }

  /// Withdraws an issued card. Needs a reason; the check fails from then on.
  bool withdrawCard(String sessionId, String matric, String reason) {
    final session = state.sessionById(sessionId);
    if (session == null) return false;
    if (reason.trim().isEmpty) {
      emit(state.copyWith(notice: ExamOfficeNotice.cardReasonRequired));
      return false;
    }
    _replaceSession(
      session.copyWith(
        issuedCards: [
          for (final card in session.issuedCards)
            card.matric == matric ? card.withdrawn(reason.trim()) : card,
        ],
      ),
    );
    emit(state.copyWith(notice: ExamOfficeNotice.cardWithdrawn));
    return true;
  }

  /// Adds [roomName] to a paper short of seats and seats as many of the
  /// unseated candidates as the room holds. Nobody already seated moves.
  bool addRoom(String sessionId, String paperId, String roomName) {
    final session = state.sessionById(sessionId);
    final paper = session?.paperById(paperId);
    if (session == null || paper == null || paper.unseated <= 0) return false;
    OverflowRoom? room;
    for (final candidate in state.overflowRooms) {
      if (candidate.name == roomName) room = candidate;
    }
    if (room == null || paper.rooms.any((entry) => entry.name == roomName)) {
      return false;
    }
    final seats = room.capacity < paper.unseated
        ? room.capacity
        : paper.unseated;
    _replacePaper(
      session,
      paper.copyWith(
        rooms: [
          ...paper.rooms,
          PaperRoom(name: room.name, seated: seats),
        ],
      ),
    );
    emit(state.copyWith(notice: ExamOfficeNotice.roomAdded));
    return true;
  }

  /// Moves a paper to [status].
  ///
  /// A paper that has been sat cannot be cancelled, and cancelling needs a
  /// reason.
  bool setPaperStatus(
    String sessionId,
    String paperId,
    PaperStatus status, {
    String reason = '',
  }) {
    final session = state.sessionById(sessionId);
    final paper = session?.paperById(paperId);
    if (session == null || paper == null) return false;

    if (status == PaperStatus.cancelled) {
      if (!paper.isCancellable) {
        emit(state.copyWith(notice: ExamOfficeNotice.cancelLocked));
        return false;
      }
      if (reason.trim().isEmpty) {
        emit(state.copyWith(notice: ExamOfficeNotice.cancelReasonRequired));
        return false;
      }
    }
    _replacePaper(
      session,
      paper.copyWith(
        status: status,
        cancelReason: status == PaperStatus.cancelled ? reason.trim() : null,
      ),
    );
    emit(state.copyWith(notice: ExamOfficeNotice.paperUpdated));
    return true;
  }

  void _replacePaper(ExamSession session, ExamPaper paper) {
    _replaceSession(
      session.copyWith(
        papers: [
          for (final entry in session.papers)
            entry.id == paper.id ? paper : entry,
        ],
      ),
    );
  }

  void _replaceSession(ExamSession session) {
    emit(
      state.copyWith(
        sessions: [
          for (final entry in state.sessions)
            entry.id == session.id ? session : entry,
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- grading

  /// Saves the CGPAs that put a student on probation and advise withdrawal.
  /// The withdrawal CGPA must be lower than the probation one.
  bool saveThresholds({required double probation, required double withdrawal}) {
    if (withdrawal <= 0 || probation <= withdrawal || probation > 5) {
      emit(state.copyWith(notice: ExamOfficeNotice.thresholdsInvalid));
      return false;
    }
    emit(
      state.copyWith(
        probationCgpa: probation,
        withdrawalCgpa: withdrawal,
        notice: ExamOfficeNotice.thresholdsSaved,
      ),
    );
    return true;
  }

  // -------------------------------------------------------------- incidents

  void setIncidentStatusFilter(IncidentStatus? status) {
    emit(
      state.copyWith(
        incidentStatusFilter: status,
        clearIncidentStatusFilter: status == null,
      ),
    );
  }

  void setIncidentKindFilter(IncidentKind? kind) {
    emit(
      state.copyWith(
        incidentKindFilter: kind,
        clearIncidentKindFilter: kind == null,
      ),
    );
  }

  /// Closes an incident and releases the mark it holds.
  ///
  /// Refused when the course's results are already with the approvers: the
  /// mark cannot be released from here.
  bool closeIncident(String incidentId) {
    final incident = state.incidentById(incidentId);
    if (incident == null || !incident.isOpen) return false;
    if (incident.holdsMark && state.isResultLocked(incident.courseCode)) {
      emit(state.copyWith(notice: ExamOfficeNotice.releaseLocked));
      return false;
    }
    _replaceIncident(
      incident.copyWith(status: IncidentStatus.closed, holdsMark: false),
    );
    emit(state.copyWith(notice: ExamOfficeNotice.incidentClosed));
    return true;
  }

  /// Refers an incident to a disciplinary panel. The mark stays held.
  bool referIncident(String incidentId) {
    final incident = state.incidentById(incidentId);
    if (incident == null || !incident.isOpen) return false;
    if (incident.status == IncidentStatus.referred) return false;
    _replaceIncident(
      incident.copyWith(
        status: IncidentStatus.referred,
        disciplineRef:
            'DCM-2026-00${incident.id.substring(incident.id.length - 2)}',
      ),
    );
    emit(state.copyWith(notice: ExamOfficeNotice.incidentReferred));
    return true;
  }

  void _replaceIncident(ExamIncident incident) {
    emit(
      state.copyWith(
        incidents: [
          for (final entry in state.incidents)
            entry.id == incident.id ? incident : entry,
        ],
      ),
    );
  }

  /// Works out what importing the batch would do. Nothing is written.
  void runImportDryRun() {
    emit(
      state.copyWith(
        importReport: dryRunIncidentImport(
          rows: state.importRows,
          existing: state.incidents,
          paperCourseCodes: state.paperCourseCodes,
          knownMatrics: state.knownMatrics,
        ),
        importStatus: ImportStatus.dryRun,
      ),
    );
  }

  /// Writes the rows the dry run said to import, attached or not.
  bool commitImport() {
    if (state.importStatus != ImportStatus.dryRun) return false;
    var next = state.incidents.length + 200;
    final added = <ExamIncident>[];
    for (final report in state.importReport) {
      final kind = report.kind;
      if (report.action == ImportAction.leave || kind == null) continue;
      final attached = report.action == ImportAction.importIt;
      added.add(
        ExamIncident(
          id: 'EI-2026-${(next++).toString().padLeft(5, '0')}',
          kind: kind,
          status: IncidentStatus.reported,
          courseCode: report.row.courseCode,
          sittingAt: DateTime(2026, 12, 9, 9),
          hall: report.row.time,
          description: report.row.description,
          matric: attached ? report.row.subject : null,
          holdsMark:
              attached &&
              (kind == IncidentKind.malpractice ||
                  kind == IncidentKind.absence),
        ),
      );
    }
    emit(
      state.copyWith(
        incidents: [...state.incidents, ...added],
        importStatus: ImportStatus.imported,
        notice: ExamOfficeNotice.importDone,
      ),
    );
    return true;
  }

  void resetImport() {
    emit(
      state.copyWith(importReport: const [], importStatus: ImportStatus.idle),
    );
  }

  // ----------------------------------------------------------------- resits

  /// Opens a resit window.
  ///
  /// Returns the problems with the form; the window is only opened when
  /// there are none.
  Set<ResitDraftError> openResitWindow(ResitWindowDraft draft) {
    final errors = draft.validate();
    if (errors.isNotEmpty) return errors;

    final window = ResitWindow(
      id: 'rw-${state.windows.length + 1}',
      name: draft.name.trim(),
      opensOn: draft.opensOn!,
      closesOn: draft.closesOn!,
      feePerUnitMinorUnits: draft.feePerUnitMinorUnits!,
      unitCap: draft.unitCap,
      isOpen: true,
      registeredCount: 0,
    );
    emit(
      state.copyWith(
        windows: [window, ...state.windows],
        notice: ExamOfficeNotice.windowOpened,
      ),
    );
    return errors;
  }

  /// Cancels one registration; any fee paid goes back to the student.
  bool cancelResitRegistration(String windowId, String signupId) {
    final window = state.windowById(windowId);
    if (window == null || !window.signups.any((s) => s.id == signupId)) {
      return false;
    }
    emit(
      state.copyWith(
        windows: [
          for (final entry in state.windows)
            entry.id == windowId
                ? entry.copyWith(
                    registeredCount: entry.registeredCount - 1,
                    signups: [
                      for (final signup in entry.signups)
                        if (signup.id != signupId) signup,
                    ],
                  )
                : entry,
        ],
        notice: ExamOfficeNotice.registrationCancelled,
      ),
    );
    return true;
  }

  // ------------------------------------------------------------- broadsheet

  void selectBroadsheetCourse(String courseCode) =>
      emit(state.copyWith(selectedBroadsheetCourse: courseCode));
}
