import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';
import 'package:krishi_social/shared/theme/app_colors.dart';
import 'package:krishi_social/shared/theme/app_radius.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_card.dart';

class AgriculturePostCard extends StatelessWidget {
  const AgriculturePostCard({
    super.key,
    required this.post,
    this.onCall,
    this.onTap,
  });

  final AgriculturePost post;
  final VoidCallback? onCall;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBuyPost = post.type == PostType.buy;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _PostTypeBadge(
                  isBuyPost: isBuyPost,
                  label: post.type.displayName,
                ),
                const Spacer(),
                Text(
                  _formatCreatedAt(post.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Text(
              post.productName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _InformationPill(
                  icon: Icons.scale_outlined,
                  text:
                      '${_formatNumber(post.quantity)} '
                      '${post.unit.displayName}',
                ),
                _InformationPill(
                  icon: Icons.location_on_outlined,
                  text: post.district,
                ),
                _InformationPill(
                  icon: Icons.calendar_today_outlined,
                  text: _formatDateRange(post),
                ),
              ],
            ),

            if (post.pricePerUnit != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                '৳${_formatNumber(post.pricePerUnit!)}'
                ' / ${post.unit.displayName}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    _initial(post.userName),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              post.userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (post.isUserReviewed) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified_rounded,
                              size: 17,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        post.district,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                FilledButton.tonalIcon(
                  onPressed: onCall,
                  icon: const Icon(Icons.call_outlined, size: 19),
                  label: Text(context.l10n.contact),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateRange(AgriculturePost post) {
    final formatter = DateFormat('d MMM');

    return '${formatter.format(post.availableFrom)}'
        ' – ${formatter.format(post.availableTo)}';
  }

  String _formatCreatedAt(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Now';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours}h';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}d';
    }

    return DateFormat('d MMM').format(date);
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  String _initial(String name) {
    final value = name.trim();

    if (value.isEmpty) {
      return '?';
    }

    return value.characters.first.toUpperCase();
  }
}

class _PostTypeBadge extends StatelessWidget {
  const _PostTypeBadge({required this.isBuyPost, required this.label});

  final bool isBuyPost;
  final String label;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isBuyPost
        ? Theme.of(context).colorScheme.primaryContainer
        : const Color(0xFFFFEBC5);

    final foregroundColor = isBuyPost
        ? Theme.of(context).colorScheme.onPrimaryContainer
        : const Color(0xFF795100);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InformationPill extends StatelessWidget {
  const _InformationPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
