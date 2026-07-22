import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/repositories/feed_repository.dart';

class GetCachedPostsUseCase {
  const GetCachedPostsUseCase(this.repository);

  final FeedRepository repository;

  Future<List<AgriculturePost>> call() {
    return repository.getCachedPosts();
  }
}
