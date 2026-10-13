/// Quantity: fixed-scale integer, 1.000 displayed units = 1000 stored.
///
/// Supports kg/litres/metres (3dp) and whole items. No `double`.
library;

/// Scale factor: stored = displayed × 1000.
const int quantityScale = 1000;

/// Parses user-entered quantities into integer milli units.
///
/// Accepts `12`, `12.5`, `1.500`. Throws [FormatException] on empty,
/// negative, non-numeric, or >3 decimal places. Never silently truncates.
int parseQuantityToMilli(String input) {
  final cleaned = input.trim().replaceAll(',', '').replaceAll(' ', '');
  if (cleaned.isEmpty) throw FormatException('Quantity is required', input);
  final match = RegExp(r'^(\d+)(?:\.(\d{1,3}))?$').firstMatch(cleaned);
  if (match == null) {
    throw FormatException(
      'Enter a valid quantity with at most 3 decimal places',
      input,
    );
  }
  final whole = int.parse(match.group(1)!);
  final fraction = (match.group(2) ?? '').padRight(3, '0');
  return whole * quantityScale + int.parse(fraction.isEmpty ? '000' : fraction);
}

/// Formats milli units for display, trimming trailing zeros:
/// 1000 → `1`, 1500 → `1.5`, 1250 milli with unit → `1.25 kg`.
/// Integer part gets thousands separators.
String formatMilli(int milli, [String? unitLabel]) {
  if (milli < 0) throw ArgumentError.value(milli, 'milli', 'must be >= 0');
  final whole = milli ~/ quantityScale;
  var frac = (milli % quantityScale).toString().padLeft(3, '0');
  frac = frac.replaceAll(RegExp(r'0+$'), '');
  final number = frac.isEmpty
      ? _thousands(whole)
      : '${_thousands(whole)}.$frac';
  final unit = (unitLabel ?? '').trim();
  return unit.isEmpty ? number : '$number $unit';
}

String _thousands(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  var count = 0;
  for (var i = s.length - 1; i >= 0; i--) {
    buf.write(s[i]);
    count++;
    if (count == 3 && i != 0) {
      buf.write(',');
      count = 0;
    }
  }
  return buf.toString().split('').reversed.join();
}

/// Normalises barcode/SKU strings: trim + uppercase for SKU,
/// trim only for barcode (barcodes are case-sensitive digits but
/// whitespace-insensitive). Empty → null.
String? normalizeSku(String? input) {
  final t = input?.trim().toUpperCase();
  if (t == null || t.isEmpty) return null;
  return t;
}

String? normalizeBarcode(String? input) {
  final t = input?.trim();
  if (t == null || t.isEmpty) return null;
  return t;
}

/// Case-insensitive product-name normalisation for search.
String normalizeName(String input) => input.trim().toLowerCase();
