import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_status.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/entities/quantity_unit.dart';

class AgriculturalPostModel extends AgriculturePost {
  const AgriculturalPostModel({
    required super.id,
    required super.userId,
    required super.userName,
    super.userImageUrl,
    required super.isUserReviewed,
    required super.type,
    required super.category,
    required super.productName,
    required super.quantity,
    required super.unit,
    required super.availableFrom,
    required super.availableTo,
    required super.district,
    required super.upazila,
    super.pricePerUnit,
    super.qualityRequirement,
    super.description,
    super.imageUrl,
    required super.phone,
    required super.status,
    required super.createdAt,
  });

  factory AgriculturalPostModel.fromJson(Map<String, dynamic> json) {
    return AgriculturalPostModel(
      id: json['id'].toString(),
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userImageUrl: json['userImageUrl'] as String?,
      isUserReviewed: json['isUserReviewed'] as bool? ?? false,
      type: PostType.values.byName(json['type'] as String),
      category: ProductCategory.values.byName(json['category'] as String),
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: QuantityUnit.values.byName(json['unit'] as String),
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: DateTime.parse(json['availableTo'] as String),
      district: json['district'] as String,
      upazila: json['upazila'] as String? ?? '',
      pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble(),
      qualityRequirement: json['qualityRequirement'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      phone: json['phone'] as String,
      status: PostStatus.values.byName(json['status'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'isUserReviewed': isUserReviewed,
      'type': type.name,
      'category': category.name,
      'productName': productName,
      'quantity': quantity,
      'unit': unit.name,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
      'district': district,
      'upazila': upazila,
      'pricePerUnit': pricePerUnit,
      'qualityRequirement': qualityRequirement,
      'description': description,
      'imageUrl': imageUrl,
      'phone': phone,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
