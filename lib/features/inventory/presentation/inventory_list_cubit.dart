import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_repository.dart';
import '../domain/product.dart';

class InventoryListState extends Equatable {
  const InventoryListState({
    this.filter = const ProductListFilter(),
    this.products = const [],
    this.isLoading = true,
    this.error,
  });

  final ProductListFilter filter;
  final List<Product> products;
  final bool isLoading;
  final String? error;

  InventoryListState copyWith({
    ProductListFilter? filter,
    List<Product>? products,
    bool? isLoading,
    String? error,
  }) {
    return InventoryListState(
      filter: filter ?? this.filter,
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [filter, products, isLoading, error];
}

/// Reactive product list. Reads stream from repository; no math here.
class InventoryListCubit extends Cubit<InventoryListState> {
  InventoryListCubit(this._repo, [ProductListFilter? initial])
    : super(InventoryListState(filter: initial ?? const ProductListFilter())) {
    _subscribe();
  }

  final ProductRepository _repo;
  StreamSubscription<List<Product>>? _sub;

  void _subscribe() {
    _sub?.cancel();
    emit(state.copyWith(isLoading: true));
    _sub = _repo
        .watchProducts(state.filter)
        .listen(
          (items) => emit(state.copyWith(products: items, isLoading: false)),
          onError: (Object e) => emit(
            state.copyWith(isLoading: false, error: 'Could not load products.'),
          ),
        );
  }

  void setQuery(String q) {
    emit(state.copyWith(filter: state.filter.copyWith(query: q)));
    _subscribe();
  }

  void setCategory(String? id) {
    emit(
      state.copyWith(
        filter: id == null
            ? state.filter.copyWith(clearCategory: true)
            : state.filter.copyWith(categoryId: id),
      ),
    );
    _subscribe();
  }

  void setStockFilter(StockFilter f) {
    emit(state.copyWith(filter: state.filter.copyWith(stockFilter: f)));
    _subscribe();
  }

  void toggleArchived(bool show) {
    emit(state.copyWith(filter: state.filter.copyWith(showArchived: show)));
    _subscribe();
  }

  void setSort(ProductSort sort) {
    emit(state.copyWith(filter: state.filter.copyWith(sort: sort)));
    _subscribe();
  }

  void refresh() => _subscribe();

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
