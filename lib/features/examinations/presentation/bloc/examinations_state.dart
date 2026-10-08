import 'package:equatable/equatable.dart';

import '../models/examinations_models.dart';

/// Loading status of the student Examinations & Results portal.
enum ExaminationsStatus { initial, loading, ready, failure }

/// One-off outcome the page tells the student about, then clears.
enum ExaminationsNotice { resitRegistered, resitWindowClosed, resitOverBudget }

/// State of the student Examinations & Results portal.
class ExaminationsState extends Equatable {
  const ExaminationsState({
    this.status = ExaminationsStatus.initial,
    this.student,
    this.sessionLabel = '',
    this.results,
    this.card,
    this.resits,
    this.notice,
    this.failureMessage,
  });

  final ExaminationsStatus status;
  final ExamStudent? student;

  /// The session pill's label, e.g. `2025/2026 • 2nd Sem`.
  final String sessionLabel;
  final ResultsRecord? results;
  final ExaminationCard? card;
  final ResitsRecord? resits;
  final ExaminationsNotice? notice;
  final String? failureMessage;

  ExaminationsState copyWith({
    ExaminationsStatus? status,
    ExamStudent? student,
    String? sessionLabel,
    ResultsRecord? results,
    ExaminationCard? card,
    ResitsRecord? resits,
    ExaminationsNotice? notice,
    String? failureMessage,
    bool clearNotice = false,
    bool clearFailure = false,
  }) {
    return ExaminationsState(
      status: status ?? this.status,
      student: student ?? this.student,
      sessionLabel: sessionLabel ?? this.sessionLabel,
      results: results ?? this.results,
      card: card ?? this.card,
      resits: resits ?? this.resits,
      notice: clearNotice ? null : notice ?? this.notice,
      failureMessage: clearFailure
          ? null
          : failureMessage ?? this.failureMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    student,
    sessionLabel,
    results,
    card,
    resits,
    notice,
    failureMessage,
  ];
}
