import 'package:equatable/equatable.dart';

/// One receipt line as entered (pre-merge). Quantities in milli, costs in kobo.
class ReceiptLineInput extends Equatable {
  const ReceiptLineInput({
    required this.productId,
    required this.quantityMilli,
    required this.unitCostKobo,
  });
  final String productId;
  final int quantityMilli;
  final int unitCostKobo;

  @override
  List<Object?> get props => [productId, quantityMilli, unitCostKobo];
}

/// Merged line stored in the database (one row per product).
class MergedReceiptLine extends Equatable {
  const MergedReceiptLine({
    required this.productId,
    required this.productName,
    required this.unitLabel,
    required this.quantityMilli,
    required this.unitCostKobo,
    required this.lineCostKobo,
    required this.newQuantityMilli,
    required this.newAverageCostKobo,
  });
  final String productId;
  final String productName;
  final String unitLabel;
  final int quantityMilli;
  final int unitCostKobo;
  final int lineCostKobo;
  final int newQuantityMilli;
  final int newAverageCostKobo;

  @override
  List<Object?> get props => [
    productId,
    productName,
    unitLabel,
    quantityMilli,
    unitCostKobo,
    lineCostKobo,
    newQuantityMilli,
    newAverageCostKobo,
  ];
}

class ReceiptResult extends Equatable {
  const ReceiptResult({
    required this.receiptId,
    required this.receiptNumber,
    required this.totalCostKobo,
    required this.lines,
  });
  final String receiptId;
  final String receiptNumber;
  final int totalCostKobo;
  final List<MergedReceiptLine> lines;

  @override
  List<Object?> get props => [receiptId, receiptNumber, totalCostKobo, lines];
}
