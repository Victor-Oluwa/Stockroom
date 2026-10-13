import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/money/calculations.dart';
import '../../inventory/domain/product.dart';
import '../data/sale_repository.dart';
import '../domain/sale.dart';

/// One cart line. [availableMilli] is the stock seen when added —
/// the live balance is rechecked inside the sale transaction.
class CartLine extends Equatable {
  const CartLine({
    required this.product,
    this.quantityMilli = 1000,
    required this.unitPriceKobo,
    this.discountKobo = 0,
  });
  final Product product;
  final int quantityMilli;
  final int unitPriceKobo;
  final int discountKobo;

  int get grossKobo => grossLineTotalKobo(
    quantityMilli: quantityMilli,
    unitPriceKobo: unitPriceKobo,
  );
  int get netKobo => grossKobo - discountKobo;

  CartLine copyWith({
    int? quantityMilli,
    int? unitPriceKobo,
    int? discountKobo,
  }) => CartLine(
    product: product,
    quantityMilli: quantityMilli ?? this.quantityMilli,
    unitPriceKobo: unitPriceKobo ?? this.unitPriceKobo,
    discountKobo: discountKobo ?? this.discountKobo,
  );

  @override
  List<Object?> get props => [
    product,
    quantityMilli,
    unitPriceKobo,
    discountKobo,
  ];
}

class CartState extends Equatable {
  const CartState({
    this.lines = const [],
    this.paymentMethod = 'Cash',
    this.customerName = '',
    this.note = '',
    this.submitting = false,
    this.error,
    this.result,
  });
  final List<CartLine> lines;
  final String paymentMethod;
  final String customerName;
  final String note;
  final bool submitting;
  final String? error;
  final SaleResult? result;

  int get subtotalKobo => lines.fold(0, (s, l) => s + l.grossKobo);
  int get discountKobo => lines.fold(0, (s, l) => s + l.discountKobo);
  int get totalKobo => subtotalKobo - discountKobo;

  CartState copyWith({
    List<CartLine>? lines,
    String? paymentMethod,
    String? customerName,
    String? note,
    bool? submitting,
    String? error,
    SaleResult? result,
  }) => CartState(
    lines: lines ?? this.lines,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    customerName: customerName ?? this.customerName,
    note: note ?? this.note,
    submitting: submitting ?? this.submitting,
    error: error,
    result: result,
  );

  @override
  List<Object?> get props => [
    lines,
    paymentMethod,
    customerName,
    note,
    submitting,
    error,
    result,
  ];
}

/// Cart owns one idempotency key per session: double-taps and UI retries
/// after a failed commit window collapse to a single sale server-side.
class SaleCartCubit extends Cubit<CartState> {
  SaleCartCubit(this._repo, [Uuid? ids])
    : _opKey = (ids ?? const Uuid()).v4(),
      super(const CartState());
  final SaleRepository _repo;
  String _opKey;

  void addProduct(Product product, {int quantityMilli = 1000}) {
    if (product.isArchived) return;
    final lines = List<CartLine>.of(state.lines);
    final i = lines.indexWhere((l) => l.product.id == product.id);
    if (i >= 0) {
      final l = lines[i];
      lines[i] = l.copyWith(quantityMilli: l.quantityMilli + quantityMilli);
    } else {
      lines.add(
        CartLine(
          product: product,
          quantityMilli: quantityMilli,
          unitPriceKobo: product.sellingPriceKobo,
        ),
      );
    }
    emit(state.copyWith(lines: lines, error: null, result: null));
  }

  void setQuantity(String productId, int qtyMilli) {
    final lines = List<CartLine>.of(state.lines);
    final i = lines.indexWhere((l) => l.product.id == productId);
    if (i < 0) return;
    lines[i] = lines[i].copyWith(quantityMilli: qtyMilli);
    emit(state.copyWith(lines: lines, error: null));
  }

  void setPrice(String productId, int priceKobo) {
    final lines = List<CartLine>.of(state.lines);
    final i = lines.indexWhere((l) => l.product.id == productId);
    if (i < 0) return;
    lines[i] = lines[i].copyWith(unitPriceKobo: priceKobo);
    emit(state.copyWith(lines: lines, error: null));
  }

  void setDiscount(String productId, int discountKobo) {
    final lines = List<CartLine>.of(state.lines);
    final i = lines.indexWhere((l) => l.product.id == productId);
    if (i < 0) return;
    lines[i] = lines[i].copyWith(discountKobo: discountKobo);
    emit(state.copyWith(lines: lines, error: null));
  }

  void removeLine(String productId) {
    emit(
      state.copyWith(
        lines: state.lines.where((l) => l.product.id != productId).toList(),
        error: null,
      ),
    );
  }

  void setPayment(String v) =>
      emit(state.copyWith(paymentMethod: v, error: null));
  void setCustomer(String v) =>
      emit(state.copyWith(customerName: v, error: null));
  void setNote(String v) => emit(state.copyWith(note: v, error: null));

  /// Starts a fresh cart (new idempotency key) after a completed sale.
  void newSale() {
    _opKey = const Uuid().v4();
    emit(const CartState(paymentMethod: 'Cash'));
  }

  void clearError() => emit(state.copyWith(error: null));

  Future<void> checkout() async {
    if (state.submitting) return;
    emit(state.copyWith(submitting: true, error: null));
    final result = await _repo.completeSale(
      operationKey: _opKey,
      lines: [
        for (final l in state.lines)
          SaleLineInput(
            productId: l.product.id,
            quantityMilli: l.quantityMilli,
            unitPriceKobo: l.unitPriceKobo,
            discountKobo: l.discountKobo,
          ),
      ],
      paymentMethod: state.paymentMethod,
      customerName: state.customerName,
      note: state.note,
    );
    result.fold(
      // Cart preserved for correction (PRD Scenario B).
      (f) => emit(state.copyWith(submitting: false, error: f.message)),
      (r) => emit(state.copyWith(submitting: false, result: r)),
    );
  }
}
