import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../sales/domain/sale.dart' show paymentMethods;
import '../domain/expense.dart';

/// Converts a local calendar day to the stored UTC instant convention:
/// local midnight → UTC. All range bounds use the same convention, so day
/// membership is stable while the device offset is stable (PRD §7.6).
DateTime civilDayToUtc(DateTime localDay) =>
    DateTime(localDay.year, localDay.month, localDay.day).toUtc();

abstract class ExpenseRepository {
  Stream<List<Expense>> watch({
    String? category,
    DateTime? fromUtc,
    DateTime? toUtc,
    String? query,
  });
  Future<Result<List<Expense>>> list({
    String? category,
    DateTime? fromUtc,
    DateTime? toUtc,
    String? query,
  });
  Future<Result<Expense?>> get(String id);
  Future<Result<Expense>> record({
    required int amountKobo,
    required String category,
    required DateTime day,
    required String paymentMethod,
    String? note,
  });
  Future<Result<Expense>> update({
    required String id,
    required int amountKobo,
    required String category,
    required DateTime day,
    required String paymentMethod,
    String? note,
  });
  Future<Result<void>> remove(String id);
}

class DriftExpenseRepository implements ExpenseRepository {
  DriftExpenseRepository(this._db, [Uuid? ids]) : _ids = ids ?? const Uuid();
  final db.AppDatabase _db;
  final Uuid _ids;

  Expense _map(db.Expense r) => Expense(
    id: r.id,
    amountKobo: r.amountKobo,
    category: r.category,
    expenseDate: r.expenseDate,
    paymentMethod: r.paymentMethod,
    note: r.note,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );

  List<Expense> _apply(
    List<db.Expense> rows, {
    String? category,
    DateTime? fromUtc,
    DateTime? toUtc,
    String? query,
  }) {
    var out = rows.map(_map).toList();
    if (category != null) {
      out = out.where((e) => e.category == category).toList();
    }
    if (fromUtc != null) {
      out = out.where((e) => !e.expenseDate.isBefore(fromUtc)).toList();
    }
    if (toUtc != null) {
      out = out.where((e) => e.expenseDate.isBefore(toUtc)).toList();
    }
    final needle = (query ?? '').trim().toLowerCase();
    if (needle.isNotEmpty) {
      out = out
          .where(
            (e) =>
                e.category.toLowerCase().contains(needle) ||
                (e.note?.toLowerCase().contains(needle) ?? false),
          )
          .toList();
    }
    out.sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
    return out;
  }

  @override
  Stream<List<Expense>> watch({
    String? category,
    DateTime? fromUtc,
    DateTime? toUtc,
    String? query,
  }) {
    final q = _db.select(_db.expenses)
      ..orderBy([(e) => OrderingTerm.desc(e.expenseDate)]);
    return q.watch().map(
      (rows) => _apply(
        rows,
        category: category,
        fromUtc: fromUtc,
        toUtc: toUtc,
        query: query,
      ),
    );
  }

  @override
  Future<Result<List<Expense>>> list({
    String? category,
    DateTime? fromUtc,
    DateTime? toUtc,
    String? query,
  }) async {
    try {
      final rows = await (_db.select(
        _db.expenses,
      )..orderBy([(e) => OrderingTerm.desc(e.expenseDate)])).get();
      return ok(
        _apply(
          rows,
          category: category,
          fromUtc: fromUtc,
          toUtc: toUtc,
          query: query,
        ),
      );
    } catch (e) {
      return fail(DatabaseFailure('Could not load expenses.', e));
    }
  }

  @override
  Future<Result<Expense?>> get(String id) async {
    try {
      final row = await (_db.select(
        _db.expenses,
      )..where((e) => e.id.equals(id))).getSingleOrNull();
      return ok(row == null ? null : _map(row));
    } catch (e) {
      return fail(DatabaseFailure('Could not load expense.', e));
    }
  }

  String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  ValidationFailure? _validate(
    int amountKobo,
    String category,
    String payment,
  ) {
    if (amountKobo <= 0) {
      return const ValidationFailure('Amount must be greater than zero.');
    }
    if (!expenseCategories.contains(category)) {
      return const ValidationFailure('Select a valid category.');
    }
    if (!paymentMethods.contains(payment)) {
      return const ValidationFailure('Select a payment method.');
    }
    return null;
  }

  @override
  Future<Result<Expense>> record({
    required int amountKobo,
    required String category,
    required DateTime day,
    required String paymentMethod,
    String? note,
  }) async {
    final bad = _validate(amountKobo, category, paymentMethod);
    if (bad != null) return fail(bad);
    try {
      final now = DateTime.now().toUtc();
      final id = _ids.v4();
      await _db
          .into(_db.expenses)
          .insert(
            db.ExpensesCompanion.insert(
              id: id,
              amountKobo: amountKobo,
              category: category,
              expenseDate: civilDayToUtc(day),
              paymentMethod: paymentMethod,
              createdAt: now,
              updatedAt: now,
              note: Value(_clean(note)),
            ),
          );
      final row = await (_db.select(
        _db.expenses,
      )..where((e) => e.id.equals(id))).getSingle();
      return ok(_map(row));
    } catch (e) {
      return fail(DatabaseFailure('Could not record expense.', e));
    }
  }

  @override
  Future<Result<Expense>> update({
    required String id,
    required int amountKobo,
    required String category,
    required DateTime day,
    required String paymentMethod,
    String? note,
  }) async {
    final bad = _validate(amountKobo, category, paymentMethod);
    if (bad != null) return fail(bad);
    try {
      final existing = await (_db.select(
        _db.expenses,
      )..where((e) => e.id.equals(id))).getSingleOrNull();
      if (existing == null) {
        return fail(const ValidationFailure('Expense no longer exists.'));
      }
      // Editing never touches the stock ledger (PRD §6.11).
      await (_db.update(_db.expenses)..where((e) => e.id.equals(id))).write(
        db.ExpensesCompanion(
          amountKobo: Value(amountKobo),
          category: Value(category),
          expenseDate: Value(civilDayToUtc(day)),
          paymentMethod: Value(paymentMethod),
          note: Value(_clean(note)),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      final row = await (_db.select(
        _db.expenses,
      )..where((e) => e.id.equals(id))).getSingle();
      return ok(_map(row));
    } catch (e) {
      return fail(DatabaseFailure('Could not update expense.', e));
    }
  }

  @override
  Future<Result<void>> remove(String id) async {
    try {
      await (_db.delete(_db.expenses)..where((e) => e.id.equals(id))).go();
      return ok(null);
    } catch (e) {
      return fail(DatabaseFailure('Could not delete expense.', e));
    }
  }
}
