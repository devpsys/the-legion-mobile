import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/features/registration/presentation/widgets/staff/staff_shell.dart';

void main() {
  group('staffRegistrationBackTarget', () {
    test('leaves staff lists for the hub', () {
      expect(
        staffRegistrationBackTarget(Routes.staffRegistrationApprovals),
        Routes.homeName,
      );
      expect(
        staffRegistrationBackTarget(Routes.staffStudentRequests),
        Routes.homeName,
      );
      expect(
        staffRegistrationBackTarget(Routes.staffStudents),
        Routes.homeName,
      );
      expect(
        staffRegistrationBackTarget(Routes.staffIdCards),
        Routes.homeName,
      );
    });

    test('unwinds a course-form review to the approvals queue', () {
      expect(
        staffRegistrationBackTarget(
          Routes.staffRegistrationDecision('stu-chinedu'),
        ),
        Routes.staffRegistrationApprovalsName,
      );
    });

    test('unwinds study-plan advising to the approvals queue', () {
      expect(
        staffRegistrationBackTarget(
          Routes.staffStudyPlanAdvising('stu-chinedu'),
        ),
        Routes.staffRegistrationApprovalsName,
      );
    });

    test('unwinds a student record to the directory', () {
      expect(
        staffRegistrationBackTarget(Routes.staffStudentRecord('stu-chinedu')),
        Routes.staffStudentsName,
      );
    });

    test('unwinds an ID card preview to the production queue', () {
      expect(
        staffRegistrationBackTarget(Routes.staffIdCardPreview('ID-2026-0001')),
        Routes.staffIdCardsName,
      );
    });
  });
}
