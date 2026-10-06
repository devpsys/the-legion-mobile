import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mock/staff/approvals_fixtures.dart';
import '../../models/registration_models.dart';
import '../../models/staff/approvals_models.dart';
import 'staff_approvals_state.dart';

/// Drives HoD registration approvals, request decisions, and study-plan advice.
///
/// Presentation only — fixtures until the registry endpoints land. Not wired
/// into the student hub; routes exist for the future staff portal.
class StaffApprovalsCubit extends Cubit<StaffApprovalsState> {
  StaffApprovalsCubit() : super(const StaffApprovalsState());

  void load() {
    if (state.status == StaffApprovalsStatus.ready) return;
    emit(
      state.copyWith(status: StaffApprovalsStatus.loading, clearFailure: true),
    );
    emit(
      state.copyWith(
        status: StaffApprovalsStatus.ready,
        queue: ApprovalsFixtures.queue,
        requests: ApprovalsFixtures.requests,
        clearFailure: true,
      ),
    );
  }

  void setQueueFilter(ApprovalsQueueFilter filter) {
    if (state.queueFilter == filter) return;
    emit(state.copyWith(queueFilter: filter));
  }

  void openReview(String studentId) {
    emit(
      state.copyWith(
        review: ApprovalsFixtures.reviewFor(studentId),
        clearSheet: true,
      ),
    );
  }

  void toggleCourseSelected(String courseId) {
    final review = state.review;
    if (review == null || review.directDepartment) return;
    final courses = review.courses.map((course) {
      if (course.id != courseId || !course.isPending) return course;
      return course.copyWith(selected: !course.selected);
    }).toList(growable: false);
    emit(state.copyWith(review: review.copyWith(courses: courses)));
  }

  void selectAllPending() {
    final review = state.review;
    if (review == null || review.directDepartment) return;
    final courses = review.courses.map((course) {
      if (!course.isPending) return course;
      return course.copyWith(selected: true);
    }).toList(growable: false);
    emit(state.copyWith(review: review.copyWith(courses: courses)));
  }

  void setRejectDraft(String value) {
    final review = state.review;
    if (review == null) return;
    emit(state.copyWith(review: review.copyWith(rejectDraft: value)));
  }

  bool approveSelected() {
    final review = state.review;
    if (review == null || review.directDepartment) return false;
    final selected = review.selectedPending;
    if (selected.isEmpty) return false;
    final ids = selected.map((c) => c.id).toSet();
    final courses = review.courses.map((course) {
      if (!ids.contains(course.id)) return course;
      return course.copyWith(
        status: CourseApprovalStatus.approved,
        selected: false,
        decidedBy: ApprovalsFixtures.staffName,
        decidedOn: DateTime(2026, 10, 6),
      );
    }).toList(growable: false);
    emit(state.copyWith(review: review.copyWith(courses: courses)));
    return true;
  }

  void requestRejectSelected() {
    final review = state.review;
    if (review == null || review.selectedPending.isEmpty) return;
    emit(state.copyWith(sheet: StaffApprovalsSheet.rejectCourses));
  }

  bool confirmRejectSelected() {
    final review = state.review;
    emit(state.copyWith(clearSheet: true));
    if (review == null) return false;
    final reason = review.rejectDraft.trim();
    if (reason.isEmpty) return false;
    final ids = review.selectedPending.map((c) => c.id).toSet();
    if (ids.isEmpty) return false;
    final courses = review.courses.map((course) {
      if (!ids.contains(course.id)) return course;
      return course.copyWith(
        status: CourseApprovalStatus.rejected,
        selected: false,
        decidedBy: ApprovalsFixtures.staffName,
        decidedOn: DateTime(2026, 10, 6),
      );
    }).toList(growable: false);
    emit(
      state.copyWith(
        review: review.copyWith(courses: courses, rejectDraft: ''),
      ),
    );
    return true;
  }

  void cancelSheet() => emit(state.copyWith(clearSheet: true));

  void setRequestFilter(RequestDecisionFilter filter) {
    if (state.requestFilter == filter) return;
    emit(state.copyWith(requestFilter: filter));
  }

  void setRequestRejectDraft(String requestId, String value) {
    final updated = state.requests.map((item) {
      if (item.id != requestId) return item;
      return item.copyWith(rejectDraft: value);
    }).toList(growable: false);
    emit(state.copyWith(requests: updated));
  }

  bool approveRequest(String requestId) {
    return _setRequestStatus(requestId, approved: true, note: '');
  }

  bool requestRejectRequest(String requestId) {
    RequestDecisionItem? item;
    for (final request in state.requests) {
      if (request.id == requestId) {
        item = request;
        break;
      }
    }
    if (item == null || !item.isPending) return false;
    if (item.rejectDraft.trim().isEmpty) return false;
    emit(
      state.copyWith(
        sheet: StaffApprovalsSheet.rejectRequest,
        sheetId: requestId,
      ),
    );
    return true;
  }

  bool confirmRejectRequest() {
    final id = state.sheetId;
    emit(state.copyWith(clearSheet: true));
    if (id == null) return false;
    RequestDecisionItem? item;
    for (final request in state.requests) {
      if (request.id == id) {
        item = request;
        break;
      }
    }
    if (item == null) return false;
    final note = item.rejectDraft.trim();
    if (note.isEmpty) return false;
    return _setRequestStatus(id, approved: false, note: note);
  }

  bool _setRequestStatus(
    String requestId, {
    required bool approved,
    required String note,
  }) {
    var found = false;
    final updated = state.requests.map((item) {
      if (item.id != requestId || !item.isPending) return item;
      found = true;
      return item.copyWith(
        status: approved
            ? AcademicRequestStatus.approved
            : AcademicRequestStatus.rejected,
        decisionNote: approved ? 'Approved' : note,
        rejectDraft: '',
      );
    }).toList(growable: false);
    if (!found) return false;
    emit(state.copyWith(requests: updated));
    return true;
  }

  void openAdvice(String studentId) {
    emit(state.copyWith(advice: ApprovalsFixtures.chineduAdvice));
  }

  void setAdviceDraft(String value) {
    final advice = state.advice;
    if (advice == null) return;
    emit(state.copyWith(advice: advice.copyWith(adviceDraft: value)));
  }

  bool saveAdvice() {
    final advice = state.advice;
    if (advice == null || advice.adviceDraft.trim().isEmpty) return false;
    return true;
  }
}
