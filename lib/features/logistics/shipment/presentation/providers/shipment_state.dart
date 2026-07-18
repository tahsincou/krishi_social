import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment_status.dart';

class ShipmentState {
  final bool isLoading;
  final bool isSubmitting;
  final List<Shipment> shipments;
  final String? error;
  final String searchQuery;
  final ShipmentStatusFilter statusFilter;
  final bool isFromCache;

  const ShipmentState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.shipments = const [],
    this.isFromCache = false,
    this.error,
    this.searchQuery = '',
    this.statusFilter = ShipmentStatusFilter.all,
  });

  ShipmentState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<Shipment>? shipments,
    String? error,
    String? searchQuery,
    ShipmentStatusFilter? statusFilter,
  }) {
    return ShipmentState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      shipments: shipments ?? this.shipments,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      isFromCache: isFromCache,
    );
  }
}
