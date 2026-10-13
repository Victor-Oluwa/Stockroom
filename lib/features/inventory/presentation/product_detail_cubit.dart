import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/product_repository.dart';

sealed class ProductActionState extends Equatable {
  const ProductActionState();
  @override
  List<Object?> get props => [];
}

class ProductActionIdle extends ProductActionState {
  const ProductActionIdle();
}

class ProductActionWorking extends ProductActionState {
  const ProductActionWorking();
}

class ProductActionDone extends ProductActionState {
  const ProductActionDone(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

/// Needs-confirmation carries the warning text when archiving with stock.
class ProductActionNeedsConfirm extends ProductActionState {
  const ProductActionNeedsConfirm(this.warning);
  final String warning;
  @override
  List<Object?> get props => [warning];
}

class ProductActionError extends ProductActionState {
  const ProductActionError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ProductDetailCubit extends Cubit<ProductActionState> {
  ProductDetailCubit(this._repo) : super(const ProductActionIdle());
  final ProductRepository _repo;

  Future<void> archive(String id, {bool confirmed = false}) async {
    emit(const ProductActionWorking());
    final result = await _repo.archive(id, confirmedWithStock: confirmed);
    result.fold((f) {
      if (!confirmed && f.message.contains('still has stock')) {
        emit(ProductActionNeedsConfirm(f.message));
      } else {
        emit(ProductActionError(f.message));
      }
    }, (_) => emit(const ProductActionDone('Product archived.')));
  }

  Future<void> unarchive(String id) async {
    emit(const ProductActionWorking());
    final result = await _repo.unarchive(id);
    result.fold(
      (f) => emit(ProductActionError(f.message)),
      (_) => emit(const ProductActionDone('Product restored.')),
    );
  }

  void reset() => emit(const ProductActionIdle());
}
