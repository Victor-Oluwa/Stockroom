import 'package:equatable/equatable.dart';

/// Allowed unit labels (PRD §6.3). Stored as-is; validated against this list.
const List<String> unitLabels = [
  'piece',
  'pair',
  'set',
  'pack',
  'box',
  'carton',
  'kg',
  'g',
  'litre',
  'ml',
  'metre',
  'roll',
  'other',
];

/// Stock status derived from quantity vs threshold (PRD §6.9).
enum StockStatus { inStock, lowStock, outOfStock }

StockStatus stockStatusFor({
  required int quantityMilli,
  required int thresholdMilli,
}) {
  if (quantityMilli <= 0) return StockStatus.outOfStock;
  if (quantityMilli <= thresholdMilli) return StockStatus.lowStock;
  return StockStatus.inStock;
}

/// Product entity. Quantities in milli, money in kobo. No doubles.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    this.sku,
    this.barcode,
    this.categoryId,
    this.categoryName,
    required this.unitLabel,
    required this.sellingPriceKobo,
    required this.averageCostKobo,
    required this.quantityOnHandMilli,
    required this.lowStockThresholdMilli,
    this.imagePath,
    this.description,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String? sku;
  final String? barcode;
  final String? categoryId;
  final String? categoryName;
  final String unitLabel;
  final int sellingPriceKobo;
  final int averageCostKobo;
  final int quantityOnHandMilli;
  final int lowStockThresholdMilli;
  final String? imagePath;
  final String? description;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  StockStatus get status => stockStatusFor(
    quantityMilli: quantityOnHandMilli,
    thresholdMilli: lowStockThresholdMilli,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    sku,
    barcode,
    categoryId,
    categoryName,
    unitLabel,
    sellingPriceKobo,
    averageCostKobo,
    quantityOnHandMilli,
    lowStockThresholdMilli,
    imagePath,
    description,
    isArchived,
    createdAt,
    updatedAt,
  ];
}

/// List filter (PRD §6.3 product list).
enum StockFilter { all, lowStock, outOfStock }

enum ProductSort {
  nameAsc,
  recentlyUpdated,
  quantityHighToLow,
  quantityLowToHigh,
  priceHighToLow,
  priceLowToHigh,
}

class ProductListFilter extends Equatable {
  const ProductListFilter({
    this.query = '',
    this.categoryId,
    this.stockFilter = StockFilter.all,
    this.showArchived = false,
    this.sort = ProductSort.nameAsc,
  });

  final String query;
  final String? categoryId;
  final StockFilter stockFilter;
  final bool showArchived;
  final ProductSort sort;

  ProductListFilter copyWith({
    String? query,
    String? categoryId,
    StockFilter? stockFilter,
    bool? showArchived,
    ProductSort? sort,
    bool clearCategory = false,
  }) {
    return ProductListFilter(
      query: query ?? this.query,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      stockFilter: stockFilter ?? this.stockFilter,
      showArchived: showArchived ?? this.showArchived,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [
    query,
    categoryId,
    stockFilter,
    showArchived,
    sort,
  ];
}
