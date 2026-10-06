import 'package:equatable/equatable.dart';

import '../../models/staff/approvals_models.dart';

enum StaffApprovalsStatus { initial, loading, ready, failure }

/// Confirmation sheets on staff approval screens.
enum StaffApprovalsSheet { rejectCourses, rejectRequest }

class StaffApprovalsState extends Equatable {
  const StaffApprovalsState({
    this.status = StaffApprovalsStatus.initial,
    this.queue = const [],
    this.queueFilter = ApprovalsQueueFilter.awaiting,
    this.review,
    this.requests = const [],
    this.requestFilter = RequestDecisionFilter.pending,
    this.advice,
    this.sheet,
    this.sheetId,
    this.failureMessage,
  });

  final StaffApprovalsStatus status;
  final List<ApprovalQueueItem> queue;
  final ApprovalsQueueFilter queueFilter;
  final StudentRegistrationReview? review;
  final List<RequestDecisionItem> requests;
  final RequestDecisionFilter requestFilter;
  final StudyPlanAdvice? advice;
  final StaffApprovalsSheet? sheet;
  final String? sheetId;
  final String? failureMessage;

  List<ApprovalQueueItem> get visibleQueue {
    return queue.where((item) {
      return switch (queueFilter) {
        ApprovalsQueueFilter.awaiting => !item.processed,
        ApprovalsQueueFilter.approved => item.processed,
        ApprovalsQueueFilter.all => true,
      };
    }).toList(growable: false);
  }

  List<RequestDecisionItem> get visibleRequests {
    return requests.where((item) {
      return switch (requestFilter) {
        RequestDecisionFilter.all => true,
        RequestDecisionFilter.pending => item.isPending,
        RequestDecisionFilter.decided => !item.isPending,
      };
    }).toList(growable: false);
  }

  int get awaitingFormCount => queue.where((i) => !i.processed).length;

  int get awaitingCourseCount => queue
      .where((i) => !i.processed)
      .fold(0, (sum, i) => sum + i.pendingCourseCount);

  StaffApprovalsState copyWith({
    StaffApprovalsStatus? status,
    List<ApprovalQueueItem>? queue,
    ApprovalsQueueFilter? queueFilter,
    StudentRegistrationReview? review,
    List<RequestDecisionItem>? requests,
    RequestDecisionFilter? requestFilter,
    StudyPlanAdvice? advice,
    StaffApprovalsSheet? sheet,
    String? sheetId,
    bool clearSheet = false,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return StaffApprovalsState(
      status: status ?? this.status,
      queue: queue ?? this.queue,
      queueFilter: queueFilter ?? this.queueFilter,
      review: review ?? this.review,
      requests: requests ?? this.requests,
      requestFilter: requestFilter ?? this.requestFilter,
      advice: advice ?? this.advice,
      sheet: clearSheet ? null : (sheet ?? this.sheet),
      sheetId: clearSheet ? null : (sheetId ?? this.sheetId),
      failureMessage: clearFailure
          ? null
          : (failureMessage ?? this.failureMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    queue,
    queueFilter,
    review,
    requests,
    requestFilter,
    advice,
    sheet,
    sheetId,
    failureMessage,
  ];
}
