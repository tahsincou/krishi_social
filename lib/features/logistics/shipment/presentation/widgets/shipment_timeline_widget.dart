import 'package:flutter/material.dart';
import '../../domain/entities/shipment_timeline.dart';

class ShipmentTimelineWidget extends StatelessWidget {
  const ShipmentTimelineWidget({super.key, required this.timeline});

  final List<ShipmentTimeline> timeline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        timeline.length,
        (index) => _TimelineItem(
          item: timeline[index],
          isLast: index == timeline.length - 1,
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.item, required this.isLast});

  final ShipmentTimeline item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = item.completed ? Colors.green : Colors.grey;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                item.completed
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: color,
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade300),
                ),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.time == null ? 'Pending' : _format(item.time!),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _format(DateTime date) {
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
