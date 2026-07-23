import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:krishi_social/core/locale/locale_extension.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/entities/post_status.dart';
import 'package:krishi_social/features/feed/domain/entities/post_type.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';
import 'package:krishi_social/shared/theme/app_radius.dart';
import 'package:krishi_social/shared/theme/app_spacing.dart';
import 'package:krishi_social/shared/widgets/app_card.dart';

class MyPostManagementCard extends StatelessWidget {
  const MyPostManagementCard({
    super.key,
    required this.post,
    required this.isUpdating,
    required this.isOffline,

    required this.onClose,
    required this.onDelete,
  });

  final AgriculturePost post;
  final bool isUpdating;
  final bool isOffline;
  final VoidCallback onClose;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isClosed = post.status == PostStatus.closed;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: AppCard(
        onTap: () {
          _runOnlineAction(context, () {
            context.push('/edit-post', extra: post);
          });
        },
        backgroundColor: isClosed
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primaryContainer.withValues(alpha: 0.38),
        padding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border(
              left: BorderSide(
                color: isClosed ? colorScheme.outline : colorScheme.primary,
                width: 5,
              ),
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isClosed),
              const SizedBox(height: AppSpacing.md),

              Text(
                post.productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.sm),

              Text(
                '${_formatNumber(post.quantity)} '
                '${post.unit.displayName} • ${post.district}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xs),

              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 17,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      isClosed
                          ? context.l10n.postIsClosed
                          : _availabilityText(context),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),

              if (isClosed)
                _buildClosedActions(context)
              else
                _buildActiveActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isClosed) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isClosed ? colorScheme.surface : colorScheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isClosed ? Icons.lock_outline_rounded : Icons.circle,
                size: isClosed ? 15 : 9,
                color: isClosed
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                isClosed ? context.l10n.closed : context.l10n.active,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isClosed
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          post.type == PostType.buy ? context.l10n.buy : context.l10n.sell,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        PopupMenuButton<_PostAction>(
          enabled: !isUpdating,
          onSelected: (action) {
            if (action == _PostAction.delete) {
              _runOnlineAction(context, onDelete);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _PostAction.delete,
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: colorScheme.error),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    context.l10n.delete,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: isUpdating
                ? null
                : () => _runOnlineAction(context, onClose),
            icon: const Icon(Icons.check_circle_outline),
            label: Text(context.l10n.closePost),
          ),
        ),
      ],
    );
  }

  Widget _buildClosedActions(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: null,
        icon: const Icon(Icons.restart_alt_rounded),
        label: Text(context.l10n.postAgain),
      ),
    );
  }

  void _runOnlineAction(BuildContext context, VoidCallback action) {
    if (isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.offlineChangesUnavailable)),
      );
      return;
    }

    action();
  }

  String _availabilityText(BuildContext context) {
    final formatter = DateFormat('d MMM');

    final range =
        '${formatter.format(post.availableFrom)}'
        ' – ${formatter.format(post.availableTo)}';

    return post.type == PostType.buy
        ? context.l10n.neededDuring(range)
        : context.l10n.availableDuring(range);
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }
}

enum _PostAction { delete }
