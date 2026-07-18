import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_mvp_starter/core/providers/providers.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/usecases/create_shipment_usecase.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/usecases/delete_shipment_usecase.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/usecases/get_recent_shipment_usecase.dart';
import 'package:flutter_mvp_starter/features/logistics/shipment/domain/usecases/update_shipment_usecase.dart';

final getRecentShipmentsUseCaseProvider = Provider<GetRecentShipmentsUseCase>((
  ref,
) {
  return GetRecentShipmentsUseCase(ref.read(shipmentRepositoryProvider));
});

final createShipmentUseCaseProvider = Provider<CreateShipmentUseCase>((ref) {
  return CreateShipmentUseCase(ref.read(shipmentRepositoryProvider));
});

final updateShipmentUseCaseProvider = Provider<UpdateShipmentUseCase>((ref) {
  return UpdateShipmentUseCase(ref.read(shipmentRepositoryProvider));
});

final deleteShipmentUseCaseProvider = Provider<DeleteShipmentUseCase>((ref) {
  return DeleteShipmentUseCase(ref.read(shipmentRepositoryProvider));
});
