import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi_social/features/feed/domain/entities/agricultural_post.dart';
import 'package:krishi_social/features/feed/domain/extensions/feed_extension.dart';

class AgriculturePostCard extends StatelessWidget {
  final AgriculturePost post;
  final VoidCallback? onCall;

  const AgriculturePostCard({super.key, required this.post, this.onCall});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeader(post: post),
            const SizedBox(height: 16),
            Text(
              post.product,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _PostInformation(post: post),
            if (post.description?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(post.description!),
            ],
            const SizedBox(height: 12),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onCall,
                      icon: const Icon(Icons.call_outlined),
                      label: const Text('Contact'),
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
}

class _PostHeader extends StatelessWidget {
  final AgriculturePost post;

  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: post.userImageUrl != null
              ? NetworkImage(post.userImageUrl!)
              : null,
          child: post.userImageUrl == null
              ? Text(
                  post.userName.isNotEmpty
                      ? post.userName.characters.first.toUpperCase()
                      : '?',
                )
              : null,
        ),
        const SizedBox(width: 12),
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
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (post.isUserReviewed) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 18),
                  ],
                ],
              ),
              Text(
                '${post.upazila}, ${post.district}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Chip(
          label: Text(post.type.displayName),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _PostInformation extends StatelessWidget {
  final AgriculturePost post;

  const _PostInformation({required this.post});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM');

    return Column(
      children: [
        _InformationRow(
          icon: Icons.scale_outlined,
          label: 'Quantity',
          value: '${_formatQuantity(post.quantity)} ${post.unit.displayName}',
        ),
        _InformationRow(
          icon: Icons.date_range_outlined,
          label: post.type.displayName == 'Buy' ? 'Required' : 'Available',
          value:
              '${dateFormat.format(post.availableFrom)} - ${dateFormat.format(post.availableTo)}',
        ),
        if (post.pricePerUnit != null)
          _InformationRow(
            icon: Icons.payments_outlined,
            label: 'Price',
            value:
                '৳${_formatQuantity(post.pricePerUnit!)} / ${post.unit.displayName}',
          ),
        if (post.qualityRequirement?.isNotEmpty == true)
          _InformationRow(
            icon: Icons.fact_check_outlined,
            label: 'Quality',
            value: post.qualityRequirement!,
          ),
      ],
    );
  }

  String _formatQuantity(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }
}

class _InformationRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 72,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
