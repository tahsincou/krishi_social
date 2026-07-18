import 'package:flutter_mvp_starter/core/common/repository_result.dart';
import 'package:flutter_mvp_starter/core/network/network_exception.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/data/datasources/shipment_local_data_source.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/data/datasources/shipment_remote_datasource.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment_details.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/entities/shipment_timeline.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/params/create_shipment.dart';

import '../../domain/entities/shipment.dart';
import '../../domain/repository/shipment_repository.dart';

class ShipmentRepositoryImpl implements ShipmentRepository {
  ShipmentRepositoryImpl({required this.remote, required this.local});

  final ShipmentRemoteDataSource remote;
  final ShipmentLocalDataSource local;

  @override
  Future<RepositoryResult<List<Shipment>>> getRecentShipments() async {
    try {
      final shipments = await remote.getShipments();

      await local.replaceShipments(shipments);

      return RepositoryResult(data: shipments, isFromCache: false);
    } on NetworkException {
      return RepositoryResult(
        data: await local.getShipments(),
        isFromCache: true,
      );
    }
  }

  @override
  Future<void> createShipment(CreateShipmentRequest request) {
    return remote.createShipment(request);
  }

  @override
  Future<void> updateShipment(Shipment shipment) {
    return remote.updateShipment(shipment);
  }

  @override
  Future<void> deleteShipment(String trackingId) {
    return remote.deleteShipment(trackingId);
  }

  @override
  Future<ShipmentDetails> getShipmentDetails(String trackingId) async {
    final shipments = await remote.getShipments();

    final shipment = shipments.firstWhere((e) => e.trackingId == trackingId);

    return ShipmentDetails(
      shipment: shipment,
      timeline: [
        ShipmentTimeline(
          title: 'Created',
          completed: true,
          time: DateTime(2026, 7, 4, 9, 0),
        ),
        ShipmentTimeline(
          title: 'Picked Up',
          completed: true,
          time: DateTime(2026, 7, 4, 10, 30),
        ),
        ShipmentTimeline(
          title: 'Arrived at Hub',
          completed: true,
          time: DateTime(2026, 7, 4, 13, 20),
        ),
        ShipmentTimeline(
          title: 'Out for Delivery',
          completed: false,
          time: null,
        ),
        ShipmentTimeline(title: 'Delivered', completed: false, time: null),
      ],
    );
  }
}
