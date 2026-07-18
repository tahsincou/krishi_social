import 'package:flutter_mvp_starter/core/network/api_client.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/data/models/shipement_model.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/data/models/shipment_details_model.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/params/create_shipment.dart';
import '../../domain/entities/shipment.dart';

class ShipmentRemoteDataSource {
  final ApiClient apiClient;

  ShipmentRemoteDataSource(this.apiClient);

  Future<List<ShipmentModel>> getShipments() async {
    final response = await apiClient.get<List>('/shipments');

    return (response.data as List)
        .map((e) => ShipmentModel.fromJson(e))
        .toList();
  }

  Future<void> createShipment(CreateShipmentRequest request) async {
    await apiClient.post(
      '/shipments',
      data: {
        'customer': request.customer,
        'phone': request.phone,
        'address': request.address,
      },
    );
  }

  Future<void> updateShipment(Shipment shipment) async {
    final model = ShipmentModel(
      trackingId: shipment.trackingId,
      customer: shipment.customer,
      phone: shipment.phone,
      address: shipment.address,
      status: shipment.status,
    );

    await apiClient.put(
      '/shipments/${shipment.trackingId}',
      data: model.toJson(),
    );
  }

  Future<void> deleteShipment(String trackingId) async {
    await apiClient.delete('/shipments/$trackingId');
  }

  Future<ShipmentDetailsModel> getShipmentDetails(String trackingId) async {
    final response = await apiClient.get<Map<String, dynamic>>(
      '/shipments/$trackingId',
    );

    return ShipmentDetailsModel.fromJson(response.data!);
  }
}
