import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../data/adjustment_repository.dart';
import '../domain/adjustment.dart';

sealed class AdjustState extends Equatable {
  const AdjustState();
  @override
  List<Object?> get props => [];
}

class AdjustEditing extends AdjustState {
  const AdjustEditing();
}

class AdjustSubmitting extends AdjustState {
  const AdjustSubmitting();
}

class AdjustSuccess extends AdjustState {
  const AdjustSuccess(this.result);
  final AdjustmentResult result;
  @override
  List<Object?> get props => [result];
}

class AdjustError extends AdjustState {
  const AdjustError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class AdjustStockCubit extends Cubit<AdjustState> {
  AdjustStockCubit(this._repo, [Uuid? ids])
    : _opKey = (ids ?? const Uuid()).v4(),
      super(const AdjustEditing());
  final AdjustmentRepository _repo;
  final String _opKey;

  Future<void> submit({
    required String productId,
    required AdjustmentDirection direction,
    required int quantityMilli,
    int? unitCostKobo,
    required String reason,
    String? note,
  }) async {
    emit(const AdjustSubmitting());
    final result = await _repo.adjust(
      operationKey: _opKey,
      productId: productId,
      direction: direction,
      quantityMilli: quantityMilli,
      unitCostKobo: unitCostKobo,
      reason: reason,
      note: note,
    );
    result.fold(
      (f) => emit(AdjustError(f.message)),
      (r) => emit(AdjustSuccess(r)),
    );
  }

  void backToEdit() => emit(const AdjustEditing());
}
