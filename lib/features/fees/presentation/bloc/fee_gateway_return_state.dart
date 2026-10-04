import 'package:equatable/equatable.dart';

import '../models/fees_models.dart';

/// Status of loading one gateway-return visit.
enum FeeGatewayReturnLoadStatus { initial, loading, ready, notFound }

/// State of the gateway-return screen.
class FeeGatewayReturnState extends Equatable {
  const FeeGatewayReturnState({
    this.loadStatus = FeeGatewayReturnLoadStatus.initial,
    this.payment,
  });

  final FeeGatewayReturnLoadStatus loadStatus;

  /// Set once a reference resolves.
  final GatewayReturn? payment;

  GatewayReturnStatus? get status => payment?.status;

  bool get canViewReceipt =>
      payment != null &&
      payment!.status.hasReceipt &&
      payment!.receiptId != null;

  FeeGatewayReturnState copyWith({
    FeeGatewayReturnLoadStatus? loadStatus,
    GatewayReturn? payment,
    bool clearPayment = false,
  }) {
    return FeeGatewayReturnState(
      loadStatus: loadStatus ?? this.loadStatus,
      payment: clearPayment ? null : (payment ?? this.payment),
    );
  }

  @override
  List<Object?> get props => [loadStatus, payment];
}
