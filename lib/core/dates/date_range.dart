import 'package:equatable/equatable.dart';

/// Local calendar date range (inclusive both ends in the UI).
/// Implemented as [start] inclusive → [endExclusive] for queries (PRD §6.12).
class LocalDateRange extends Equatable {
  const LocalDateRange({required this.start, required this.endExclusive});

  /// Start of [day] in local time.
  factory LocalDateRange.day(DateTime day) {
    final s = DateTime(day.year, day.month, day.day);
    return LocalDateRange(
      start: s,
      endExclusive: s.add(const Duration(days: 1)),
    );
  }

  factory LocalDateRange.lastDays(int n, {DateTime? now}) {
    final today = now ?? DateTime.now();
    final s = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: n - 1));
    final end = DateTime(
      today.year,
      today.month,
      today.day,
    ).add(const Duration(days: 1));
    return LocalDateRange(start: s, endExclusive: end);
  }

  factory LocalDateRange.month(DateTime month) {
    final s = DateTime(month.year, month.month, 1);
    final end = month.month == 12
        ? DateTime(month.year + 1, 1, 1)
        : DateTime(month.year, month.month + 1, 1);
    return LocalDateRange(start: s, endExclusive: end);
  }

  factory LocalDateRange.custom(DateTime startDay, DateTime endDayInclusive) {
    final s = DateTime(startDay.year, startDay.month, startDay.day);
    final e = DateTime(
      endDayInclusive.year,
      endDayInclusive.month,
      endDayInclusive.day,
    ).add(const Duration(days: 1));
    return LocalDateRange(start: s, endExclusive: e);
  }

  final DateTime start;
  final DateTime endExclusive;

  /// UTC bounds for comparing stored UTC instants. Both bounds use the same
  /// local-midnight convention as writes, so day membership is stable
  /// regardless of the device offset (Nigeria has no DST).
  (DateTime, DateTime) get utcBounds => (start.toUtc(), endExclusive.toUtc());

  bool containsLocal(DateTime instant) {
    final l = instant.toLocal();
    return !l.isBefore(start) && l.isBefore(endExclusive);
  }

  @override
  List<Object?> get props => [start, endExclusive];
}

/// Report presets (PRD §6.12).
enum ReportPreset { today, yesterday, last7Days, thisMonth, lastMonth, custom }

LocalDateRange presetRange(ReportPreset preset, {DateTime? now}) {
  final today = now ?? DateTime.now();
  final day = DateTime(today.year, today.month, today.day);
  switch (preset) {
    case ReportPreset.today:
      return LocalDateRange.day(today);
    case ReportPreset.yesterday:
      return LocalDateRange.day(day.subtract(const Duration(days: 1)));
    case ReportPreset.last7Days:
      return LocalDateRange.lastDays(7, now: today);
    case ReportPreset.thisMonth:
      return LocalDateRange.month(today);
    case ReportPreset.lastMonth:
      final first = DateTime(today.year, today.month, 1);
      final prev = first.subtract(const Duration(days: 1));
      return LocalDateRange.month(prev);
    case ReportPreset.custom:
      return LocalDateRange.day(today);
  }
}
