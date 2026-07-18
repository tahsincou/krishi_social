import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/providers/providers.dart';
import 'package:krishi_social/features/feed/domain/usecaese/create_post_usecase.dart';
import 'package:krishi_social/features/feed/domain/usecaese/get_posts_usecase.dart';

final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  return GetPostsUseCase(ref.read(feedRepositoryProvider));
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  return CreatePostUseCase(ref.read(feedRepositoryProvider));
});
