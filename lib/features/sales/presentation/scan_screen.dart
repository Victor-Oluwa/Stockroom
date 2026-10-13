import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/theme/tokens.dart';

/// Camera barcode scanner with manual fallback (PRD §6.13).
/// Returns the scanned/typed barcode via `context.pop(code)`.
/// Duplicate scan callbacks collapse to a single result: the first
/// detection stops the scanner and closes the screen.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late final MobileScannerController _controller;
  bool _handled = false;
  final _manual = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      formats: const [
        BarcodeFormat.ean13,
        BarcodeFormat.ean8,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
        BarcodeFormat.code128,
        BarcodeFormat.code39,
      ],
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    _manual.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _finish(String code) {
    final trimmed = code.trim();
    if (trimmed.isEmpty || _handled || !mounted) return;
    _handled = true;
    _controller.stop();
    Navigator.pop(context, trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan barcode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on_outlined),
            tooltip: 'Toggle torch',
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch_outlined),
            tooltip: 'Switch camera',
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    final code = capture.barcodes
                        .map((b) => b.rawValue)
                        .firstWhere(
                          (v) => v != null && v.trim().isNotEmpty,
                          orElse: () => null,
                        );
                    if (code != null) _finish(code);
                  },
                  errorBuilder: (context, error) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.videocam_off_outlined,
                            size: 48,
                            color: AppTokens.taupe,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            error.errorCode ==
                                    MobileScannerErrorCode.permissionDenied
                                ? 'Camera permission was denied. Type the barcode below instead — scanning stays optional.'
                                : 'Camera unavailable. Type the barcode below instead.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTokens.taupe),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Quiet corner brackets marking the capture area.
                const IgnorePointer(
                  child: _BracketOverlay(color: AppTokens.moss),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _manual,
                    decoration: const InputDecoration(
                      labelText: 'Or type barcode',
                      prefixIcon: Icon(Icons.keyboard_outlined),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: _finish,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => _finish(_manual.text),
                  child: const Text('Use'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Four matte corner brackets — the classic scan frame, no gradients,
/// no dimming layers over the live preview.
class _BracketOverlay extends StatelessWidget {
  const _BracketOverlay({required this.color});
  final Color color;

  static const _len = 34.0;
  static const _stroke = 3.0;
  static const _inset = 34.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final rect = Rect.fromCenter(
          center: Offset(w / 2, h / 2),
          width: w - _inset * 2,
          height: (w - _inset * 2).clamp(160.0, h - _inset * 2),
        );
        return CustomPaint(
          size: Size(w, h),
          painter: _BracketPainter(rect: rect, color: color),
        );
      },
    );
  }
}

class _BracketPainter extends CustomPainter {
  _BracketPainter({required this.rect, required this.color});
  final Rect rect;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _BracketOverlay._stroke
      ..strokeCap = StrokeCap.round;
    const len = _BracketOverlay._len;
    // Top-left, top-right, bottom-right, bottom-left corners.
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.top + len)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.left + len, rect.top),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - len, rect.top)
        ..lineTo(rect.right, rect.top)
        ..lineTo(rect.right, rect.top + len),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(rect.right, rect.bottom - len)
        ..lineTo(rect.right, rect.bottom)
        ..lineTo(rect.right - len, rect.bottom),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(rect.left + len, rect.bottom)
        ..lineTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.bottom - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BracketPainter old) =>
      old.rect != rect || old.color != color;
}
