import '../models/shipement_model.dart';
import 'shipment_local_data_source.dart';

class ShipmentInMemoryDataSource implements ShipmentLocalDataSource {
  final List<ShipmentModel> _cache = [];

  @override
  Future<List<ShipmentModel>> getShipments() async {
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> replaceShipments(List<ShipmentModel> shipments) async {
    _cache
      ..clear()
      ..addAll(shipments);
  }
}
