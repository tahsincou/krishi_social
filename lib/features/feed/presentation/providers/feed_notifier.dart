import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:krishi_social/features/auth/domain/entities/verification_status.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_status.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/params/create_agricultural_post_params.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_provider.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_state.dart';
import 'package:flutter/foundation.dart';

final feedNotifierProvider = StateNotifierProvider<FeedNotifier, FeedState>((
  ref,
) {
  final notifier = FeedNotifier(ref);

  Future.microtask(notifier.loadPosts);

  return notifier;
});

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier(this.ref) : super(const FeedState());

  final Ref ref;

  Future<void> loadPosts() async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final posts = await ref.read(getPostsUseCaseProvider)();

      state = state.copyWith(isLoading: false, posts: posts);
    } catch (error, stackTrace) {
      debugPrint('Load posts failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<bool> createPost(CreateAgriculturalPostParams params) async {
    state = state.copyWith(isCreating: true, clearError: true);

    try {
      final user = ref.read(authNotifierProvider).user;

      if (user == null) {
        state = state.copyWith(
          isCreating: false,
          error: 'Authenticated user not found',
        );

        return false;
      }

      final post = AgriculturePost(
        id: '',
        userId: user.id,
        userName: user.name,
        userImageUrl: null,
        isUserReviewed: user.verificationStatus == VerificationStatus.reviewed,
        type: params.type,
        category: params.category,
        productName: params.productName,
        quantity: params.quantity,
        unit: params.unit,
        availableFrom: params.availableFrom,
        availableTo: params.availableTo,
        district: params.location,
        upazila: '',
        pricePerUnit: params.pricePerUnit,
        qualityRequirement: params.qualityRequirement,
        description: params.description,
        imageUrl: null,
        phone: user.phone,
        status: PostStatus.active,
        createdAt: DateTime.now(),
      );

      await ref.read(createPostUseCaseProvider)(post);

      state = state.copyWith(isCreating: false);

      await loadPosts();

      return true;
    } catch (error, stackTrace) {
      debugPrint('Create post failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      state = state.copyWith(isCreating: false, error: error.toString());

      return false;
    }
  }

  Future<bool> updatePost(
    AgriculturePost existingPost,
    CreateAgriculturalPostParams params,
  ) async {
    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      final updatedPost = existingPost.copyWith(
        type: params.type,
        category: params.category,
        productName: params.productName,
        quantity: params.quantity,
        unit: params.unit,
        availableFrom: params.availableFrom,
        availableTo: params.availableTo,
        district: params.location,
        upazila: '',
        pricePerUnit: params.pricePerUnit,
        qualityRequirement: params.qualityRequirement,
        description: params.description,
      );

      await ref.read(updatePostUseCaseProvider)(updatedPost);

      state = state.copyWith(isUpdating: false);

      await loadPosts();

      return true;
    } catch (error) {
      state = state.copyWith(isUpdating: false, error: error.toString());

      return false;
    }
  }

  Future<bool> closePost(AgriculturePost post) async {
    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      await ref.read(updatePostUseCaseProvider)(
        post.copyWith(status: PostStatus.closed),
      );

      state = state.copyWith(isUpdating: false);

      await loadPosts();

      return true;
    } catch (error) {
      state = state.copyWith(isUpdating: false, error: error.toString());

      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      await ref.read(deletePostUseCaseProvider)(postId);

      state = state.copyWith(isUpdating: false);

      await loadPosts();

      return true;
    } catch (error) {
      state = state.copyWith(isUpdating: false, error: error.toString());

      return false;
    }
  }

  void updateSearch(String value) {
    state = state.copyWith(searchQuery: value.trim());
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  void selectCategory(ProductCategory? category) {
    if (category == null) {
      state = state.copyWith(clearSelectedCategory: true);
      return;
    }

    state = state.copyWith(selectedCategory: category);
  }
}
