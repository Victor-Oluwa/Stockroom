import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../core/database/app_database.dart';
import 'transitions.dart';

/// Device alerts for stock transitions. Local only, no server (PRD §6.9).
/// If permission is denied or unavailable, in-app alerts remain the source
/// of truth and this service silently no-ops.
class StockAlertService {
  StockAlertService(this._db);
  final AppDatabase _db;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> _ensureReady() async {
    if (_ready) return;
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _plugin.initialize(
        settings: const InitializationSettings(android: android),
      );
      const channel = AndroidNotificationChannel(
        'stock_alerts',
        'Stock alerts',
        description: 'Low-stock and out-of-stock alerts',
        importance: Importance.defaultImportance,
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  /// True when the user allows device alerts (setting + OS permission).
  Future<bool> get notificationsOn async {
    final settings = await _db.readSettings();
    return settings?.notificationsEnabled ?? true;
  }

  Future<void> setNotificationsOn(bool on) async {
    final existing = await _db.readSettings();
    if (existing == null) {
      await _db.ensureDefaultSettings();
    }
    await (_db.update(_db.appSettings)..where((s) => s.id.equals('settings')))
        .write(AppSettingsCompanion(notificationsEnabled: Value(on)));
  }

  /// Shows the rationale UI result: request the OS permission.
  /// Returns true when granted. Never throws.
  Future<bool> requestPermission() async {
    try {
      await _ensureReady();
      final granted =
          await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          true;
      return granted;
    } catch (_) {
      return false;
    }
  }

  /// Notifies for each crossed transition. No-ops when disabled/denied.
  Future<void> notifyTransitions(List<StockTransition> transitions) async {
    final actionable = transitions.where((t) => t.shouldNotify).toList();
    if (actionable.isEmpty) return;
    if (!await notificationsOn) return;
    try {
      await _ensureReady();
      if (!_ready) return;
      var id = 1000 + DateTime.now().millisecondsSinceEpoch % 100000;
      for (final t in actionable) {
        await _plugin.show(
          id: id++,
          title: t.crossedOut ? 'Out of stock' : 'Low stock',
          body: t.message,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails('stock_alerts', 'Stock alerts'),
          ),
          payload: t.productId,
        );
      }
    } catch (_) {
      // In-app alerts always remain available.
    }
  }
}
