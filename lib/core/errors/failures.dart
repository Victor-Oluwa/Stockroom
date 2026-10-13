import 'package:equatable/equatable.dart';

/// Typed domain failures (PRD §9.6).
///
/// Presentation layers map these to user-friendly messages.
/// The original exception is preserved in [cause] for debug logs only.
sealed class AppFailure extends Equatable {
  const AppFailure(this.message, [this.cause]);

  /// Safe to show to a shop owner. Never raw SQL.
  final String message;

  /// Debug-only diagnostic context. Must not be shown in UI.
  final Object? cause;

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, [super.cause]);
}

class ProductNotFound extends AppFailure {
  const ProductNotFound([super.message = 'Product not found.', super.cause]);
}

class DuplicateSkuBarcode extends AppFailure {
  const DuplicateSkuBarcode([
    super.message = 'SKU or barcode is already used by another product.',
    super.cause,
  ]);
}

class InsufficientStock extends AppFailure {
  const InsufficientStock([
    super.message = 'Not enough stock for this sale.',
    super.cause,
  ]);
}

class InvalidQuantityOrPrice extends AppFailure {
  const InvalidQuantityOrPrice([
    super.message = 'Quantity or price is invalid.',
    super.cause,
  ]);
}

class SaleAlreadyVoided extends AppFailure {
  const SaleAlreadyVoided([
    super.message = 'This sale has already been voided.',
    super.cause,
  ]);
}

class OperationAlreadyProcessed extends AppFailure {
  const OperationAlreadyProcessed([
    super.message = 'This operation was already completed.',
    super.cause,
  ]);
}

class DatabaseFailure extends AppFailure {
  const DatabaseFailure([
    super.message = 'Could not save. Please try again.',
    super.cause,
  ]);
}

class BackupInvalidFailure extends AppFailure {
  const BackupInvalidFailure([
    super.message = 'This backup file is invalid or unsupported.',
    super.cause,
  ]);
}

class ExportFailure extends AppFailure {
  const ExportFailure([
    super.message = 'Export failed. Please try again.',
    super.cause,
  ]);
}
