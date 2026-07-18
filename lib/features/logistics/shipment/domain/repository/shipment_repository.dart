import 'package:flutter_mvp_starter/core/common/repository_result.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment_details.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/params/create_shipment.dart';

import '../entities/shipment.dart';

abstract interface class ShipmentRepository {
  Future<RepositoryResult<List<Shipment>>> getRecentShipments();

  Future<void> createShipment(CreateShipmentRequest request);

  Future<void> updateShipment(Shipment shipment);

  Future<void> deleteShipment(String trackingId);

  Future<ShipmentDetails> getShipmentDetails(String trackingId);
}
