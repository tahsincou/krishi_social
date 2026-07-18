import 'package:flutter/material.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/presentation/widgets/agricultural_post_card.dart';

class AgriculturePostList extends StatelessWidget {
  final List<AgriculturePost> posts;

  const AgriculturePostList({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(child: Text('No posts found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 6),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return AgriculturePostCard(
          post: post,
          onCall: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Calling ${post.userName}')));
          },
          onComment: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Comments will be added later')),
            );
          },
          onSave: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Post saved')));
          },
        );
      },
    );
  }
}
