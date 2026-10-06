import 'package:equatable/equatable.dart';

import '../../../../../core/theme/app_tone.dart';
import '../registration_models.dart';

/// Standing filter on the students directory.
enum RegistryStandingFilter { any, active, suspended, withdrawn, expelled, graduated }

/// Tab on the ID card production queue.
enum IdCardQueueTab { requested, readyForCollection, collected }

/// Directory row for one matriculated student.
class RegistryStudentSummary extends Equatable {
  const RegistryStudentSummary({
    required this.id,
    required this.name,
    required this.matricNumber,
    required this.email,
    required this.programmeCode,
    required this.level,
    required this.standing,
    this.selected = false,
  });

  final String id;
  final String name;
  final String matricNumber;
  final String email;
  final String programmeCode;
  final int level;
  final StudentStanding standing;
  final bool selected;

  /// Graduated / withdrawn are modelled as standing extensions for directory.
  bool get isSelectable =>
      standing == StudentStanding.active ||
      standing == StudentStanding.suspended;

  RegistryStudentSummary copyWith({bool? selected}) {
    return RegistryStudentSummary(
      id: id,
      name: name,
      matricNumber: matricNumber,
      email: email,
      programmeCode: programmeCode,
      level: level,
      standing: standing,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    matricNumber,
    email,
    programmeCode,
    level,
    standing,
    selected,
  ];
}

/// Extended standing labels used on the directory (includes graduated/withdrawn).
enum RegistryDirectoryStatus {
  active,
  suspended,
  withdrawn,
  expelled,
  graduated,
}

extension RegistryDirectoryStatusX on RegistryDirectoryStatus {
  AppTone get tone => switch (this) {
    RegistryDirectoryStatus.active => AppTone.success,
    RegistryDirectoryStatus.suspended => AppTone.danger,
    RegistryDirectoryStatus.withdrawn => AppTone.neutral,
    RegistryDirectoryStatus.expelled => AppTone.danger,
    RegistryDirectoryStatus.graduated => AppTone.info,
  };
}

/// One student in the directory with registry-specific status.
class RegistryDirectoryStudent extends Equatable {
  const RegistryDirectoryStudent({
    required this.id,
    required this.name,
    required this.matricNumber,
    required this.email,
    required this.programmeCode,
    required this.level,
    required this.status,
    this.selected = false,
  });

  final String id;
  final String name;
  final String matricNumber;
  final String email;
  final String programmeCode;
  final int level;
  final RegistryDirectoryStatus status;
  final bool selected;

  bool get isSelectable =>
      status == RegistryDirectoryStatus.active ||
      status == RegistryDirectoryStatus.suspended;

  RegistryDirectoryStudent copyWith({bool? selected}) {
    return RegistryDirectoryStudent(
      id: id,
      name: name,
      matricNumber: matricNumber,
      email: email,
      programmeCode: programmeCode,
      level: level,
      status: status,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    matricNumber,
    email,
    programmeCode,
    level,
    status,
    selected,
  ];
}

/// Aggregate counts on the directory header.
class RegistryDirectoryStats extends Equatable {
  const RegistryDirectoryStats({
    required this.matriculated,
    required this.suspended,
    required this.withdrawn,
    required this.expelled,
    required this.graduated,
  });

  final int matriculated;
  final int suspended;
  final int withdrawn;
  final int expelled;
  final int graduated;

  @override
  List<Object?> get props => [
    matriculated,
    suspended,
    withdrawn,
    expelled,
    graduated,
  ];
}

/// Staff-facing student record dossier.
class RegistryStudentRecord extends Equatable {
  const RegistryStudentRecord({
    required this.id,
    required this.name,
    required this.matricNumber,
    required this.email,
    required this.programme,
    required this.department,
    required this.level,
    required this.standing,
    required this.degreePlanLabel,
    required this.entryLabel,
    required this.jambNumber,
    required this.matriculatedOn,
    required this.photoVerified,
    required this.registrationTerms,
    this.idReplacementFeeOwing = false,
  });

  final String id;
  final String name;
  final String matricNumber;
  final String email;
  final String programme;
  final String department;
  final int level;
  final StudentStanding standing;
  final String degreePlanLabel;
  final String entryLabel;
  final String jambNumber;
  final DateTime matriculatedOn;
  final bool photoVerified;
  final List<RegistryRegistrationTerm> registrationTerms;
  final bool idReplacementFeeOwing;

  bool get hasDegreePlan => degreePlanLabel.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    matricNumber,
    email,
    programme,
    department,
    level,
    standing,
    degreePlanLabel,
    entryLabel,
    jambNumber,
    matriculatedOn,
    photoVerified,
    registrationTerms,
    idReplacementFeeOwing,
  ];
}

class RegistryRegistrationTerm extends Equatable {
  const RegistryRegistrationTerm({
    required this.label,
    required this.level,
    required this.totalUnits,
    required this.confirmed,
    required this.courses,
    this.note = '',
  });

