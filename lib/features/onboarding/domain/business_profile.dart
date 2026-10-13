import 'package:equatable/equatable.dart';

/// Business profile entity (PRD §6.1). Single active row per install.
class BusinessProfile extends Equatable {
  const BusinessProfile({
    required this.id,
    required this.businessName,
    this.phone,
    this.address,
    this.logoPath,
    this.receiptFooter,
  });

  final String id;
  final String businessName;
  final String? phone;
  final String? address;
  final String? logoPath;
  final String? receiptFooter;

  @override
  List<Object?> get props => [
    id,
    businessName,
    phone,
    address,
    logoPath,
    receiptFooter,
  ];
}
