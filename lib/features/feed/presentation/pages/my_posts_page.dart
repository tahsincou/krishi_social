import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_status.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/features/feed/presentation/widgets/agricultural_post_card.dart';
import 'package:krishi_social/shared/theme/app_radius.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_card.dart';
import 'package:krishi_social/shared/widgets/app_empty.dart';
import 'package:krishi_social/shared/widgets/app_loading.dart';

class MyPostsPage extends ConsumerWidget {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final feedState = ref.watch(feedNotifierProvider);

    final user = authState.user;

    final posts = user == null
        ? const <AgriculturePost>[]
        : feedState.postsByUser(user.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myPosts),
        actions: [
          if (feedState.isOffline)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Center(child: _OfflineBadge(label: context.l10n.offline)),
            ),
        ],
      ),
      body: _buildBody(
        context: context,
        ref: ref,
        feedState: feedState,
        posts: posts,
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required WidgetRef ref,
    required dynamic feedState,
    required List<AgriculturePost> posts,
  }) {
    if (feedState.isInitialLoading && posts.isEmpty) {
      return const AppLoading();
    }

    if (posts.isEmpty) {
      return AppEmpty(
        title: context.l10n.noPostsYet,
        message: context.l10n.createFirstPost,
        icon: Icons.post_add_rounded,
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return ref.read(feedNotifierProvider.notifier).refreshPosts();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.xl,
        ),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return _MyPostItem(
            post: post,
            isUpdating: feedState.isUpdating,
            isOffline: feedState.isOffline,
            onEdit: () {
              context.push('/edit-post', extra: post);
            },
            onClose: () {
              _closePost(context, ref, post);
            },
            onDelete: () {
              _confirmDelete(context, ref, post);
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

    if (!context.mounted) {
      return;
    }

    final error = ref.read(feedNotifierProvider).error;

    final message = success
        ? context.l10n.postClosed
        : error == 'offline_write_unavailable'
        ? context.l10n.offlineChangesUnavailable
        : context.l10n.actionFailed;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
          icon: Icon(
            Icons.delete_outline_rounded,
            color: Theme.of(dialogContext).colorScheme.error,
          ),
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
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
                foregroundColor: Theme.of(dialogContext).colorScheme.onError,
              ),
              child: Text(context.l10n.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final success = await ref
        .read(feedNotifierProvider.notifier)
        .deletePost(post.id);

    if (!context.mounted) {
      return;
    }

    final error = ref.read(feedNotifierProvider).error;

    final message = success
        ? context.l10n.postDeleted
        : error == 'offline_write_unavailable'
        ? context.l10n.offlineChangesUnavailable
        : context.l10n.actionFailed;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _MyPostItem extends StatelessWidget {
  const _MyPostItem({
    required this.post,
    required this.isUpdating,
    required this.isOffline,
    required this.onEdit,
    required this.onClose,
    required this.onDelete,
  });

  final AgriculturePost post;
  final bool isUpdating;
  final bool isOffline;
  final VoidCallback onEdit;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isClosed = post.status == PostStatus.closed;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        children: [
          AgriculturePostCard(post: post, onCall: null),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: AppCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _StatusBadge(isClosed: isClosed),
                      const Spacer(),
                      Text(
                        isClosed ? context.l10n.closed : context.l10n.active,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.edit_outlined,
                          label: context.l10n.editPost,
                          onPressed: isUpdating
                              ? null
                              : () {
                                  if (isOffline) {
                                    _showOfflineMessage(context);
                                    return;
                                  }

                                  onEdit();
                                },
                        ),
                      ),

                      const SizedBox(width: AppSpacing.sm),

                      if (!isClosed) ...[
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.check_circle_outline_rounded,
                            label: context.l10n.closePost,
                            onPressed: isUpdating
                                ? null
                                : () {
                                    if (isOffline) {
                                      _showOfflineMessage(context);
                                      return;
                                    }

                                    onClose();
                                  },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],

                      Expanded(
                        child: _ActionButton(
                          icon: Icons.delete_outline_rounded,
                          label: context.l10n.delete,
                          isDestructive: true,
                          onPressed: isUpdating
                              ? null
                              : () {
                                  if (isOffline) {
                                    _showOfflineMessage(context);
                                    return;
                                  }

                                  onDelete();
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOfflineMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.offlineChangesUnavailable)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isClosed});

  final bool isClosed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = isClosed
        ? colorScheme.surfaceContainerHighest
        : colorScheme.primaryContainer;

    final foregroundColor = isClosed
        ? colorScheme.onSurfaceVariant
        : colorScheme.onPrimaryContainer;

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(
        isClosed
            ? Icons.lock_outline_rounded
            : Icons.check_circle_outline_rounded,
        size: 20,
        color: foregroundColor,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final foregroundColor = isDestructive
        ? colorScheme.error
        : colorScheme.onSurface;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        foregroundColor: foregroundColor,
        side: BorderSide(
          color: isDestructive
              ? colorScheme.error.withValues(alpha: 0.35)
              : colorScheme.outline,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 16,
            color: colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onErrorContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
