import 'package:flutter_bloc/flutter_bloc.dart';

import '../../mock/staff/registry_fixtures.dart';
import '../../models/registration_models.dart';
import '../../models/staff/registry_models.dart';
import 'registry_state.dart';

/// Drives registry directory, student record, and ID card production.
///
/// Presentation only. Routes are registered for the future staff portal and
/// are not linked from the student hub.
class RegistryCubit extends Cubit<RegistryState> {
  RegistryCubit() : super(const RegistryState());

  void load() {
    if (state.status == RegistryStatus.ready) return;
    emit(state.copyWith(status: RegistryStatus.loading, clearFailure: true));
    emit(
      state.copyWith(
        status: RegistryStatus.ready,
        stats: RegistryFixtures.stats,
        students: RegistryFixtures.students,
        idCards: RegistryFixtures.idCards,
        clearFailure: true,
      ),
    );
  }

  void setQuery(String value) {
    if (state.query == value) return;
    emit(state.copyWith(query: value));
  }

  void setStatusFilter(RegistryDirectoryStatus? status) {
    if (status == null) {
      emit(state.copyWith(clearStatusFilter: true));
      return;
    }
    emit(state.copyWith(statusFilter: status));
  }

  void toggleSelected(String studentId) {
    final students = state.students.map((student) {
      if (student.id != studentId || !student.isSelectable) return student;
      return student.copyWith(selected: !student.selected);
    }).toList(growable: false);
    emit(state.copyWith(students: students));
  }

  void requestBatchPromote() {
    if (state.selectedCount == 0) return;
    emit(
      state.copyWith(
        sheet: RegistrySheet.batchPromote,
        promoteLevel: 400,
      ),
    );
  }

  void setPromoteLevel(int level) {
    emit(state.copyWith(promoteLevel: level));
  }

  void confirmBatchPromote() {
    final level = state.promoteLevel;
    emit(state.copyWith(clearSheet: true));
    if (level == null) return;
    final students = state.students.map((student) {
      if (!student.selected) return student;
      return RegistryDirectoryStudent(
        id: student.id,
        name: student.name,
        matricNumber: student.matricNumber,
        email: student.email,
        programmeCode: student.programmeCode,
        level: level,
        status: student.status,
      );
    }).toList(growable: false);
    emit(state.copyWith(students: students));
  }

  void cancelSheet() => emit(state.copyWith(clearSheet: true));

  void openRecord(String studentId) {
    emit(state.copyWith(record: RegistryFixtures.recordFor(studentId)));
  }

  void setIdCardTab(IdCardQueueTab tab) {
    if (state.idCardTab == tab) return;
    emit(state.copyWith(idCardTab: tab));
  }

  void openPreview(String serial) {
    emit(state.copyWith(preview: RegistryFixtures.previewFor(serial)));
  }

  bool markPrinted(String serial) {
    IdCardProductionItem? item;
    for (final card in state.idCards) {
      if (card.serial == serial) {
        item = card;
        break;
      }
    }
    if (item == null || !item.canMarkPrinted) return false;
    final printedOn = DateTime(2026, 10, 6);
    final cards = state.idCards.map((card) {
      if (card.serial != serial) return card;
      return card.copyWith(status: IdCardStatus.printed, printedOn: printedOn);
    }).toList(growable: false);
    final preview = state.preview?.serial == serial
        ? state.preview!.copyWith(
            status: IdCardStatus.printed,
            expiresOn: DateTime(2030, 10, 6),
            verificationCode: 'A1B2C3D4E5F6G7H8',
          )
        : state.preview;
    emit(state.copyWith(idCards: cards, preview: preview));
    return true;
  }

  bool markCollected(String serial) {
    final cards = state.idCards.map((card) {
      if (card.serial != serial || card.status != IdCardStatus.printed) {
        return card;
      }
      return card.copyWith(status: IdCardStatus.collected);
    }).toList(growable: false);
    emit(state.copyWith(idCards: cards));
    return true;
  }

  void requestCancelIdCard(String serial) {
    emit(
      state.copyWith(
        sheet: RegistrySheet.cancelIdCard,
        sheetId: serial,
        cancelDraft: '',
      ),
    );
  }

  void setCancelDraft(String value) {
    emit(state.copyWith(cancelDraft: value));
  }

  bool confirmCancelIdCard() {
    final serial = state.sheetId;
    final reason = state.cancelDraft.trim();
    emit(state.copyWith(clearSheet: true));
    if (serial == null || reason.isEmpty) return false;
    final cards = state.idCards
        .where((card) => card.serial != serial)
        .toList(growable: false);
    emit(state.copyWith(idCards: cards));
    return true;
  }
}
