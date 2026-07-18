import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/providers/providers.dart';
import 'package:krishi_social/features/feed/data/datasources/delete_post_usecase.dart';
import 'package:krishi_social/features/feed/domain/usecaese/create_post_usecase.dart';
import 'package:krishi_social/features/feed/domain/usecaese/get_posts_usecase.dart';
import 'package:krishi_social/features/feed/domain/usecaese/update_post_usecase.dart';

final getPostsUseCaseProvider = Provider<GetPostsUseCase>((ref) {
  return GetPostsUseCase(ref.read(feedRepositoryProvider));
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  return CreatePostUseCase(ref.read(feedRepositoryProvider));
});

final updatePostUseCaseProvider = Provider<UpdatePostUseCase>((ref) {
  return UpdatePostUseCase(ref.read(feedRepositoryProvider));
});

final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  return DeletePostUseCase(ref.read(feedRepositoryProvider));
});
