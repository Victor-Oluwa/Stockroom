import 'package:intl/intl.dart';

import '../money/money.dart';
import '../quantity/quantity.dart';

export '../money/money.dart';
export '../quantity/quantity.dart';

/// Display helpers. All formatting funnels through here so dashboard,
/// receipts and exports share one implementation (PRD §7, §6.12).
String formatNaira(int kobo) => formatKobo(kobo);

String formatQty(int milli, [String? unit]) => formatMilli(milli, unit);

/// Local date-time rendering. DB stores UTC millis; UI renders local.
String formatDateTimeLocal(
  DateTime utc, {
  String pattern = 'dd MMM yyyy, hh:mm a',
}) {
  return DateFormat(pattern).format(utc.toLocal());
}

String formatDateLocal(DateTime utc) =>
    DateFormat('dd MMM yyyy').format(utc.toLocal());
