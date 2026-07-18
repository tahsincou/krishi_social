import 'package:flutter_mvp_starter/core/common/repository_result.dart';

import '../entities/shipment.dart';
import '../repository/shipment_repository.dart';

class GetRecentShipmentsUseCase {
  final ShipmentRepository repository;

  const GetRecentShipmentsUseCase(this.repository);

  Future<RepositoryResult<List<Shipment>>> call() {
    return repository.getRecentShipments();
  }
}
