import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/feed/data/mock/mock_agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';
import 'package:krishi_social/features/feed/presentation/widgets/agricultural_post_list.dart';
import 'package:krishi_social/shared/widgets/app_drawer.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  ProductCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buyPosts = _filterPosts(PostType.buy);
    final sellPosts = _filterPosts(PostType.sell);

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
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: context.l10n.searchProductOrLocation,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();

                            setState(() {
                              _searchQuery = '';
                            });
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
                    selected: _selectedCategory == null,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...ProductCategory.values.map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(category.displayName(context)),
                        selected: _selectedCategory == category,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: TabBarView(
                children: [
                  AgriculturePostList(posts: buyPosts),
                  AgriculturePostList(posts: sellPosts),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton.extended(
              onPressed: () {
                final tabIndex = DefaultTabController.of(context).index;

                final type = tabIndex == 0 ? PostType.buy : PostType.sell;

                context.push('/create-post', extra: type);
              },
              icon: const Icon(Icons.add),
              label: Text(context.l10n.createPost),
            );
          },
        ),
      ),
    );
  }

  List<AgriculturePost> _filterPosts(PostType type) {
    var posts = mockAgriculturePosts
        .where((post) => post.type == type)
        .toList();

    if (_selectedCategory != null) {
      posts = posts
          .where((post) => post.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      posts = posts.where((post) {
        final searchableText = [
          post.productName,
          post.category.displayName(context),
          post.district,
          post.upazila,
          post.userName,
        ].join(' ').toLowerCase();

        return searchableText.contains(_searchQuery);
      }).toList();
    }

    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return posts;
  }
}
