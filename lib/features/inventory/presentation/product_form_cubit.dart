import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_repository.dart';
import '../domain/product.dart';

sealed class ProductFormState extends Equatable {
  const ProductFormState();
  @override
  List<Object?> get props => [];
}

class ProductFormInitial extends ProductFormState {
  const ProductFormInitial();
}

class ProductFormSaving extends ProductFormState {
  const ProductFormSaving();
}

class ProductFormSuccess extends ProductFormState {
  const ProductFormSuccess(this.product);
  final Product product;
  @override
  List<Object?> get props => [product];
}

class ProductFormError extends ProductFormState {
  const ProductFormError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

/// One-shot create/update. Field validation lives in the form widget;
/// domain invariants enforced by the repository.
class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit(this._repo) : super(const ProductFormInitial());
  final ProductRepository _repo;

  // Operation key generated once per form instance for idempotent retries.
  String? operationKey;

  Future<void> create({
    required String name,
    String? sku,
    String? barcode,
    String? categoryId,
    required String unitLabel,
    required int sellingPriceKobo,
    bool zeroPriceConfirmed = false,
    int openingQtyMilli = 0,
    int? openingUnitCostKobo,
    int lowStockThresholdMilli = 5000,
    String? imagePath,
    String? description,
  }) async {
    emit(const ProductFormSaving());
    final result = await _repo.createProduct(
      productId: operationKey,
      name: name,
      sku: sku,
      barcode: barcode,
      categoryId: categoryId,
      unitLabel: unitLabel,
      sellingPriceKobo: sellingPriceKobo,
      zeroPriceConfirmed: zeroPriceConfirmed,
      openingQtyMilli: openingQtyMilli,
      openingUnitCostKobo: openingUnitCostKobo,
      lowStockThresholdMilli: lowStockThresholdMilli,
      imagePath: imagePath,
      description: description,
    );
    result.fold(
      (f) => emit(ProductFormError(f.message)),
      (p) => emit(ProductFormSuccess(p)),
    );
  }

  Future<void> update({
    required String id,
    required String name,
    String? sku,
    String? barcode,
    String? categoryId,
    required String unitLabel,
    required int sellingPriceKobo,
    bool zeroPriceConfirmed = false,
    required int lowStockThresholdMilli,
    String? imagePath,
    String? description,
  }) async {
    emit(const ProductFormSaving());
    final result = await _repo.updateDetails(
      id: id,
      name: name,
      sku: sku,
      barcode: barcode,
      categoryId: categoryId,
      unitLabel: unitLabel,
      sellingPriceKobo: sellingPriceKobo,
      zeroPriceConfirmed: zeroPriceConfirmed,
      lowStockThresholdMilli: lowStockThresholdMilli,
      imagePath: imagePath,
      description: description,
    );
    result.fold(
      (f) => emit(ProductFormError(f.message)),
      (p) => emit(ProductFormSuccess(p)),
    );
  }
}
