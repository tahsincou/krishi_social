class DashboardSummary {
  final int deliveries;
  final int pending;
  final int completed;
  final int failed;

  const DashboardSummary({
    required this.deliveries,
    required this.pending,
    required this.completed,
    required this.failed,
  });
}
