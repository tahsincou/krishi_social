import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/repository/shipment_repository.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/presentation/notifiers/shipment_details/shipment_details_state.dart';

class ShipmentDetailsNotifier extends StateNotifier<ShipmentDetailsState> {
  ShipmentDetailsNotifier(this.repository)
    : super(const ShipmentDetailsState());

  final ShipmentRepository repository;

  Future<void> load(String trackingId) async {
    state = state.copyWith(isLoading: true);

    final details = await repository.getShipmentDetails(trackingId);

    state = state.copyWith(details: details, isLoading: false);
  }
}
