import 'package:flutter_mvp_starter/features/logistics/shipment/domain/params/create_shipment.dart';

import '../repository/shipment_repository.dart';

class CreateShipmentUseCase {
  final ShipmentRepository repository;

  const CreateShipmentUseCase(this.repository);

  Future<void> call(CreateShipmentRequest request) {
    return repository.createShipment(request);
  }
}
