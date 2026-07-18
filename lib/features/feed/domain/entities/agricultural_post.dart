import 'package:krishi_social/features/feed/domain/entities/post_status.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/entities/quantity_unit.dart';

class AgriculturePost {
  final String id;
  final String userId;
  final String userName;
  final String? userImageUrl;
  final bool isUserReviewed;

  final PostType type;

  final ProductCategory category;
  final String productName;

  final double quantity;
  final QuantityUnit unit;

  final DateTime availableFrom;
  final DateTime availableTo;

  final String district;
  final String upazila;

  final double? pricePerUnit;
  final String? qualityRequirement;
  final String? description;
  final String? imageUrl;

  final String phone;
  final PostStatus status;
  final DateTime createdAt;

  const AgriculturePost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.isUserReviewed,
    required this.type,
    required this.category,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.availableFrom,
    required this.availableTo,
    required this.district,
    required this.upazila,
    this.pricePerUnit,
    this.qualityRequirement,
    this.description,
    this.imageUrl,
    required this.phone,
    required this.status,
    required this.createdAt,
  });
}
