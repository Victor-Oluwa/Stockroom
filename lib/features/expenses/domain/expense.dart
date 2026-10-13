import 'package:equatable/equatable.dart';

/// Built-in operating expense categories (PRD §6.11) plus Other.
const List<String> expenseCategories = [
  'Rent',
  'Transport',
  'Utilities',
  'Repairs',
  'Packaging',
  'Wages',
  'Marketing',
  'Other',
];

class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.amountKobo,
    required this.category,
    required this.expenseDate,
    required this.paymentMethod,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final int amountKobo;
  final String category;
  final DateTime expenseDate;
  final String paymentMethod;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    amountKobo,
    category,
    expenseDate,
    paymentMethod,
    note,
    createdAt,
    updatedAt,
  ];
}
