import 'package:equatable/equatable.dart';

import '../../../core/notifications/transitions.dart';

/// Manual adjustment reasons (PRD §6.6). `Other` requires a note.
const List<String> adjustmentReasons = [
  'Count correction',
  'Damaged',
  'Lost',
  'Found stock',
  'Internal use',
  'Opening correction',
  'Other',
];

enum AdjustmentDirection { increase, decrease }

class AdjustmentResult extends Equatable {
  const AdjustmentResult({
    required this.adjustmentId,
    required this.adjustmentNumber,
    required this.productId,
    required this.newQuantityMilli,
    required this.newAverageCostKobo,
    this.transition,
  });
  final String adjustmentId;
  final String adjustmentNumber;
  final String productId;
  final int newQuantityMilli;
  final int newAverageCostKobo;

  /// Present when this adjustment crossed into low/out-of-stock (PRD §6.9).
  final StockTransition? transition;

  @override
  List<Object?> get props => [
    adjustmentId,
    adjustmentNumber,
    productId,
    newQuantityMilli,
    newAverageCostKobo,
    transition,
  ];
}
