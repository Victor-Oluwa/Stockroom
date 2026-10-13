import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  const Supplier({
    required this.id,
    required this.name,
    this.contactName,
    this.phone,
    this.email,
    this.address,
    this.notes,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? contactName;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    contactName,
    phone,
    email,
    address,
    notes,
    isArchived,
    createdAt,
    updatedAt,
  ];
}
