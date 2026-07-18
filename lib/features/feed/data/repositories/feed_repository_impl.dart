import 'package:krishi_social/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:krishi_social/features/feed/data/models/agricultural_post_model.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  const FeedRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<AgriculturePost>> getPosts() {
    return remoteDataSource.getPosts();
  }

  @override
  Future<AgriculturePost> createPost(AgriculturePost post) {
    final model = AgriculturalPostModel(
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

    return remoteDataSource.createPost(model);
  }
}
