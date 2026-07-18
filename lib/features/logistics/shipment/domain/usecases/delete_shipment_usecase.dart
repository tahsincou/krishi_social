import '../repository/shipment_repository.dart';

class DeleteShipmentUseCase {
  final ShipmentRepository repository;

  const DeleteShipmentUseCase(this.repository);

  Future<void> call(String trackingId) {
    return repository.deleteShipment(trackingId);
  }
}
