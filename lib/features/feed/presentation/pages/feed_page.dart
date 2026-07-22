import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
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
    final feedState = ref.watch(feedNotifierProvider);

    final buyPosts = feedState.postsByType(PostType.buy);
    final sellPosts = feedState.postsByType(PostType.sell);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text(context.l10n.appName),
          bottom: TabBar(
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
          ),
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
            Padding(
              padding: const EdgeInsets.all(12),
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
                            ref
                                .read(feedNotifierProvider.notifier)
                                .clearSearch();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),

            SizedBox(
              height: 48,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    label: Text(context.l10n.all),
                    selected: feedState.selectedCategory == null,
                    onSelected: (_) {
                      ref
                          .read(feedNotifierProvider.notifier)
                          .selectCategory(null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ...ProductCategory.values.map(
                    (category) => Padding(
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
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            Expanded(
              child: Builder(
                builder: (context) {
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
                          return ref
                              .read(feedNotifierProvider.notifier)
                              .refreshPosts();
                        },
                        child: AgriculturePostList(posts: buyPosts),
                      ),
                      RefreshIndicator(
                        onRefresh: () {
                          return ref
                              .read(feedNotifierProvider.notifier)
                              .refreshPosts();
                        },
                        child: AgriculturePostList(posts: sellPosts),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () {
                final tabIndex = DefaultTabController.of(context).index;

                final type = tabIndex == 0 ? PostType.buy : PostType.sell;

                context.push('/create-post', extra: type);
              },
              child: Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
