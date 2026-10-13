import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/category_repository.dart';
import '../domain/category.dart';

class CategoryState extends Equatable {
  const CategoryState({
    this.items = const [],
    this.showArchived = false,
    this.isLoading = true,
    this.error,
    this.actionError,
  });

  final List<ProductCategory> items;
  final bool showArchived;
  final bool isLoading;
  final String? error;
  final String? actionError;

  CategoryState copyWith({
    List<ProductCategory>? items,
    bool? showArchived,
    bool? isLoading,
    String? error,
    String? actionError,
  }) {
    return CategoryState(
      items: items ?? this.items,
      showArchived: showArchived ?? this.showArchived,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      actionError: actionError,
    );
  }

  @override
  List<Object?> get props => [
    items,
    showArchived,
    isLoading,
    error,
    actionError,
  ];
}

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this._repo) : super(const CategoryState()) {
    _subscribe();
  }

  final CategoryRepository _repo;
  StreamSubscription<List<ProductCategory>>? _sub;

  void _subscribe() {
    _sub?.cancel();
    _sub = _repo.watchAll().listen(
      (items) {
        final visible = state.showArchived
            ? items
            : items.where((c) => !c.isArchived).toList();
        emit(state.copyWith(items: visible, isLoading: false));
      },
      onError: (_) => emit(
        state.copyWith(isLoading: false, error: 'Could not load categories.'),
      ),
    );
  }

  void toggleArchived(bool show) {
    emit(state.copyWith(showArchived: show, isLoading: true));
    _subscribe();
  }

  Future<void> create(String name) async {
    final r = await _repo.create(name);
    r.fold(
      (f) => emit(state.copyWith(actionError: f.message)),
      (_) => emit(state.copyWith(actionError: null)),
    );
  }

  Future<void> rename(String id, String name) async {
    final r = await _repo.rename(id, name);
    r.fold(
      (f) => emit(state.copyWith(actionError: f.message)),
      (_) => emit(state.copyWith(actionError: null)),
    );
  }

  Future<void> archive(String id) async {
    final r = await _repo.archive(id);
    r.fold(
      (f) => emit(state.copyWith(actionError: f.message)),
      (_) => emit(state.copyWith(actionError: null)),
    );
  }

  Future<void> unarchive(String id) async {
    final r = await _repo.unarchive(id);
    r.fold(
      (f) => emit(state.copyWith(actionError: f.message)),
      (_) => emit(state.copyWith(actionError: null)),
    );
  }

  void clearActionError() => emit(state.copyWith(actionError: null));

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
