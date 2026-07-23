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
                  label: post.type.displayName,
                  isBuyPost: isBuyPost,
                ),
                const Spacer(),
                Text(
                  _formatCreatedAt(context, post.createdAt),
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
                  icon: Icons.calendar_month_outlined,
                  text: _formatAvailability(post),
                  backgroundColor: AppColors.accentSoft,
                  foregroundColor: AppColors.accentDark,
                ),
              ],
            ),

            if (post.pricePerUnit != null) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 19,
                    color: AppColors.accentDark,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '৳${_formatNumber(post.pricePerUnit!)}'
                    ' / ${post.unit.displayName}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.accentDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppSpacing.md),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    _firstCharacter(post.userName),
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
                      const SizedBox(height: 2),
                      Text(
                        post.category.displayName(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                if (onCall != null)
                  FilledButton.tonalIcon(
                    onPressed: onCall,
                    icon: const Icon(Icons.call_outlined, size: 18),
                    label: Text(context.l10n.contact),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 42),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
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

  String _formatAvailability(AgriculturePost post) {
    final formatter = DateFormat('d MMM');

    return '${formatter.format(post.availableFrom)}'
        ' – ${formatter.format(post.availableTo)}';
  }

  String _formatCreatedAt(BuildContext context, DateTime createdAt) {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) {
      return context.l10n.justNow;
    }

    if (difference.inHours < 1) {
      return context.l10n.minutesAgo(difference.inMinutes);
    }

    if (difference.inDays < 1) {
      return context.l10n.hoursAgo(difference.inHours);
    }

    if (difference.inDays < 7) {
      return context.l10n.daysAgo(difference.inDays);
    }

    return DateFormat('d MMM').format(createdAt);
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  String _firstCharacter(String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      return '?';
    }

    return trimmedValue.characters.first.toUpperCase();
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

class _InformationPill extends StatelessWidget {
  const _InformationPill({
    required this.icon,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final resolvedForegroundColor =
        foregroundColor ?? colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: resolvedForegroundColor),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: resolvedForegroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
