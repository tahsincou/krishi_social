import 'package:flutter/foundation.dart';
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
  Future<List<AgriculturePost>> getPosts() async {
    try {
      final remotePosts = await remote.getPosts();

      try {
        await local.replacePosts(remotePosts);
      } catch (error, stackTrace) {
        debugPrint('Feed cache write failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      return remotePosts;
    } catch (remoteError, stackTrace) {
      debugPrint('Remote feed loading failed: $remoteError');
      debugPrintStack(stackTrace: stackTrace);

      final cachedPosts = await local.getPosts();

      if (cachedPosts.isNotEmpty) {
        return cachedPosts;
      }

      rethrow;
    }
  }

  @override
  Future<AgriculturePost> createPost(AgriculturePost post) async {
    final createdPost = await remote.createPost(
      AgriculturalPostModel.fromEntity(post),
    );

    return createdPost;
  }

  @override
  Future<AgriculturePost> updatePost(AgriculturePost post) {
    return remote.updatePost(AgriculturalPostModel.fromEntity(post));
  }

  @override
  Future<void> deletePost(String postId) {
    return remote.deletePost(postId);
  }
}
