import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

/// One feedback voice for the whole app: floating rounded snackbar with a
/// status icon so success/error is never colour alone (PRD §5.3).
void showAppSnackBar(
  BuildContext context,
  String message, {
  bool error = false,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            error ? Icons.error_outline : Icons.check_circle_outline,
            size: 18,
            color: error ? AppTokens.red : AppTokens.moss,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
}
