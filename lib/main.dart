import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

/// Entry point. No network/config waits — launches offline (PRD §10).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: StockroomApp()));
}
