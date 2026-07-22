import 'package:krishi_social/features/feed/data/models/agricultural_post_model.dart';

abstract class FeedLocalDataSource {
  Future<List<AgriculturalPostModel>> getPosts();

  Future<void> replacePosts(List<AgriculturalPostModel> posts);

  Future<void> savePost(AgriculturalPostModel post);

  Future<void> deletePost(String postId);
}
