import 'package:equatable/equatable.dart';

/// A product that crossed into low/out-of-stock because of one write.
/// Emitted by sale/receipt/adjustment transactions so the UI can notify
/// exactly on transition — no repeats while the condition persists, and a
/// later replenish-then-dip notifies again (PRD §6.9).
class StockTransition extends Equatable {
  const StockTransition({
    required this.productId,
    required this.productName,
    required this.oldQtyMilli,
    required this.newQtyMilli,
    required this.thresholdMilli,
  });

  final String productId;
  final String productName;
  final int oldQtyMilli;
  final int newQtyMilli;
  final int thresholdMilli;

  bool get crossedOut => oldQtyMilli > 0 && newQtyMilli == 0;
  bool get crossedLow =>
      oldQtyMilli > thresholdMilli &&
      newQtyMilli > 0 &&
      newQtyMilli <= thresholdMilli;

  bool get shouldNotify => crossedOut || crossedLow;

  String get message => crossedOut
      ? '“$productName” is out of stock.'
      : '“$productName” is running low.';

  @override
  List<Object?> get props => [
    productId,
    productName,
    oldQtyMilli,
    newQtyMilli,
    thresholdMilli,
  ];
}

StockTransition? detectTransition({
  required String productId,
  required String productName,
  required int oldQtyMilli,
  required int newQtyMilli,
  required int thresholdMilli,
}) {
  final t = StockTransition(
    productId: productId,
    productName: productName,
    oldQtyMilli: oldQtyMilli,
    newQtyMilli: newQtyMilli,
    thresholdMilli: thresholdMilli,
  );
  return t.shouldNotify ? t : null;
}
