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
      userId: json['userId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      userImageUrl: json['userImageUrl']?.toString(),
      isUserReviewed: json['isUserReviewed'] as bool? ?? false,
      type: PostType.values.byName(json['type'] as String),
      category: ProductCategory.values.byName(json['category'] as String),
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: QuantityUnit.values.byName(json['unit'] as String),
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableTo: DateTime.parse(json['availableTo'] as String),
      district: json['district']?.toString() ?? '',
      upazila: json['upazila']?.toString() ?? '',
      pricePerUnit: (json['pricePerUnit'] as num?)?.toDouble(),
      qualityRequirement: json['qualityRequirement']?.toString(),
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      phone: json['phone']?.toString() ?? '',
      status: PostStatus.values.byName(
        json['status'] as String? ?? PostStatus.active.name,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  factory AgriculturalPostModel.fromEntity(AgriculturePost post) {
    return AgriculturalPostModel(
      id: post.id,
      userId: post.userId,
      userName: post.userName,
      userImageUrl: post.userImageUrl,
      isUserReviewed: post.isUserReviewed,
      type: post.type,
      category: post.category,
      productName: post.productName,
      quantity: post.quantity,
      unit: post.unit,
      availableFrom: post.availableFrom,
      availableTo: post.availableTo,
      district: post.district,
      upazila: post.upazila,
      pricePerUnit: post.pricePerUnit,
      qualityRequirement: post.qualityRequirement,
      description: post.description,
      imageUrl: post.imageUrl,
      phone: post.phone,
      status: post.status,
      createdAt: post.createdAt,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    return {
      if (includeId) 'id': id,
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

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_image_url': userImageUrl,
      'is_user_reviewed': isUserReviewed ? 1 : 0,
      'type': type.name,
      'category': category.name,
      'product_name': productName,
      'quantity': quantity,
      'unit': unit.name,
      'available_from': availableFrom.toIso8601String(),
      'available_to': availableTo.toIso8601String(),
      'district': district,
      'upazila': upazila,
      'price_per_unit': pricePerUnit,
      'quality_requirement': qualityRequirement,
      'description': description,
      'image_url': imageUrl,
      'phone': phone,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory AgriculturalPostModel.fromDatabase(Map<String, dynamic> map) {
    return AgriculturalPostModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      userName: map['user_name'] as String,
      userImageUrl: map['user_image_url'] as String?,
      isUserReviewed: map['is_user_reviewed'] == 1,
      type: PostType.values.byName(map['type'] as String),
      category: ProductCategory.values.byName(map['category'] as String),
      productName: map['product_name'] as String,
      quantity: (map['quantity'] as num).toDouble(),
      unit: QuantityUnit.values.byName(map['unit'] as String),
      availableFrom: DateTime.parse(map['available_from'] as String),
      availableTo: DateTime.parse(map['available_to'] as String),
      district: map['district'] as String,
      upazila: map['upazila'] as String,
      pricePerUnit: (map['price_per_unit'] as num?)?.toDouble(),
      qualityRequirement: map['quality_requirement'] as String?,
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
      phone: map['phone'] as String,
      status: PostStatus.values.byName(map['status'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}
