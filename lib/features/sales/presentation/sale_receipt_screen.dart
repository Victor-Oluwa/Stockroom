import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../app/di/providers.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/widgets/app_states.dart';
import '../../onboarding/domain/business_profile.dart';
import '../data/receipt_pdf.dart';
import '../data/receipt_share.dart';
import '../domain/sale.dart';

/// Receipt preview, share and print (PRD §6.8). Generated on-device from
/// the immutable sale snapshot; works offline.
class SaleReceiptScreen extends ConsumerStatefulWidget {
  const SaleReceiptScreen({super.key, required this.saleId});
  final String saleId;

  @override
  ConsumerState<SaleReceiptScreen> createState() => _SaleReceiptScreenState();
}

class _SaleReceiptScreenState extends ConsumerState<SaleReceiptScreen> {
  ReceiptLayout _layout = ReceiptLayout.compact80;
  bool _busy = false;
  pw.Font? _regular;
  pw.Font? _bold;

  /// Bundled DejaVu Sans covers ₦; loaded once from assets (offline-safe).
  Future<void> _ensureFonts() async {
    if (_regular != null) return;
    try {
      final reg = await rootBundle.load('assets/fonts/DejaVuSans.ttf');
      final bld = await rootBundle.load('assets/fonts/DejaVuSans-Bold.ttf');
      _regular = pw.Font.ttf(reg);
      _bold = pw.Font.ttf(bld);
    } catch (_) {
      // Fall back to built-in Helvetica (may miss ₦) rather than failing.
    }
  }

  Future<(BusinessProfile, db.Sale, List<SaleLineView>)?> _load() async {
    final sales = ref.read(saleRepositoryProvider);
    final profiles = ref.read(businessProfileRepositoryProvider);
    final saleRes = await sales.getSale(widget.saleId);
    final sale = saleRes.fold((_) => null, (v) => v);
    if (sale == null) return null;
    final linesRes = await sales.getLines(widget.saleId);
    final lines = linesRes.fold((_) => const <SaleLineView>[], (v) => v);
    final profRes = await profiles.read();
    final profile = profRes.fold(
      (_) => null,
      (v) => v ?? const BusinessProfile(id: 'local', businessName: 'Stockroom'),
    );
    if (profile == null) return null;
    return (profile, sale, lines);
  }

  Future<Uint8List?> _buildPdf() async {
    final loaded = await _load();
    if (loaded == null || !mounted) return null;
    final (profile, sale, lines) = loaded;
    await _ensureFonts();
    if (!mounted) return null;
    // Business logo picker lands with Settings polish; receipts already
    // support an embedded logo via logoBytes.
    return buildReceiptPdf(
      business: profile,
      sale: sale,
      lines: lines,
      layout: _layout,
      regularFont: _regular,
      boldFont: _bold,
    );
  }

  Future<void> _share() async {
    setState(() => _busy = true);
    final pdf = await _buildPdf();
    if (!mounted) return;
    if (pdf == null) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not build receipt.')));
      return;
    }
    final loaded = await _load();
    final number = loaded?.$2.saleNumber ?? 'sale';
    final r = await ReceiptShareService().sharePdf(
      bytes: pdf,
      saleNumber: number,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    r.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (_) {},
    );
  }

  Future<void> _print() async {
    setState(() => _busy = true);
    final pdf = await _buildPdf();
    if (!mounted) return;
    if (pdf == null) {
      setState(() => _busy = false);
      return;
    }
    final r = await ReceiptShareService().printPdf(bytes: pdf);
    if (!mounted) return;
    setState(() => _busy = false);
    r.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share PDF',
            onPressed: _busy ? null : _share,
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Print',
            onPressed: _busy ? null : _print,
          ),
        ],
      ),
      body: _busy
          ? const AppLoading(message: 'Preparing receipt…')
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      const Text('Layout'),
                      const SizedBox(width: 12),
                      SegmentedButton<ReceiptLayout>(
                        showSelectedIcon: false,
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                        segments: const [
                          ButtonSegment(
                            value: ReceiptLayout.compact80,
                            label: Text('80mm'),
                          ),
                          ButtonSegment(
                            value: ReceiptLayout.a4,
                            label: Text('A4'),
                          ),
                        ],
                        selected: {_layout},
                        onSelectionChanged: (s) =>
                            setState(() => _layout = s.first),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PdfPreview(
                    build: (_) async => (await _buildPdf()) ?? Uint8List(0),
                    allowSharing: false,
                    allowPrinting: false,
                  ),
                ),
              ],
            ),
    );
  }
}
