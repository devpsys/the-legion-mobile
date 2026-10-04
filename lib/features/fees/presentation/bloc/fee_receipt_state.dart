import 'package:equatable/equatable.dart';

import '../models/fees_models.dart';

/// Status of loading one official receipt.
enum FeeReceiptLoadStatus { initial, loading, ready, notFound }

/// State of the official receipt screen.
class FeeReceiptState extends Equatable {
  const FeeReceiptState({
    this.loadStatus = FeeReceiptLoadStatus.initial,
    this.receipt,
  });

  final FeeReceiptLoadStatus loadStatus;

  final OfficialReceipt? receipt;

  FeeReceiptState copyWith({
    FeeReceiptLoadStatus? loadStatus,
    OfficialReceipt? receipt,
    bool clearReceipt = false,
  }) {
    return FeeReceiptState(
      loadStatus: loadStatus ?? this.loadStatus,
      receipt: clearReceipt ? null : (receipt ?? this.receipt),
    );
  }

  @override
  List<Object?> get props => [loadStatus, receipt];
}
