import 'package:krishi_social/features/feed/data/datasources/feed_local_datasource.dart';
import 'package:krishi_social/features/feed/data/models/agricultural_post_model.dart';

class FeedMemoryDataSourceImpl implements FeedLocalDataSource {
  List<AgriculturalPostModel> _posts = [];

  @override
  Future<List<AgriculturalPostModel>> getPosts() async {
    return List.unmodifiable(_posts);
  }

  @override
  Future<void> replacePosts(List<AgriculturalPostModel> posts) async {
    _posts = List<AgriculturalPostModel>.from(posts);
  }

  @override
  Future<void> savePost(AgriculturalPostModel post) async {
    final index = _posts.indexWhere((item) => item.id == post.id);

    if (index == -1) {
      _posts = [post, ..._posts];
      return;
    }

    final updatedPosts = List<AgriculturalPostModel>.from(_posts);

    updatedPosts[index] = post;
    _posts = updatedPosts;
  }

  @override
  Future<void> deletePost(String postId) async {
    _posts = _posts.where((post) => post.id != postId).toList();
  }
}
