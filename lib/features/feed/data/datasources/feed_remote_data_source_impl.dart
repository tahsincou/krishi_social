import 'package:krishi_social/core/network/api_client.dart';
import 'package:krishi_social/features/feed/data/datasources/feed_remote_data_source.dart';
import 'package:krishi_social/features/feed/data/models/agricultural_post_model.dart';

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final ApiClient apiClient;

  const FeedRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<AgriculturalPostModel>> getPosts() async {
    final response = await apiClient.get('/posts');

    final data = response.data as List<dynamic>;

    return data
        .map(
          (json) =>
              AgriculturalPostModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<AgriculturalPostModel> createPost(AgriculturalPostModel post) async {
    final response = await apiClient.post('/posts', data: post.toJson());

    return AgriculturalPostModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
