import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment_status.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/params/create_shipment.dart';

import 'shipment_provider.dart';
import 'shipment_state.dart';

final shipmentNotifierProvider =
    StateNotifierProvider<ShipmentNotifier, ShipmentState>(
      (ref) => ShipmentNotifier(ref),
    );

class ShipmentNotifier extends StateNotifier<ShipmentState> {
  ShipmentNotifier(this.ref) : super(const ShipmentState());

  final Ref ref;
  List<Shipment> _allShipments = [];
  Future<void> loadShipments() async {
    state = state.copyWith(isLoading: true);

    try {
      final shipments = await ref.read(getRecentShipmentsUseCaseProvider)();
      _allShipments = shipments.data;

      state = state.copyWith(shipments: shipments.data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> createShipment(CreateShipmentRequest request) async {
    state = state.copyWith(isSubmitting: true);

    try {
      await ref.read(createShipmentUseCaseProvider)(request);
      await loadShipments();
      state = state.copyWith(isSubmitting: false);

      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());

      return false;
    }
  }

  Future<bool> updateShipment(Shipment shipment) async {
    state = state.copyWith(isSubmitting: true);

    try {
      await ref.read(updateShipmentUseCaseProvider)(shipment);
      await loadShipments();
      state = state.copyWith(isSubmitting: false);

      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());

      return false;
    }
  }

  Future<bool> deleteShipment(String trackingId) async {
    state = state.copyWith(isSubmitting: true);

    try {
      await ref.read(deleteShipmentUseCaseProvider)(trackingId);
      await loadShipments();
      state = state.copyWith(isSubmitting: false);

      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());

      return false;
    }
  }

  void filterShipments({String? searchQuery, ShipmentStatusFilter? status}) {
    final query = searchQuery ?? state.searchQuery;
    final filter = status ?? state.statusFilter;

    var filtered = _allShipments;

    // Search
    if (query.trim().isNotEmpty) {
      filtered = filtered.where((shipment) {
        final q = query.toLowerCase();

        return shipment.customer.toLowerCase().contains(q) ||
            shipment.trackingId.toLowerCase().contains(q);
      }).toList();
    }

    // Status
    if (filter != ShipmentStatusFilter.all) {
      filtered = filtered.where((shipment) {
        return shipment.status.toLowerCase() == filter.name.toLowerCase();
      }).toList();
    }

    state = state.copyWith(
      shipments: filtered,
      searchQuery: query,
      statusFilter: filter,
    );
  }
}
