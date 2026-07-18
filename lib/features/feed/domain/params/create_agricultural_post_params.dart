import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/entities/quantity_unit.dart';

class CreateAgriculturalPostParams {
  final PostType type;
  final ProductCategory category;
  final String productName;
  final double quantity;
  final QuantityUnit unit;
  final DateTime availableFrom;
  final DateTime availableTo;
  final String location;
  final double? pricePerUnit;
  final String? qualityRequirement;
  final String? description;

  const CreateAgriculturalPostParams({
    required this.type,
    required this.category,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.availableFrom,
    required this.availableTo,
    required this.location,
    this.pricePerUnit,
    this.qualityRequirement,
    this.description,
  });
}
