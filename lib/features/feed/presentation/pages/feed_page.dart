import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_state.dart';
import 'package:krishi_social/features/feed/presentation/widgets/agricultural_post_list.dart';
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
    final feedState = ref.watch(feedNotifierProvider);

    final buyPosts = feedState.postsByType(PostType.buy);
    final sellPosts = feedState.postsByType(PostType.sell);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const AppDrawer(),

        appBar: AppBar(
          title: Text(context.l10n.appName),
          actions: [
            if (feedState.isOffline)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_off_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.offline,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPostTypeTabs(context),

            const SizedBox(height: AppSpacing.md),

            _buildCategoryFilters(feedState),

            const SizedBox(height: AppSpacing.md),

            _buildSearchField(feedState),

            const SizedBox(height: AppSpacing.sm),

            Expanded(
              child: _buildFeedContent(
                feedState: feedState,
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
                _openCreatePost(tabContext, feedState.isOffline);
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(context.l10n.createPost),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageIntroduction(BuildContext context) {
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
            context.l10n.findAgriculturalProducts,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            context.l10n.buyDirectlyFromPeople,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(50),
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(50),
          ),
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
          tabs: [
            Tab(
              icon: const Icon(Icons.shopping_bag_outlined, size: 20),
              text: context.l10n.buy,
            ),
            Tab(
              icon: const Icon(Icons.agriculture_outlined, size: 20),
              text: context.l10n.sell,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(FeedState feedState) {
    return SizedBox(
      height: 44,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
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

  Widget _buildFeedContent({
    required FeedState feedState,
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

    return TabBarView(
      children: [
        RefreshIndicator(
          onRefresh: () {
            return ref.read(feedNotifierProvider.notifier).refreshPosts();
          },
          child: AgriculturePostList(posts: buyPosts),
        ),
        RefreshIndicator(
          onRefresh: () {
            return ref.read(feedNotifierProvider.notifier).refreshPosts();
          },
          child: AgriculturePostList(posts: sellPosts),
        ),
      ],
    );
  }

  void _openCreatePost(BuildContext tabContext, bool isOffline) {
    if (isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.offlineChangesUnavailable)),
      );

      return;
    }

    final tabIndex = DefaultTabController.of(tabContext).index;

    final postType = tabIndex == 0 ? PostType.buy : PostType.sell;

    context.push('/create-post', extra: postType);
  }
}
