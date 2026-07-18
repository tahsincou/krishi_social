import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/repositories/feed_repository.dart';

class GetPostsUseCase {
  const GetPostsUseCase(this.repository);

  final FeedRepository repository;

  Future<List<AgriculturePost>> call() {
    return repository.getPosts();
  }
}
