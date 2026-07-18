import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';

class FeedState {
  final bool isLoading;
  final List<AgriculturePost> posts;
  final String searchQuery;
  final ProductCategory? selectedCategory;
  final String? error;

  const FeedState({
    this.isLoading = false,
    this.posts = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.error,
  });

  FeedState copyWith({
    bool? isLoading,
    List<AgriculturePost>? posts,
    String? searchQuery,
    ProductCategory? selectedCategory,
    bool clearSelectedCategory = false,
    String? error,
    bool clearError = false,
  }) {
    return FeedState(
      isLoading: isLoading ?? this.isLoading,
      posts: posts ?? this.posts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearSelectedCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
      error: clearError ? null : error ?? this.error,
    );
  }

  List<AgriculturePost> postsByType(PostType type) {
    var result = posts.where((post) => post.type == type).toList();

    if (selectedCategory != null) {
      result = result
          .where((post) => post.category == selectedCategory)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();

      result = result.where((post) {
        return post.productName.toLowerCase().contains(query) ||
            post.userName.toLowerCase().contains(query) ||
            post.district.toLowerCase().contains(query) ||
            post.upazila.toLowerCase().contains(query);
      }).toList();
    }

    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return result;
  }
}
