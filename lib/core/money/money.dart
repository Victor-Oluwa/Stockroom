/// Naira parsing/formatting. Storage is integer kobo (₦1.00 = 100).
///
/// No `double` anywhere: parsing uses decimal-safe integer math.
library;

/// Parses user-entered naira strings into integer kobo.
///
/// Accepts optional ₦, commas, spaces: `₦125,000.00`, `125000`, `0.50`.
/// Throws [FormatException] on empty, negative, non-numeric, or >2dp input.
/// Callers convert to [ValidationFailure] for UI display.
int parseNairaToKobo(String input) {
  final cleaned = input
      .trim()
      .replaceAll('₦', '')
      .replaceAll(',', '')
      .replaceAll(' ', '');
  if (cleaned.isEmpty) throw FormatException('Amount is required', input);
  final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(cleaned);
  if (match == null) {
    throw FormatException(
      'Enter a valid amount with at most 2 decimal places',
      input,
    );
  }
  final naira = int.parse(match.group(1)!);
  final fraction = (match.group(2) ?? '').padRight(2, '0');
  return naira * 100 + int.parse(fraction.isEmpty ? '00' : fraction);
}

/// Formats integer kobo as `₦125,000.00`. Handles zero and negatives.
String formatKobo(int kobo) {
  final negative = kobo < 0;
  final abs = kobo.abs();
  final naira = abs ~/ 100;
  final k = (abs % 100).toString().padLeft(2, '0');
  return '${negative ? '-' : ''}₦${_thousands(naira)}.$k';
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
