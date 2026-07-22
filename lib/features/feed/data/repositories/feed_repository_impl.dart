import 'package:krishi_social/features/feed/data/datasources/feed_local_datasource.dart';
import 'package:krishi_social/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:krishi_social/features/feed/data/models/agricultural_post_model.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/repositories/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  const FeedRepositoryImpl(this.remote, this.local);

  final FeedRemoteDataSource remote;
  final FeedLocalDataSource local;

  @override
  Future<List<AgriculturePost>> getCachedPosts() {
    return local.getPosts();
  }

  @override
  Future<List<AgriculturePost>> refreshPosts() async {
    final posts = await remote.getPosts();

    await local.replacePosts(posts);

    return posts;
  }

  @override
  Future<AgriculturePost> createPost(AgriculturePost post) async {
    final createdPost = await remote.createPost(
      AgriculturalPostModel.fromEntity(post),
    );

    await local.savePost(createdPost);

    return createdPost;
  }

  @override
  Future<AgriculturePost> updatePost(AgriculturePost post) async {
    final updatedPost = await remote.updatePost(
      AgriculturalPostModel.fromEntity(post),
    );

    await local.savePost(updatedPost);

    return updatedPost;
  }

  @override
  Future<void> deletePost(String postId) async {
    await remote.deletePost(postId);

    await local.deletePost(postId);
  }
}
