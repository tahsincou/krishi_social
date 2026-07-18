enum ShipmentStatusFilter {
  all,
  pending,
  delivered,
  failed;

  String get label {
    switch (this) {
      case ShipmentStatusFilter.all:
        return 'All';
      case ShipmentStatusFilter.pending:
        return 'Pending';
      case ShipmentStatusFilter.delivered:
        return 'Delivered';
      case ShipmentStatusFilter.failed:
        return 'Failed';
    }
  }
}
