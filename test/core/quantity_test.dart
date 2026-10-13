import 'package:flutter_test/flutter_test.dart';
import 'package:stockroom/core/quantity/quantity.dart';

void main() {
  group('parseQuantityToMilli', () {
    test('parses whole and 3dp values', () {
      expect(parseQuantityToMilli('1'), 1000);
      expect(parseQuantityToMilli('1.5'), 1500);
      expect(parseQuantityToMilli('1.500'), 1500);
      expect(parseQuantityToMilli('0.001'), 1);
    });

    test('rejects >3dp, empty, negative', () {
      expect(() => parseQuantityToMilli(''), throwsFormatException);
      expect(() => parseQuantityToMilli('1.5000'), throwsFormatException);
      expect(() => parseQuantityToMilli('-2'), throwsFormatException);
      expect(() => parseQuantityToMilli('abc'), throwsFormatException);
    });
  });

  group('formatMilli', () {
    test('trims zeros, adds unit', () {
      expect(formatMilli(1000), '1');
      expect(formatMilli(1500), '1.5');
      expect(formatMilli(1250, 'kg'), '1.25 kg');
      expect(formatMilli(1250000), '1,250');
    });
  });

  group('normalisation', () {
    test('sku uppercased, barcode trimmed, name lowered', () {
      expect(normalizeSku('  abc-123 '), 'ABC-123');
      expect(normalizeSku('   '), isNull);
      expect(normalizeBarcode('  123456  '), '123456');
      expect(normalizeName('  Chair '), 'chair');
    });
  });
}
