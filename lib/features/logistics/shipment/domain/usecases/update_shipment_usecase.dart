import 'package:krishi_social/features/logistics/shipment/domain/entities/shipment.dart';
import 'package:krishi_social/features/logistics/shipment/domain/repository/shipment_repository.dart';

class UpdateShipmentUseCase {
  final ShipmentRepository repository;

  const UpdateShipmentUseCase(this.repository);

  Future<void> call(Shipment shipment) {
    return repository.updateShipment(shipment);
  }
}
