import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../domain/business_profile.dart';

/// Repository contract: profile is the only onboarding state.
abstract class BusinessProfileRepository {
  Stream<BusinessProfile?> watch();
  Future<Result<BusinessProfile?>> read();
  Future<Result<BusinessProfile>> save({
    required String businessName,
    String? phone,
    String? address,
    String? logoPath,
    String? receiptFooter,
  });
}

class DriftBusinessProfileRepository implements BusinessProfileRepository {
  DriftBusinessProfileRepository(this._db, [Uuid? ids])
    : _ids = ids ?? const Uuid();

  final AppDatabase _db;
  final Uuid _ids;

  BusinessProfile _map(BusinessProfileData row) => BusinessProfile(
    id: row.id,
    businessName: row.businessName,
    phone: row.phone,
    address: row.address,
    logoPath: row.logoPath,
    receiptFooter: row.receiptFooter,
  );

  @override
  Stream<BusinessProfile?> watch() =>
      _db.watchProfile().map((r) => r == null ? null : _map(r));

  @override
  Future<Result<BusinessProfile?>> read() async {
    try {
      final row = await _db.readProfile();
      return ok(row == null ? null : _map(row));
    } catch (e) {
      return fail(DatabaseFailure('Could not load business profile.', e));
    }
  }

  @override
  Future<Result<BusinessProfile>> save({
    required String businessName,
    String? phone,
    String? address,
    String? logoPath,
    String? receiptFooter,
  }) async {
    final name = businessName.trim();
    if (name.isEmpty) {
      return fail(const ValidationFailure('Business name is required.'));
    }
    try {
      final existing = await _db.readProfile();
      final now = DateTime.now().toUtc();
      final id = existing?.id ?? _ids.v4();
      final created = existing?.createdAt ?? now;
      await _db.saveProfile(
        BusinessProfileCompanion(
          id: Value(id),
          businessName: Value(name),
          phone: Value(_nullIfBlank(phone)),
          address: Value(_nullIfBlank(address)),
          logoPath: Value(_nullIfBlank(logoPath)),
          receiptFooter: Value(_nullIfBlank(receiptFooter)),
          createdAt: Value(created),
          updatedAt: Value(now),
        ),
      );
      final saved = await _db.readProfile();
      if (saved == null) {
        return fail(const DatabaseFailure('Could not save business profile.'));
      }
      return ok(_map(saved));
    } catch (e) {
      return fail(DatabaseFailure('Could not save business profile.', e));
    }
  }

  String? _nullIfBlank(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}
