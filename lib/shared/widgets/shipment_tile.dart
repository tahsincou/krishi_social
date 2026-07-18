import 'package:flutter/material.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment.dart';
import 'package:flutter_mvp_starter/shared/theme/app_text_styles.dart';

class ShipmentTile extends StatelessWidget {
  final Shipment shipment;
  final VoidCallback? onTap;

  const ShipmentTile({super.key, required this.shipment, this.onTap});

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'failed':
        return Icons.cancel;
      case 'in transit':
        return Icons.local_shipping;
      case 'cancelled':
        return Icons.block;
      default:
        return Icons.info;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'in transit':
        return Colors.blue;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.black54;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(shipment.status);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.local_shipping),
        title: Text(shipment.trackingId),
        subtitle: Text(shipment.customer),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getStatusIcon(shipment.status), color: color, size: 20),
            const SizedBox(width: 6),
            Text(shipment.status, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
