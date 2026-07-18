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
}
