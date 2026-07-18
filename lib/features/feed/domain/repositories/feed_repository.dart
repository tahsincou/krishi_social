import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';

abstract class FeedRepository {
  Future<List<AgriculturePost>> getPosts();

  Future<AgriculturePost> createPost(AgriculturePost post);
}
