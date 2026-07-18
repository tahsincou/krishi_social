import 'package:krishi_social/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:krishi_social/features/feed/data/models/agricultural_post_model.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  const FeedRepositoryImpl(this.remote);

  final FeedRemoteDataSource remote;

  @override
  Future<List<AgriculturePost>> getPosts() {
    return remote.getPosts();
  }

  @override
  Future<AgriculturePost> createPost(AgriculturePost post) {
    return remote.createPost(AgriculturalPostModel.fromEntity(post));
  }
}
