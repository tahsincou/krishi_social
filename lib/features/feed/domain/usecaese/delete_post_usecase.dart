import 'package:krishi_social/features/feed/domain/repositories/feed_repository.dart';

class DeletePostUseCase {
  const DeletePostUseCase(this.repository);

  final FeedRepository repository;

  Future<void> call(String postId) {
    return repository.deletePost(postId);
  }
}
