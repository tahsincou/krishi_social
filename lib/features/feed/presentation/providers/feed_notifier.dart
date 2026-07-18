import 'package:flutter_riverpod/legacy.dart';
import 'package:krishi_social/core/providers/repository_providers.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_status.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/params/create_agricultural_post_params.dart';
import 'package:krishi_social/features/feed/domain/repositories/feed_repository.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_state.dart';

final feedNotifierProvider = StateNotifierProvider<FeedNotifier, FeedState>((
  ref,
) {
  return FeedNotifier(ref.watch(feedRepositoryProvider));
});

class FeedNotifier extends StateNotifier<FeedState> {
  final FeedRepository repository;

  FeedNotifier(this.repository) : super(const FeedState());

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final posts = await repository.getPosts();

      state = state.copyWith(isLoading: false, posts: posts);
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
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

  Future<bool> createPost(CreateAgriculturalPostParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final now = DateTime.now();

      final post = AgriculturePost(
        id: now.microsecondsSinceEpoch.toString(),
        userId: 'current-user',
        userName: 'My Account',
        isUserReviewed: false,
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
        phone: '01700000000',
        status: PostStatus.active,
        createdAt: now,
      );

      final createdPost = await repository.createPost(post);

      state = state.copyWith(
        isLoading: false,
        posts: [createdPost, ...state.posts],
      );

      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());

      return false;
    }
  }
}
