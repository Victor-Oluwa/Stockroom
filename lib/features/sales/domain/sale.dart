import 'package:equatable/equatable.dart';

import '../../../core/notifications/transitions.dart';

/// Payment methods (PRD §6.7). Records how the customer says they paid;
/// no payment is processed.
const List<String> paymentMethods = ['Cash', 'Bank Transfer', 'Card', 'Other'];

/// One cart/checkout line before commit.
class SaleLineInput extends Equatable {
  const SaleLineInput({
    required this.productId,
    required this.quantityMilli,
    required this.unitPriceKobo,
    this.discountKobo = 0,
  });
  final String productId;
  final int quantityMilli;
  final int unitPriceKobo;
  final int discountKobo;

  @override
  List<Object?> get props => [
    productId,
    quantityMilli,
    unitPriceKobo,
    discountKobo,
  ];
}

class SaleResult extends Equatable {
  const SaleResult({
    required this.saleId,
    required this.saleNumber,
    required this.subtotalKobo,
    required this.discountTotalKobo,
    required this.totalKobo,
    this.transitions = const [],
  });
  final String saleId;
  final String saleNumber;
  final int subtotalKobo;
  final int discountTotalKobo;
  final int totalKobo;

  /// Stock alert crossings caused by this sale (PRD §6.9).
  final List<StockTransition> transitions;

  @override
  List<Object?> get props => [
    saleId,
    saleNumber,
    subtotalKobo,
    discountTotalKobo,
    totalKobo,
    transitions,
  ];
}

/// Immutable sale line snapshot for history/detail/receipts.
class SaleLineView extends Equatable {
  const SaleLineView({
    required this.id,
    required this.productId,
    required this.productName,
    this.sku,
    required this.unitLabel,
    required this.quantityMilli,
    required this.unitPriceKobo,
    required this.grossLineTotalKobo,
    required this.discountKobo,
    required this.netLineTotalKobo,
    required this.unitCostSnapshotKobo,
    required this.cogsTotalKobo,
  });
  final String id;
  final String productId;
  final String productName;
  final String? sku;
  final String unitLabel;
  final int quantityMilli;
  final int unitPriceKobo;
  final int grossLineTotalKobo;
  final int discountKobo;
  final int netLineTotalKobo;
  final int unitCostSnapshotKobo;
  final int cogsTotalKobo;

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    sku,
    unitLabel,
    quantityMilli,
    unitPriceKobo,
    grossLineTotalKobo,
    discountKobo,
    netLineTotalKobo,
    unitCostSnapshotKobo,
    cogsTotalKobo,
  ];
}
