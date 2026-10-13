import 'package:flutter_test/flutter_test.dart';
import 'package:stockroom/core/money/calculations.dart';
import 'package:stockroom/core/money/money.dart';

void main() {
  group('parseNairaToKobo', () {
    test('parses plain and formatted input', () {
      expect(parseNairaToKobo('125000'), 12500000);
      expect(parseNairaToKobo('₦125,000.00'), 12500000);
      expect(parseNairaToKobo('0.50'), 50);
      expect(parseNairaToKobo(' 1,250 '), 125000);
    });

    test('rejects invalid precision and negatives', () {
      expect(() => parseNairaToKobo(''), throwsFormatException);
      expect(() => parseNairaToKobo('12.345'), throwsFormatException);
      expect(() => parseNairaToKobo('-5'), throwsFormatException);
      expect(() => parseNairaToKobo('abc'), throwsFormatException);
    });
  });

  group('formatKobo', () {
    test('formats with thousands and 2dp', () {
      expect(formatKobo(12500000), '₦125,000.00');
      expect(formatKobo(0), '₦0.00');
      expect(formatKobo(50), '₦0.50');
      expect(formatKobo(-150), '-₦1.50');
    });
  });

  group('rounding + line totals', () {
    test('half-up rounds .5 up', () {
      // 1 milli × 1 kobo / 1000 = 0.001 → 0; 500×1/1000=0.5 → 1
      expect(roundHalfUpDiv(1, 1000), 0);
      expect(roundHalfUpDiv(500, 1000), 1);
      expect(roundHalfUpDiv(1500, 1000), 2);
    });

    test('gross/cogs totals match PRD formula', () {
      // 1.5 units × ₦100.00 = ₦150.00
      expect(
        grossLineTotalKobo(quantityMilli: 1500, unitPriceKobo: 10000),
        15000,
      );
      expect(
        cogsTotalKobo(quantityMilli: 1500, unitCostSnapshotKobo: 9000),
        13500,
      );
    });

    test('weighted average cost', () {
      // 47 @ 10000 + 10 @ 11000 → (470000+110000)/57 = 10175.43… → 10175
      final avg = weightedAverageCostKobo(
        oldQtyMilli: 47000,
        oldAvgCostKobo: 10000,
        receivedQtyMilli: 10000,
        receivedUnitCostKobo: 11000,
      );
      expect(avg, 10175);
    });

    test('zero old qty takes receipt cost', () {
      expect(
        weightedAverageCostKobo(
          oldQtyMilli: 0,
          oldAvgCostKobo: 0,
          receivedQtyMilli: 5000,
          receivedUnitCostKobo: 9000,
        ),
        9000,
      );
    });

    test('stock value zero when qty zero', () {
      expect(stockValueKobo(quantityOnHandMilli: 0, averageCostKobo: 9999), 0);
    });
  });
}
