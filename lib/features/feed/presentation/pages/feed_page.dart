import 'package:flutter/material.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';

import '../../data/mock/mock_agricultural_post.dart';
import '../widgets/agricultural_post_list.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final buyPosts = mockAgriculturePosts
        .where((post) => post.type == PostType.buy)
        .toList();

    final sellPosts = mockAgriculturePosts
        .where((post) => post.type == PostType.sell)
        .toList();

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
        body: TabBarView(
          children: [
            AgriculturePostList(posts: buyPosts),
            AgriculturePostList(posts: sellPosts),
          ],
        ),
      ),
    );
  }
}
