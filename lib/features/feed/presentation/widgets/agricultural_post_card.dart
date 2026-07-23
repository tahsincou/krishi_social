import 'package:flutter/material.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/entities/product_category.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';
import 'package:krishi_social/shared/theme/app_colors.dart';
import 'package:krishi_social/shared/theme/app_radius.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_card.dart';

class AgriculturePostCard extends StatelessWidget {
  const AgriculturePostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onCall,
  });

  final AgriculturePost post;
  final VoidCallback? onTap;
  final VoidCallback? onCall;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBuyPost = post.type == PostType.buy;

    IconData _categoryIcon(ProductCategory category) {
      switch (category) {
        case ProductCategory.vegetables:
          return Icons.eco_outlined;
        case ProductCategory.fruits:
          return Icons.apple_outlined;
        case ProductCategory.nursery:
          return Icons.grass_outlined;
        case ProductCategory.fish:
          return Icons.set_meal_outlined;
        case ProductCategory.livestock:
          return Icons.pets_outlined;
        default:
          return Icons.agriculture_outlined;
      }
    }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: post.type == PostType.buy
                        ? AppColors.accentSoft
                        : Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    _categoryIcon(post.category),
                    color: post.type == PostType.buy
                        ? AppColors.accentDark
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatNumber(post.quantity)} '
                        '${post.unit.displayName} • ${post.district}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _PostTypeBadge(
                  label: post.type.displayName,
                  isBuyPost: post.type == PostType.buy,
                ),
              ],
            ),

            if (post.pricePerUnit != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                '৳${_formatNumber(post.pricePerUnit!)}'
                ' / ${post.unit.displayName}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.accentDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          post.userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
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
                ),
                IntrinsicWidth(
                  child: FilledButton.tonalIcon(
                    onPressed: onCall,
                    icon: const Icon(Icons.call_outlined, size: 18),
                    label: Text(
                      post.type == PostType.sell
                          ? context.l10n.callSeller
                          : context.l10n.callBuyer,
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

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }
}

class _PostTypeBadge extends StatelessWidget {
  const _PostTypeBadge({required this.label, required this.isBuyPost});

  final String label;
  final bool isBuyPost;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = isBuyPost
        ? AppColors.accentSoft
        : colorScheme.primaryContainer;

    final foregroundColor = isBuyPost
        ? AppColors.accentDark
        : colorScheme.onPrimaryContainer;

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
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
