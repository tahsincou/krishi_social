import 'package:krishi_social/core/network/api_client.dart';
import 'package:krishi_social/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:krishi_social/features/feed/data/models/agricultural_post_model.dart';

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  const FeedRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<AgriculturalPostModel>> getPosts() async {
    final response = await apiClient.get('/posts');
    final data = response.data as List<dynamic>;

    return data
        .map(
          (item) =>
              AgriculturalPostModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<AgriculturalPostModel> createPost(AgriculturalPostModel post) async {
    final response = await apiClient.post(
      '/posts',
      data: post.toJson(includeId: false),
    );

    return AgriculturalPostModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
