import 'package:flutter_mvp_starter/features/logistics/shipment/data/models/shipement_model.dart';

abstract class ShipmentLocalDataSource {
  Future<List<ShipmentModel>> getShipments();

  Future<void> replaceShipments(List<ShipmentModel> shipments);
}
