import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_status.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/features/feed/presentation/widgets/agricultural_post_card.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_empty.dart';
import 'package:krishi_social/shared/widgets/app_loading.dart';

class MyPostsPage extends ConsumerWidget {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final feedState = ref.watch(feedNotifierProvider);

    final userId = authState.user?.id;

    final posts = userId == null
        ? const <AgriculturePost>[]
        : feedState.postsByUser(userId);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.myPosts)),
      body: feedState.isLoading && posts.isEmpty
          ? const AppLoading()
          : posts.isEmpty
          ? AppEmpty(
              title: context.l10n.noPostsYet,
              message: context.l10n.createFirstPost,
              icon: Icons.post_add_outlined,
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: posts.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final post = posts[index];

                return _MyPostItem(
                  post: post,
                  isUpdating: feedState.isUpdating,
                  onClose: () => _closePost(context, ref, post),
                  onDelete: () => _confirmDelete(context, ref, post),
                  onEdit: () {
                    context.push('/edit-post', extra: post);
                  },
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

class _MyPostItem extends StatelessWidget {
  const _MyPostItem({
    required this.post,
    required this.isUpdating,
    required this.onEdit,
    required this.onClose,
    required this.onDelete,
  });

  final VoidCallback onEdit;

  final AgriculturePost post;
  final bool isUpdating;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isClosed = post.status == PostStatus.closed;

    return Column(
      children: [
        AgriculturePostCard(post: post, onCall: null),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Chip(
                label: Text(
                  isClosed ? context.l10n.closed : context.l10n.active,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: isUpdating ? null : onEdit,
                tooltip: context.l10n.editPost,
                icon: const Icon(Icons.edit_outlined),
              ),
              if (!isClosed)
                TextButton.icon(
                  onPressed: isUpdating ? null : onClose,
                  icon: const Icon(Icons.check_circle_outline),
                  label: Text(context.l10n.closePost),
                ),
              IconButton(
                onPressed: isUpdating ? null : onDelete,
                tooltip: context.l10n.delete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
