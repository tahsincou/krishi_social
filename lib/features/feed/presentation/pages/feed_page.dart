import 'package:flutter/material.dart';
import 'package:krishi_social/features/feed/data/mock/mock_agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/presentation/widgets/agricultural_post_list.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

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
        appBar: AppBar(
          title: const Text('Krishi Social'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.shopping_cart_outlined), text: 'Buy'),
              Tab(icon: Icon(Icons.agriculture_outlined), text: 'Sell'),
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
                  hintText: 'Search product or location',
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
      ),
    );
  }

  List<AgriculturePost> _filterPosts(PostType type) {
    final posts = mockAgriculturePosts
        .where((post) => post.type == type)
        .toList();

    if (_searchQuery.isEmpty) {
      return posts;
    }

    return posts.where((post) {
      final searchableText = [
        post.product,
        post.category,
        post.district,
        post.upazila,
        post.userName,
      ].join(' ').toLowerCase();

      return searchableText.contains(_searchQuery);
    }).toList();
  }
}
