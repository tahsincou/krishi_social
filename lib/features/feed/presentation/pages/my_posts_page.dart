import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/auth/domain/entities/account_activity.dart';
import 'package:krishi_social/features/auth/presentaion/providers/auth_notifier.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_status.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/presentation/providers/feed_notifier.dart';
import 'package:krishi_social/features/feed/presentation/widgets/my_post_management_card.dart';
import 'package:krishi_social/shared/theme/app_radius.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_empty.dart';
import 'package:krishi_social/shared/widgets/app_loading.dart';

class MyPostsPage extends ConsumerStatefulWidget {
  const MyPostsPage({super.key});

  @override
  ConsumerState<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends ConsumerState<MyPostsPage> {
  PostStatus _selectedStatus = PostStatus.active;
  PostType _selectedPostType = PostType.buy;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final feedState = ref.watch(feedNotifierProvider);

    final user = authState.user;

    if (user == null) {
      return const Scaffold(body: AppLoading());
    }

    final activity = user.activity;
    final canShowBothPostTypes = activity == AccountActivity.both;

    final allUserPosts = feedState.postsByUser(user.id);

    final allPosts = canShowBothPostTypes
        ? allUserPosts.where((post) => post.type == _selectedPostType).toList()
        : allUserPosts;

    final activePosts = allPosts
        .where((post) => post.status == PostStatus.active)
        .toList();

    final closedPosts = allPosts
        .where((post) => post.status == PostStatus.closed)
        .toList();

    final visiblePosts = _selectedStatus == PostStatus.active
        ? activePosts
        : closedPosts;

    String pageTitle(AccountActivity activity) {
      switch (activity) {
        case AccountActivity.buy:
          return context.l10n.myBuyRequests;

        case AccountActivity.sell:
          return context.l10n.mySellOffers;

        case AccountActivity.both:
          return context.l10n.myPosts;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle(activity)),
        actions: [
          if (feedState.isOffline)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Center(
                child: Icon(
                  Icons.cloud_off_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (canShowBothPostTypes) ...[
            _buildPostTypeSelector(),
            const SizedBox(height: AppSpacing.xs),
          ],
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: _buildContent(
              posts: visiblePosts,
              isLoading: feedState.isInitialLoading,
              isUpdating: feedState.isUpdating,
              isOffline: feedState.isOffline,
              activity: activity,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostTypeSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        0,
      ),
      child: SegmentedButton<PostType>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: PostType.buy,
            icon: const Icon(Icons.shopping_cart_outlined),
            label: Text(context.l10n.buyRequests),
          ),
          ButtonSegment(
            value: PostType.sell,
            icon: const Icon(Icons.agriculture_outlined),
            label: Text(context.l10n.sellOffers),
          ),
        ],
        selected: {_selectedPostType},
        onSelectionChanged: (values) {
          setState(() {
            _selectedPostType = values.first;
            _selectedStatus = PostStatus.active;
          });
        },
      ),
    );
  }

  Widget _buildContent({
    required List<AgriculturePost> posts,
    required bool isLoading,
    required bool isUpdating,
    required bool isOffline,
    required AccountActivity activity,
  }) {
    if (isLoading && posts.isEmpty) {
      return const AppLoading();
    }

    if (posts.isEmpty) {
      final showingActive = _selectedStatus == PostStatus.active;

      return AppEmpty(
        title: showingActive
            ? context.l10n.noActivePosts
            : context.l10n.noClosedPosts,
        message: showingActive
            ? _activeEmptyMessage(activity)
            : context.l10n.closedPostsWillAppearHere,
        icon: showingActive
            ? Icons.post_add_rounded
            : Icons.inventory_2_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return ref.read(feedNotifierProvider.notifier).refreshPosts();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return MyPostManagementCard(
            post: post,
            isUpdating: isUpdating,
            isOffline: isOffline,
            onEdit: () {
              context.push('/edit-post', extra: post);
            },
            onClose: () {
              _closePost(post);
            },
            onDelete: () {
              _confirmDelete(post);
            },
          );
        },
      ),
    );
  }

  String _activeEmptyMessage(AccountActivity activity) {
    if (activity == AccountActivity.buy) {
      return context.l10n.createFirstBuyRequest;
    }

    if (activity == AccountActivity.sell) {
      return context.l10n.createFirstSellOffer;
    }

    return _selectedPostType == PostType.buy
        ? context.l10n.createFirstBuyRequest
        : context.l10n.createFirstSellOffer;
  }

  Future<void> _closePost(AgriculturePost post) async {
    final success = await ref
        .read(feedNotifierProvider.notifier)
        .closePost(post);

    if (!mounted) return;

    final error = ref.read(feedNotifierProvider).error;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? context.l10n.postClosed
              : error == 'offline_write_unavailable'
              ? context.l10n.offlineChangesUnavailable
              : context.l10n.actionFailed,
        ),
      ),
    );
  }

  Future<void> _confirmDelete(AgriculturePost post) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.delete_outline,
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
              ),
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

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? context.l10n.postDeleted : context.l10n.actionFailed,
        ),
      ),
    );
  }
}

class _StatusTab extends StatelessWidget {
  const _StatusTab({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? colorScheme.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                constraints: const BoxConstraints(minWidth: 24),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.onPrimary.withValues(alpha: 0.22)
                      : colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
