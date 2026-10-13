import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../app/theme/tokens.dart';

/// Product thumbnail. Resolves the stored relative path to a file;
/// falls back to a placeholder icon when missing.
class ProductImageView extends ConsumerWidget {
  const ProductImageView({super.key, this.relativePath, this.size = 48});
  final String? relativePath;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (relativePath == null || relativePath!.isEmpty) {
      return _placeholder();
    }
    final store = ref.watch(productImageStoreProvider);
    return FutureBuilder<File>(
      future: store.fileFor(relativePath!),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _shimmer();
        }
        if (!snap.hasData) return _placeholder();
        final file = snap.data!;
        return FutureBuilder<bool>(
          future: file.exists(),
          builder: (context, exists) {
            if (exists.data != true) return _placeholder();
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTokens.line),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  file,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _placeholder(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _shimmer() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTokens.coalRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTokens.line),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTokens.coalRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTokens.line),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: size * 0.45,
        color: AppTokens.taupeDim,
      ),
    );
  }
}
