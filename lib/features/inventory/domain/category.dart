import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  const ProductCategory({
    required this.id,
    required this.name,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [id, name, isArchived, createdAt, updatedAt];
}
