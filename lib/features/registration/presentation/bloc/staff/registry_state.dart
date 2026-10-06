import 'package:equatable/equatable.dart';

import '../../models/registration_models.dart';
import '../../models/staff/registry_models.dart';

enum RegistryStatus { initial, loading, ready, failure }

enum RegistrySheet { batchPromote, cancelIdCard }

class RegistryState extends Equatable {
  const RegistryState({
    this.status = RegistryStatus.initial,
    this.stats = const RegistryDirectoryStats(
      matriculated: 0,
      suspended: 0,
      withdrawn: 0,
      expelled: 0,
      graduated: 0,
    ),
    this.students = const [],
    this.query = '',
    this.statusFilter,
    this.record,
    this.idCards = const [],
    this.idCardTab = IdCardQueueTab.requested,
    this.preview,
    this.cancelDraft = '',
    this.promoteLevel,
    this.sheet,
    this.sheetId,
    this.failureMessage,
  });

  final RegistryStatus status;
  final RegistryDirectoryStats stats;
  final List<RegistryDirectoryStudent> students;
  final String query;
  final RegistryDirectoryStatus? statusFilter;
  final RegistryStudentRecord? record;
  final List<IdCardProductionItem> idCards;
  final IdCardQueueTab idCardTab;
  final IdCardPrintPreview? preview;
  final String cancelDraft;
  final int? promoteLevel;
  final RegistrySheet? sheet;
  final String? sheetId;
  final String? failureMessage;

  List<RegistryDirectoryStudent> get visibleStudents {
    final q = query.trim().toLowerCase();
    return students.where((student) {
      if (statusFilter != null && student.status != statusFilter) {
        return false;
      }
      if (q.isEmpty) return true;
      return student.name.toLowerCase().contains(q) ||
          student.matricNumber.toLowerCase().contains(q) ||
          student.email.toLowerCase().contains(q) ||
          student.programmeCode.toLowerCase().contains(q);
    }).toList(growable: false);
  }

  int get selectedCount => students.where((s) => s.selected).length;

  List<IdCardProductionItem> get visibleIdCards {
    return idCards.where((card) {
      return switch (idCardTab) {
        IdCardQueueTab.requested => card.status == IdCardStatus.requested,
        IdCardQueueTab.readyForCollection =>
          card.status == IdCardStatus.printed,
        IdCardQueueTab.collected => card.status == IdCardStatus.collected,
      };
    }).toList(growable: false);
  }

  int get requestedCount =>
      idCards.where((c) => c.status == IdCardStatus.requested).length;

  int get readyCount =>
      idCards.where((c) => c.status == IdCardStatus.printed).length;

  int get collectedCount =>
      idCards.where((c) => c.status == IdCardStatus.collected).length;

  RegistryState copyWith({
    RegistryStatus? status,
    RegistryDirectoryStats? stats,
    List<RegistryDirectoryStudent>? students,
    String? query,
    RegistryDirectoryStatus? statusFilter,
    bool clearStatusFilter = false,
    RegistryStudentRecord? record,
    List<IdCardProductionItem>? idCards,
    IdCardQueueTab? idCardTab,
    IdCardPrintPreview? preview,
    String? cancelDraft,
    int? promoteLevel,
    RegistrySheet? sheet,
    String? sheetId,
    bool clearSheet = false,
    String? failureMessage,
    bool clearFailure = false,
  }) {
    return RegistryState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      students: students ?? this.students,
      query: query ?? this.query,
      statusFilter: clearStatusFilter
          ? null
          : (statusFilter ?? this.statusFilter),
      record: record ?? this.record,
      idCards: idCards ?? this.idCards,
      idCardTab: idCardTab ?? this.idCardTab,
      preview: preview ?? this.preview,
      cancelDraft: cancelDraft ?? this.cancelDraft,
      promoteLevel: promoteLevel ?? this.promoteLevel,
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
    stats,
    students,
    query,
    statusFilter,
    record,
    idCards,
    idCardTab,
    preview,
    cancelDraft,
    promoteLevel,
    sheet,
    sheetId,
    failureMessage,
  ];
}
