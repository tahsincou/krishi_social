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
import 'package:krishi_social/shared/theme/app_colors.dart';
import 'package:krishi_social/shared/theme/app_radius.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
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
    final visiblePosts = activity == AccountActivity.buy ? sellPosts : buyPosts;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(context.l10n.appName),
        actions: [
          if (feedState.isOffline)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Center(child: _OfflineBadge(label: context.l10n.offline)),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroduction(activity),

          const SizedBox(height: AppSpacing.md),

          if (showTabs) ...[
            _buildPostTypeTabs(),
            const SizedBox(height: AppSpacing.md),
          ],

          _buildSearchField(feedState),

          const SizedBox(height: AppSpacing.md),

          _buildCategoryFilters(feedState),

          const SizedBox(height: AppSpacing.md),

          if (!showTabs)
            _buildResultSummary(count: visiblePosts.length, activity: activity),

          if (showTabs)
            _BothRoleResultSummary(
              buyCount: buyPosts.length,
              sellCount: sellPosts.length,
            ),

          const SizedBox(height: AppSpacing.sm),

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

  Widget _buildIntroduction(AccountActivity activity) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _pageHeading(activity),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _pageSupportingText(activity),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          tabs: [
            Tab(
              icon: const Icon(Icons.shopping_cart_outlined, size: 19),
              text: context.l10n.buy,
            ),
            Tab(
              icon: const Icon(Icons.agriculture_outlined, size: 19),
              text: context.l10n.sell,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(FeedState feedState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          ref.read(feedNotifierProvider.notifier).updateSearch(value);
        },
        decoration: InputDecoration(
          hintText: context.l10n.searchProductOrLocation,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: feedState.searchQuery.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();

                    ref.read(feedNotifierProvider.notifier).clearSearch();
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(FeedState feedState) {
    return SizedBox(
      height: 46,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            avatar: const Icon(Icons.grid_view_rounded, size: 17),
            label: Text(context.l10n.all),
            selected: feedState.selectedCategory == null,
            onSelected: (_) {
              ref.read(feedNotifierProvider.notifier).selectCategory(null);
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          ...ProductCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
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

  Widget _buildResultSummary({
    required int count,
    required AccountActivity activity,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _resultText(count: count, activity: activity),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (count > 0)
            Text(
              context.l10n.latestFirst,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
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

  String _pageHeading(AccountActivity activity) {
    switch (activity) {
      case AccountActivity.buy:
        return context.l10n.whatDoYouWantToBuy;

      case AccountActivity.sell:
        return context.l10n.whatDoYouWantToSell;

      case AccountActivity.both:
        return context.l10n.buyAndSellPosts;
    }
  }

  String _pageSupportingText(AccountActivity activity) {
    switch (activity) {
      case AccountActivity.buy:
        return context.l10n.findSellOffersMessage;

      case AccountActivity.sell:
        return context.l10n.findBuyRequestsMessage;

      case AccountActivity.both:
        return context.l10n.findBuyAndSellPostsMessage;
    }
  }

  String _resultText({required int count, required AccountActivity activity}) {
    switch (activity) {
      case AccountActivity.buy:
        return context.l10n.sellPostResults(count);

      case AccountActivity.sell:
        return context.l10n.buyPostResults(count);

      case AccountActivity.both:
        return context.l10n.postResults(count);
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

class _BothRoleResultSummary extends StatelessWidget {
  const _BothRoleResultSummary({
    required this.buyCount,
    required this.sellCount,
  });

  final int buyCount;
  final int sellCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text(
        context.l10n.buyAndSellResultSummary(buyCount, sellCount),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _OfflineBadge extends StatelessWidget {
  const _OfflineBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 16,
            color: AppColors.accentDark,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.accentDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
