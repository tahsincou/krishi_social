import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';
import 'package:krishi_social/features/auth/domain/extensions/account_activity_extension.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_state.dart';
import 'package:krishi_social/features/feed/presentation/widgets/agricultural_post_list.dart';
import 'package:krishi_social/shared/widgets/app_drawer.dart';
import 'package:krishi_social/shared/widgets/app_empty.dart';
import 'package:krishi_social/shared/widgets/app_loading.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final feedState = ref.watch(feedNotifierProvider);

    final user = authState.user;

    if (user == null) {
      return const Scaffold(body: AppLoading());
    }

    final activity = user.activity;
    final showBothTabs = activity == AccountActivity.both;

    final buyPosts = feedState.postsByType(PostType.buy);

    final sellPosts = feedState.postsByType(PostType.sell);

    if (showBothTabs) {
      return DefaultTabController(
        length: 2,
        child: _buildScaffold(
          feedState: feedState,
          activity: activity,
          buyPosts: buyPosts,
          sellPosts: sellPosts,
          showTabs: true,
        ),
      );
    }

    return _buildScaffold(
      feedState: feedState,
      activity: activity,
      buyPosts: buyPosts,
      sellPosts: sellPosts,
      showTabs: false,
    );
  }

  Widget _buildScaffold({
    required FeedState feedState,
    required AccountActivity activity,
    required List<AgriculturePost> buyPosts,
    required List<AgriculturePost> sellPosts,
    required bool showTabs,
  }) {
    final visiblePosts = activity == AccountActivity.sell
        ? sellPosts
        : buyPosts;

    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: Text(_feedTitle(activity)),
        bottom: showTabs
            ? TabBar(
                tabs: [
                  Tab(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    text: context.l10n.buy,
                  ),
                  Tab(
                    icon: const Icon(Icons.agriculture_outlined),
                    text: context.l10n.sell,
                  ),
                ],
              )
            : null,
        actions: [
          if (feedState.isOffline)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                avatar: const Icon(Icons.cloud_off_outlined, size: 18),
                label: Text(context.l10n.offline),
              ),
            ),
        ],
      ),

      body: Column(
        children: [
          _buildCategoryFilters(feedState),

          const SizedBox(height: 8),

          _buildSearchField(feedState),

          const SizedBox(height: 8),

          Expanded(
            child: _buildFeedContent(
              feedState: feedState,
              showTabs: showTabs,
              visiblePosts: visiblePosts,
              buyPosts: buyPosts,
              sellPosts: sellPosts,
            ),
          ),
        ],
      ),

      floatingActionButton: Builder(
        builder: (tabContext) {
          return FloatingActionButton.extended(
            onPressed: () {
              _openCreatePost(
                tabContext: tabContext,
                activity: activity,
                showTabs: showTabs,
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: Text(_createButtonLabel(activity)),
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilters(FeedState feedState) {
    return SizedBox(
      height: 48,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            label: Text(context.l10n.all),
            selected: feedState.selectedCategory == null,
            onSelected: (_) {
              ref.read(feedNotifierProvider.notifier).selectCategory(null);
            },
          ),
          const SizedBox(width: 8),
          ...ProductCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(category.displayName(context)),
                selected: feedState.selectedCategory == category,
                onSelected: (_) {
                  ref
                      .read(feedNotifierProvider.notifier)
                      .selectCategory(category);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchField(FeedState feedState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(feedNotifierProvider.notifier).updateSearch(value);
        },
        decoration: InputDecoration(
          hintText: context.l10n.searchProductOrLocation,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: feedState.searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();

                    ref.read(feedNotifierProvider.notifier).clearSearch();
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFeedContent({
    required FeedState feedState,
    required bool showTabs,
    required List<AgriculturePost> visiblePosts,
    required List<AgriculturePost> buyPosts,
    required List<AgriculturePost> sellPosts,
  }) {
    if (feedState.isInitialLoading && feedState.posts.isEmpty) {
      return const AppLoading();
    }

    if (feedState.error != null && feedState.posts.isEmpty) {
      return AppEmpty(
        title: context.l10n.couldNotLoadPosts,
        message: context.l10n.checkConnectionAndTryAgain,
        icon: Icons.cloud_off_outlined,
      );
    }

    if (showTabs) {
      return TabBarView(
        children: [_buildPostList(buyPosts), _buildPostList(sellPosts)],
      );
    }

    return _buildPostList(visiblePosts);
  }

  Widget _buildPostList(List<AgriculturePost> posts) {
    return RefreshIndicator(
      onRefresh: () {
        return ref.read(feedNotifierProvider.notifier).refreshPosts();
      },
      child: AgriculturePostList(posts: posts),
    );
  }

  void _openCreatePost({
    required BuildContext tabContext,
    required AccountActivity activity,
    required bool showTabs,
  }) {
    if (ref.read(feedNotifierProvider).isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.offlineChangesUnavailable)),
      );

      return;
    }

    final PostType postType;

    if (showTabs) {
      final tabIndex = DefaultTabController.of(tabContext).index;

      postType = tabIndex == 0 ? PostType.buy : PostType.sell;
    } else {
      postType = activity.defaultCreatePostType;
    }

    context.push('/create-post', extra: postType);
  }

  String _feedTitle(AccountActivity activity) {
    switch (activity) {
      case AccountActivity.buy:
        return context.l10n.buyPosts;

      case AccountActivity.sell:
        return context.l10n.sellPosts;

      case AccountActivity.both:
        return context.l10n.appName;
    }
  }

  String _createButtonLabel(AccountActivity activity) {
    switch (activity) {
      case AccountActivity.buy:
        return context.l10n.createBuyPost;

      case AccountActivity.sell:
        return context.l10n.createSellPost;

      case AccountActivity.both:
        return context.l10n.createPost;
    }
  }
}
