/// Minimal UTF-8 CSV encoder (PRD §6.12). Correctly escapes commas,
/// quotes and line breaks; stable column order set by callers.
String encodeCsv(List<String> header, List<List<Object?>> rows) {
  final buf = StringBuffer();
  buf.writeln(_record(header));
  for (final r in rows) {
    buf.writeln(_record(r.map((c) => c ?? '').toList()));
  }
  return buf.toString();
}

String _record(List<Object?> cells) => cells.map(_cell).join(',');

String _cell(Object? value) {
  final s = value is DateTime ? value.toIso8601String() : value.toString();
  if (s.contains(RegExp(r'[",\n\r]'))) {
    return '"${s.replaceAll('"', '""')}"';
  }
  return s;
}
