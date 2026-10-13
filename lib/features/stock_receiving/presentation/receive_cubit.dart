import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../data/receipt_repository.dart';
import '../domain/receipt.dart';

/// One editable receipt line (controller text lives in the widget).
class ReceiptDraftLine extends Equatable {
  const ReceiptDraftLine({
    required this.productId,
    required this.productName,
    required this.unitLabel,
    required this.averageCostKobo,
    this.quantityText = '',
    this.costText = '',
  });
  final String productId;
  final String productName;
  final String unitLabel;
  final int averageCostKobo;
  final String quantityText;
  final String costText;

  ReceiptDraftLine copyWith({String? quantityText, String? costText}) =>
      ReceiptDraftLine(
        productId: productId,
        productName: productName,
        unitLabel: unitLabel,
        averageCostKobo: averageCostKobo,
        quantityText: quantityText ?? this.quantityText,
        costText: costText ?? this.costText,
      );

  @override
  List<Object?> get props => [
    productId,
    productName,
    unitLabel,
    averageCostKobo,
    quantityText,
    costText,
  ];
}

sealed class ReceiveState extends Equatable {
  const ReceiveState();
  @override
  List<Object?> get props => [];
}

class ReceiveEditing extends ReceiveState {
  const ReceiveEditing();
}

class ReceiveSubmitting extends ReceiveState {
  const ReceiveSubmitting();
}

class ReceiveSuccess extends ReceiveState {
  const ReceiveSuccess(this.result);
  final ReceiptResult result;
  @override
  List<Object?> get props => [result];
}

class ReceiveError extends ReceiveState {
  const ReceiveError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ReceiveStockCubit extends Cubit<ReceiveState> {
  ReceiveStockCubit(this._repo, [Uuid? ids])
    : _opKey = (ids ?? const Uuid()).v4(),
      super(const ReceiveEditing());
  final ReceiptRepository _repo;
  final String _opKey;

  Future<void> submit({
    String? supplierId,
    String? supplierReference,
    String? notes,
    required List<ReceiptLineInput> lines,
    required bool zeroCostConfirmed,
  }) async {
    emit(const ReceiveSubmitting());
    final result = await _repo.receiveStock(
      operationKey: _opKey,
      supplierId: supplierId,
      supplierReference: supplierReference,
      notes: notes,
      lines: lines,
      zeroCostConfirmed: zeroCostConfirmed,
    );
    result.fold(
      (f) => emit(ReceiveError(f.message)),
      (r) => emit(ReceiveSuccess(r)),
    );
  }

  void backToEdit() => emit(const ReceiveEditing());
}
