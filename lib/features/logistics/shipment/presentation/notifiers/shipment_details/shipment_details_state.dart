import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment_details.dart';

class ShipmentDetailsState {
  final bool isLoading;
  final ShipmentDetails? details;
  final String? error;

  const ShipmentDetailsState({
    this.isLoading = false,
    this.details,
    this.error,
  });

  ShipmentDetailsState copyWith({
    bool? isLoading,
    ShipmentDetails? details,
    String? error,
  }) {
    return ShipmentDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      error: error,
    );
  }
}
