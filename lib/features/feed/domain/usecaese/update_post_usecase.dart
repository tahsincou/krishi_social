import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/repositories/feed_repository.dart';

class UpdatePostUseCase {
  const UpdatePostUseCase(this.repository);

  final FeedRepository repository;

  Future<AgriculturePost> call(AgriculturePost post) {
    return repository.updatePost(post);
  }
}
