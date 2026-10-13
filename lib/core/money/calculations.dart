/// Integer half-up division for non-negative values.
///
/// PRD §7: all currency/quantity math uses integer arithmetic with
/// half-up rounding where division is unavoidable.
/// Dart `double` must never be used for money or ledger quantities.
int roundHalfUpDiv(int numerator, int denominator) {
  ArgumentError.checkNotNull(numerator, 'numerator');
  if (denominator <= 0) {
    throw ArgumentError.value(denominator, 'denominator', 'must be > 0');
  }
  if (numerator < 0) {
    throw ArgumentError.value(numerator, 'numerator', 'must be >= 0');
  }
  return (numerator + denominator ~/ 2) ~/ denominator;
}

/// `grossLineTotalKobo = roundHalfUp(quantityMilli × unitPriceKobo / 1000)`
int grossLineTotalKobo({
  required int quantityMilli,
  required int unitPriceKobo,
}) {
  if (quantityMilli < 0 || unitPriceKobo < 0) {
    throw ArgumentError('quantity and price must be >= 0');
  }
  return roundHalfUpDiv(quantityMilli * unitPriceKobo, 1000);
}

/// `cogsTotalKobo = roundHalfUp(quantityMilli × unitCostSnapshotKobo / 1000)`
int cogsTotalKobo({
  required int quantityMilli,
  required int unitCostSnapshotKobo,
}) {
  if (quantityMilli < 0 || unitCostSnapshotKobo < 0) {
    throw ArgumentError('quantity and cost must be >= 0');
  }
  return roundHalfUpDiv(quantityMilli * unitCostSnapshotKobo, 1000);
}

/// `stockValueKobo = roundHalfUp(quantityOnHandMilli × averageCostKobo / 1000)`
int stockValueKobo({
  required int quantityOnHandMilli,
  required int averageCostKobo,
}) {
  if (quantityOnHandMilli < 0 || averageCostKobo < 0) {
    throw ArgumentError('quantity and cost must be >= 0');
  }
  if (quantityOnHandMilli == 0) return 0;
  return roundHalfUpDiv(quantityOnHandMilli * averageCostKobo, 1000);
}

/// Moving weighted-average cost (PRD §6.5).
///
/// `newAvg = roundHalfUp((oldQty×oldAvg + receivedQty×receivedCost) / (oldQty+receivedQty))`
/// If [oldQtyMilli] is zero, returns [receivedUnitCostKobo].
int weightedAverageCostKobo({
  required int oldQtyMilli,
  required int oldAvgCostKobo,
  required int receivedQtyMilli,
  required int receivedUnitCostKobo,
}) {
  if (oldQtyMilli < 0 ||
      oldAvgCostKobo < 0 ||
      receivedQtyMilli <= 0 ||
      receivedUnitCostKobo < 0) {
    throw ArgumentError(
      'oldQty>=0, oldAvg>=0, receivedQty>0, receivedCost>=0 required',
    );
  }
  if (oldQtyMilli == 0) return receivedUnitCostKobo;
  final numerator =
      oldQtyMilli * oldAvgCostKobo + receivedQtyMilli * receivedUnitCostKobo;
  return roundHalfUpDiv(numerator, oldQtyMilli + receivedQtyMilli);
}

/// Average cost after a full sale void restores stock (PRD §6.7).
///
/// Weighted average of inventory currently on hand at its current average
/// cost and the returned quantity at the original sale cost snapshot.
/// If current quantity is zero, returns [returnedUnitCostKobo].
int voidRestoredAverageCostKobo({
  required int currentQtyMilli,
  required int currentAvgCostKobo,
  required int returnedQtyMilli,
  required int returnedUnitCostKobo,
}) {
  if (currentQtyMilli < 0 ||
      currentAvgCostKobo < 0 ||
      returnedQtyMilli <= 0 ||
      returnedUnitCostKobo < 0) {
    throw ArgumentError('invalid void restoration inputs');
  }
  if (currentQtyMilli == 0) return returnedUnitCostKobo;
  final numerator =
      currentQtyMilli * currentAvgCostKobo +
      returnedQtyMilli * returnedUnitCostKobo;
  return roundHalfUpDiv(numerator, currentQtyMilli + returnedQtyMilli);
}
