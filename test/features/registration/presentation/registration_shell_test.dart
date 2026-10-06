import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/core/router/route_names.dart';
import 'package:the_legion_mobile/features/registration/presentation/widgets/registration_shell.dart';

void main() {
  group('registrationBackTarget', () {
    test('leaves the portal from the Registration tab', () {
      expect(registrationBackTarget(Routes.registration), Routes.homeName);
    });

    test('unwinds sibling tabs to Registration', () {
      expect(
        registrationBackTarget(Routes.registrationStudyPlan),
        Routes.registrationName,
      );
      expect(
        registrationBackTarget(Routes.registrationForm),
        Routes.registrationName,
      );
      expect(
        registrationBackTarget(Routes.registrationRequests),
        Routes.registrationName,
      );
    });

    test('unwinds the ID card screen to Requests', () {
      expect(
        registrationBackTarget(Routes.registrationIdCard),
        Routes.registrationRequestsName,
      );
    });
  });
}
