import '../../../../core/l10n/gen/app_localizations.dart';
import '../../../../core/theme/app_tone.dart';
import '../models/examinations_models.dart';

/// Words and tones for the student examinations enums, in one place so every
/// screen says "held back" and "withdrawn" the same way.
abstract final class ExaminationsLabels {
  static String standing(AppLocalizations l10n, StandingKind kind) {
    return switch (kind) {
      StandingKind.good => l10n.examStandingGood,
      StandingKind.probation => l10n.examStandingProbation,
      StandingKind.withdrawalRisk => l10n.examStandingWithdrawal,
    };
  }

  static AppTone standingTone(StandingKind kind) {
    return switch (kind) {
      StandingKind.good => AppTone.success,
      StandingKind.probation => AppTone.warning,
      StandingKind.withdrawalRisk => AppTone.danger,
    };
  }

  static AppTone gradeTone(String? grade) {
    return switch (grade) {
      'A' || 'B' => AppTone.success,
      'C' || 'D' => AppTone.neutral,
      'E' => AppTone.warning,
      'F' => AppTone.danger,
      _ => AppTone.neutral,
    };
  }

  static String cardStatus(AppLocalizations l10n, CardStatus status) {
    return switch (status) {
      CardStatus.notIssued => l10n.examCardStatusNotIssued,
      CardStatus.issued => l10n.examCardStatusIssued,
      CardStatus.revoked => l10n.examCardStatusRevoked,
    };
  }

  static AppTone cardTone(CardStatus status) {
    return switch (status) {
      CardStatus.notIssued => AppTone.warning,
      CardStatus.issued => AppTone.success,
      CardStatus.revoked => AppTone.danger,
    };
  }

  static String gateTitle(AppLocalizations l10n, ClearanceGateId id) {
    return switch (id) {
      ClearanceGateId.fees => l10n.examGateFees,
      ClearanceGateId.standing => l10n.examGateStanding,
      ClearanceGateId.papers => l10n.examGatePapers,
      ClearanceGateId.schedule => l10n.examGateSchedule,
      ClearanceGateId.seats => l10n.examGateSeats,
    };
  }

  static String gateState(AppLocalizations l10n, GateState state) {
    return switch (state) {
      GateState.passed => l10n.examGatePassed,
      GateState.blocked => l10n.examGateBlocked,
      GateState.waiting => l10n.examGateWaiting,
    };
  }

  static AppTone gateTone(GateState state) {
    return switch (state) {
      GateState.passed => AppTone.success,
      GateState.blocked => AppTone.danger,
      GateState.waiting => AppTone.neutral,
    };
  }

  static String revokedReason(AppLocalizations l10n, CardRevokedReason reason) {
    return switch (reason) {
      CardRevokedReason.feeReversed => l10n.examRevokedFeeReversed,
    };
  }

  static String resitPayment(AppLocalizations l10n, ResitPaymentStatus status) {
    return switch (status) {
      ResitPaymentStatus.awaitingPayment => l10n.examResitAwaitingPayment,
      ResitPaymentStatus.paid => l10n.examResitPaid,
    };
  }

  static AppTone resitPaymentTone(ResitPaymentStatus status) {
    return switch (status) {
      ResitPaymentStatus.awaitingPayment => AppTone.warning,
      ResitPaymentStatus.paid => AppTone.success,
    };
  }
}