  final String label;
  final int level;
  final int totalUnits;
  final bool confirmed;
  final List<RegistryTermCourse> courses;
  final String note;

  @override
  List<Object?> get props => [
    label,
    level,
    totalUnits,
    confirmed,
    courses,
    note,
  ];
}

class RegistryTermCourse extends Equatable {
  const RegistryTermCourse({
    required this.code,
    required this.section,
    required this.title,
    required this.units,
    required this.status,
  });

  final String code;
  final String section;
  final String title;
  final int units;
  final CourseApprovalStatus status;

  @override
  List<Object?> get props => [code, section, title, units, status];
}

/// One card in the registry production queue.
class IdCardProductionItem extends Equatable {
  const IdCardProductionItem({
    required this.serial,
    required this.studentName,
    required this.matricNumber,
    required this.programmeCode,
    required this.reason,
    required this.status,
    required this.requestedOn,
    required this.feePayment,
    required this.feeMinorUnits,
    this.printedOn,
    this.hasPhoto = true,
  });

  final String serial;
  final String studentName;
  final String matricNumber;
  final String programmeCode;
  final IdCardReason reason;
  final IdCardStatus status;
  final DateTime requestedOn;
  final IdCardFeePayment feePayment;
  final int feeMinorUnits;
  final DateTime? printedOn;
  final bool hasPhoto;

  bool get canMarkPrinted =>
      status == IdCardStatus.requested &&
      feePayment != IdCardFeePayment.unpaid &&
      hasPhoto;

  bool get canCancel => status == IdCardStatus.requested;

  IdCardProductionItem copyWith({
    IdCardStatus? status,
    DateTime? printedOn,
    IdCardFeePayment? feePayment,
  }) {
    return IdCardProductionItem(
      serial: serial,
      studentName: studentName,
      matricNumber: matricNumber,
      programmeCode: programmeCode,
      reason: reason,
      status: status ?? this.status,
      requestedOn: requestedOn,
      feePayment: feePayment ?? this.feePayment,
      feeMinorUnits: feeMinorUnits,
      printedOn: printedOn ?? this.printedOn,
      hasPhoto: hasPhoto,
    );
  }

  @override
  List<Object?> get props => [
    serial,
    studentName,
    matricNumber,
    programmeCode,
    reason,
    status,
    requestedOn,
    feePayment,
    feeMinorUnits,
    printedOn,
    hasPhoto,
  ];
}

/// Print-preview dossier before / after Mark printed.
class IdCardPrintPreview extends Equatable {
  const IdCardPrintPreview({
    required this.serial,
    required this.studentName,
    required this.matricNumber,
    required this.programme,
    required this.department,
    required this.status,
    this.expiresOn,
    this.verificationCode,
    this.hasPhoto = true,
  });

  final String serial;
  final String studentName;
  final String matricNumber;
  final String programme;
  final String department;
  final IdCardStatus status;
  final DateTime? expiresOn;
  final String? verificationCode;
  final bool hasPhoto;

  bool get isPrinted =>
      status == IdCardStatus.printed || status == IdCardStatus.collected;

  IdCardPrintPreview copyWith({
    IdCardStatus? status,
    DateTime? expiresOn,
    String? verificationCode,
  }) {
    return IdCardPrintPreview(
      serial: serial,
      studentName: studentName,
      matricNumber: matricNumber,
      programme: programme,
      department: department,
      status: status ?? this.status,
      expiresOn: expiresOn ?? this.expiresOn,
      verificationCode: verificationCode ?? this.verificationCode,
      hasPhoto: hasPhoto,
    );
  }

  @override
  List<Object?> get props => [
    serial,
    studentName,
    matricNumber,
    programme,
    department,
    status,
    expiresOn,
    verificationCode,
    hasPhoto,
  ];
}

/// Public ID card verification outcome (five fields only when valid).
enum IdCardVerificationOutcome { idle, valid, invalid, notFound }

class IdCardVerificationResult extends Equatable {
  const IdCardVerificationResult({
    required this.outcome,
    this.name = '',
    this.matricNumber = '',
    this.programme = '',
    this.cardSerial = '',
    this.expiresOn,
  });

  final IdCardVerificationOutcome outcome;
  final String name;
  final String matricNumber;
  final String programme;
  final String cardSerial;
  final DateTime? expiresOn;

  @override
  List<Object?> get props => [
    outcome,
    name,
    matricNumber,
    programme,
    cardSerial,
    expiresOn,
  ];
}
