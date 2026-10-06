import 'package:flutter_test/flutter_test.dart';
import 'package:the_legion_mobile/features/registration/presentation/mock/registration_fixtures.dart';
import 'package:the_legion_mobile/features/registration/presentation/models/registration_models.dart';

void main() {
  group('RegistrationFixtures.ledger', () {
    test('counts only courses that still sit on the form', () {
      final ledger = RegistrationFixtures.ledger;

      expect(ledger.registeredUnits, 15);
      expect(ledger.pendingCount, 2);
      expect(ledger.meetsMinimum, isTrue);
      expect(ledger.canSubmitForm, isFalse);
    });

    test('afterSubmit flips the form status and keeps the courses', () {
      final next = RegistrationFixtures.afterSubmit(
        RegistrationFixtures.ledger,
      );

      expect(next.formStatus, CourseFormStatus.submitted);
      expect(next.forms, hasLength(1));
      expect(next.forms.first.totalUnits, 15);
      expect(next.declarationAccepted, isTrue);
    });
  });

  group('CourseApprovalStatus', () {
    test('dropped and rejected do not count toward units', () {
      expect(CourseApprovalStatus.dropped.countsTowardUnits, isFalse);
      expect(CourseApprovalStatus.rejected.countsTowardUnits, isFalse);
      expect(CourseApprovalStatus.clashAccepted.countsTowardUnits, isTrue);
    });
  });

  group('IdCardRecord', () {
    test('default fixture has an unpaid in-progress request', () {
      final card = RegistrationFixtures.idCard;
      expect(card.activeRequest?.status, IdCardStatus.requested);
      expect(card.activeRequest?.feePayment, IdCardFeePayment.unpaid);
      expect(card.canSubmitRequest, isFalse);
      expect(card.submitLock, IdCardSubmitLock.activeRequest);
    });

    test('photo lock blocks submit until approved', () {
      final card = RegistrationFixtures.idCardPhotoLocked.copyWith(
        draftReason: IdCardReason.lostOrStolen,
      );
      expect(card.submitLock, IdCardSubmitLock.photo);
      expect(card.canSubmitRequest, isFalse);
    });

    test('printed status is ready for collection', () {
      final active = RegistrationFixtures.idCardReadyForCollection.activeRequest;
      expect(active?.isReadyForCollection, isTrue);
      expect(active?.status, IdCardStatus.printed);
    });

    test('first issue is free and submittable with a reason', () {
      final card = RegistrationFixtures.idCardFirstIssue;
      expect(card.isFirstIssue, isTrue);
      expect(card.canSubmitRequest, isTrue);
    });
  });
}
