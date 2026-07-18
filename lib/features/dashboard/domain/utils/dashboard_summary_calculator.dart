import '../../../logistics/shipment/domain/entities/shipment.dart';
import '../entities/dashboard_summary.dart';

class DashboardSummaryCalculator {
  static DashboardSummary calculate(List<Shipment> shipments) {
    final deliveries = shipments.length;

    final pending = shipments
        .where((e) => e.status.toLowerCase() == 'pending')
        .length;

    final completed = shipments
        .where((e) => e.status.toLowerCase() == 'delivered')
        .length;

    final failed = shipments
        .where((e) => e.status.toLowerCase() == 'failed')
        .length;

    return DashboardSummary(
      deliveries: deliveries,
      pending: pending,
      completed: completed,
      failed: failed,
    );
  }
}
