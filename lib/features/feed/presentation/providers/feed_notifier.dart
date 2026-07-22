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

final feedNotifierProvider = StateNotifierProvider<FeedNotifier, FeedState>(
  (ref) => FeedNotifier(ref),
);

class FeedNotifier extends StateNotifier<FeedState> {
  FeedNotifier(this.ref) : super(const FeedState());

  final Ref ref;

  Future<void> initialize() async {
    if (state.isInitialLoading || state.isRefreshing) {
      return;
    }

    state = state.copyWith(
      isInitialLoading: state.posts.isEmpty,
      clearError: true,
    );

    if (state.posts.isEmpty) {
      try {
        final cachedPosts = await ref.read(getCachedPostsUseCaseProvider)();

        state = state.copyWith(posts: cachedPosts, isInitialLoading: false);
      } catch (error, stackTrace) {
        debugPrint('Cached feed loading failed: $error');
        debugPrintStack(stackTrace: stackTrace);

        state = state.copyWith(isInitialLoading: false);
      }
    }

    await refreshPosts();
  }

  Future<void> refreshPosts() async {
    if (state.isRefreshing) {
      return;
    }

    state = state.copyWith(isRefreshing: true, clearError: true);

    try {
      final posts = await ref.read(refreshPostsUseCaseProvider)();

      state = state.copyWith(
        posts: posts,
        isRefreshing: false,
        isOffline: false,
        clearError: true,
      );
    } catch (error, stackTrace) {
      debugPrint('Remote feed refresh failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      state = state.copyWith(
        isRefreshing: false,
        isOffline: true,
        error: error.toString(),
      );
    }
  }

  Future<bool> createPost(CreateAgriculturalPostParams params) async {
    if (!_canWrite()) {
      return false;
    }
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

      final createdPost = await ref.read(createPostUseCaseProvider)(post);

      state = state.copyWith(
        isCreating: false,
        posts: [createdPost, ...state.posts],
        isOffline: false,
        clearError: true,
      );

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
    if (!_canWrite()) {
      return false;
    }
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

      final savedPost = await ref.read(updatePostUseCaseProvider)(updatedPost);

      final posts = state.posts.map((post) {
        return post.id == savedPost.id ? savedPost : post;
      }).toList();

      state = state.copyWith(
        isUpdating: false,
        posts: posts,
        isOffline: false,
        clearError: true,
      );

      return true;
    } catch (error) {
      state = state.copyWith(isUpdating: false, error: error.toString());

      return false;
    }
  }

  Future<bool> closePost(AgriculturePost post) async {
    if (!_canWrite()) {
      return false;
    }
    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      final savedPost = await ref.read(updatePostUseCaseProvider)(
        post.copyWith(status: PostStatus.closed),
      );

      final posts = state.posts.map((item) {
        return item.id == savedPost.id ? savedPost : item;
      }).toList();

      state = state.copyWith(
        isUpdating: false,
        posts: posts,
        isOffline: false,
        clearError: true,
      );

      return true;
    } catch (error) {
      state = state.copyWith(isUpdating: false, error: error.toString());

      return false;
    }
  }

  Future<bool> deletePost(String postId) async {
    if (!_canWrite()) {
      return false;
    }
    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      await ref.read(deletePostUseCaseProvider)(postId);

      state = state.copyWith(
        isUpdating: false,
        posts: state.posts.where((post) => post.id != postId).toList(),
        isOffline: false,
        clearError: true,
      );

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

  bool _canWrite() {
    if (!state.isOffline) {
      return true;
    }

    state = state.copyWith(error: 'offline_write_unavailable');

    return false;
  }
}
