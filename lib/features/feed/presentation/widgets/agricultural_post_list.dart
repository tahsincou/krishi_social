import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/providers/contact_providers.dart';
import 'package:krishi_social/core/services/contact_service.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/presentation/widgets/agricultural_post_card.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_empty.dart';

class AgriculturePostList extends ConsumerWidget {
  final List<AgriculturePost> posts;

  const AgriculturePostList({super.key, required this.posts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (posts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: const AppEmpty(),
          ),
        ],
      );
    }

    Future<void> _callUser(
      BuildContext context,
      WidgetRef ref,
      AgriculturePost post,
    ) async {
      try {
        await ref.read(contactServiceProvider).call(post.phone);
      } on ContactException catch (error) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      } catch (_) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to start the call.')),
        );
      }
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: 100),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];

        return AgriculturePostCard(
          post: post,
          onTap: () {
            context.push('/post-details', extra: post);
          },
          onCall: () {
            _callUser(context, ref, post);
          },
        );
      },
    );
  }
}
