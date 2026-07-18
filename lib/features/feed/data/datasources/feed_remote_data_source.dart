import 'package:krishi_social/features/feed/data/models/agricultural_post_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<AgriculturalPostModel>> getPosts();

  Future<AgriculturalPostModel> createPost(AgriculturalPostModel post);
}
