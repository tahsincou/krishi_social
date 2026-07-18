import 'package:flutter/material.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment_status.dart';

class StatusFilterChips extends StatelessWidget {
  final ShipmentStatusFilter selected;
  final ValueChanged<ShipmentStatusFilter> onSelected;

  const StatusFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: ShipmentStatusFilter.values.map((status) {
        return ChoiceChip(
          label: Text(status.label),
          selected: selected == status,
          onSelected: (_) => onSelected(status),
        );
      }).toList(),
    );
  }
}
