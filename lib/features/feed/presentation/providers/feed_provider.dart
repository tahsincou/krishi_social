import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/providers/providers.dart';
import 'package:krishi_social/features/feed/data/datasources/delete_post_usecase.dart';
import 'package:krishi_social/features/feed/domain/usecaese/create_post_usecase.dart';
import 'package:krishi_social/features/feed/domain/usecaese/get_cached_posts_usecase.dart';
import 'package:krishi_social/features/feed/domain/usecaese/refresh_posts_use_case.dart';
import 'package:krishi_social/features/feed/domain/usecaese/update_post_usecase.dart';

final getCachedPostsUseCaseProvider = Provider<GetCachedPostsUseCase>((ref) {
  return GetCachedPostsUseCase(ref.read(feedRepositoryProvider));
});

final refreshPostsUseCaseProvider = Provider<RefreshPostsUseCase>((ref) {
  return RefreshPostsUseCase(ref.read(feedRepositoryProvider));
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
