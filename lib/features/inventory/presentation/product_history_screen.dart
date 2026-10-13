import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_timeline.dart';

/// Full movement history for one product (PRD §6.6 audit screen,
/// product scope). Rows open their linked sale or receipt.
class ProductHistoryScreen extends ConsumerWidget {
  const ProductHistoryScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(productRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Stock history')),
      body: StreamBuilder<List<db.StockMovement>>(
        stream: repo.watchMovements(productId, limit: 500),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const AppLoading(message: 'Loading history…');
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return const AppEmpty(
              icon: Icons.history,
              title: 'No movements yet',
              message:
                  'Opening stock, receipts, sales and adjustments appear here.',
            );
          }
          return MovementTimeline(
            entries: [
              // The product screen provides the context; rows still show
              // the day, signed delta, type and reason.
              for (final m in items) ('', m),
            ],
            emptyIcon: Icons.history,
            emptyTitle: 'No movements yet',
            emptyMessage:
                'Opening stock, receipts, sales and adjustments appear here.',
          );
        },
      ),
    );
  }
}
