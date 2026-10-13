import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/supplier_repository.dart';
import '../domain/supplier.dart';

class SupplierListState extends Equatable {
  const SupplierListState({
    this.query = '',
    this.showArchived = false,
    this.items = const [],
    this.isLoading = true,
  });
  final String query;
  final bool showArchived;
  final List<Supplier> items;
  final bool isLoading;

  SupplierListState copyWith({
    String? query,
    bool? showArchived,
    List<Supplier>? items,
    bool? isLoading,
  }) => SupplierListState(
    query: query ?? this.query,
    showArchived: showArchived ?? this.showArchived,
    items: items ?? this.items,
    isLoading: isLoading ?? this.isLoading,
  );

  @override
  List<Object?> get props => [query, showArchived, items, isLoading];
}

class SupplierListCubit extends Cubit<SupplierListState> {
  SupplierListCubit(this._repo) : super(const SupplierListState()) {
    _subscribe();
  }
  final SupplierRepository _repo;
  StreamSubscription<List<Supplier>>? _sub;
  List<Supplier> _all = const [];

  void _subscribe() {
    _sub?.cancel();
    emit(state.copyWith(isLoading: true));
    _sub = _repo.watchSuppliers(showArchived: state.showArchived).listen((all) {
      _all = all;
      emit(state.copyWith(items: _filter(all, state.query), isLoading: false));
    });
  }

  List<Supplier> _filter(List<Supplier> all, String q) {
    final needle = q.trim().toLowerCase();
    if (needle.isEmpty) return all;
    return all
        .where(
          (s) =>
              s.name.toLowerCase().contains(needle) ||
              (s.phone?.contains(q.trim()) ?? false),
        )
        .toList();
  }

  void setQuery(String q) {
    emit(state.copyWith(query: q, items: _filter(_all, q)));
  }

  void toggleArchived(bool v) {
    emit(state.copyWith(showArchived: v));
    _subscribe();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
