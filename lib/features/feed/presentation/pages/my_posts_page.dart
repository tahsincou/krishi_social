import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_status.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/features/feed/presentation/widgets/agricultural_post_card.dart';
import 'package:krishi_social/shared/widgets/app_empty.dart';
import 'package:krishi_social/shared/widgets/app_loading.dart';

class MyPostsPage extends ConsumerWidget {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedNotifierProvider);
    final posts = feedState.myPosts;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.myPosts)),
      body: feedState.isUpdating && posts.isEmpty
          ? const AppLoading()
          : posts.isEmpty
          ? AppEmpty(
              title: context.l10n.noPostsYet,
              message: context.l10n.createFirstPost,
              icon: Icons.post_add_outlined,
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Column(
                  children: [
                    AgriculturePostCard(post: post, onCall: null),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          if (post.status == PostStatus.active)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: feedState.isUpdating
                                    ? null
                                    : () => _closePost(context, ref, post),
                                icon: const Icon(Icons.check_circle_outline),
                                label: Text(context.l10n.closePost),
                              ),
                            ),
                          if (post.status == PostStatus.active)
                            const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: feedState.isUpdating
                                  ? null
                                  : () => _confirmDelete(context, ref, post),
                              icon: const Icon(Icons.delete_outline),
                              label: Text(context.l10n.delete),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
    );
  }

  Future<void> _closePost(
    BuildContext context,
    WidgetRef ref,
    AgriculturePost post,
  ) async {
    final success = await ref
        .read(feedNotifierProvider.notifier)
        .closePost(post);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? context.l10n.postClosed : context.l10n.actionFailed,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AgriculturePost post,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.l10n.deletePost),
          content: Text(context.l10n.deletePostConfirmation),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(context.l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final success = await ref
        .read(feedNotifierProvider.notifier)
        .deletePost(post.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? context.l10n.postDeleted : context.l10n.actionFailed,
        ),
      ),
    );
  }
}
