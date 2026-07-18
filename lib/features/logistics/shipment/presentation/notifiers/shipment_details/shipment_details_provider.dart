import 'package:flutter_riverpod/legacy.dart';
import 'package:krishi_social/core/providers/repository_providers.dart';
import 'package:krishi_social/features/logistics/shipment/presentation/notifiers/shipment_details/shipment_details_notifier.dart';
import 'package:krishi_social/features/logistics/shipment/presentation/notifiers/shipment_details/shipment_details_state.dart';

final shipmentDetailsNotifierProvider =
    StateNotifierProvider<ShipmentDetailsNotifier, ShipmentDetailsState>((ref) {
      return ShipmentDetailsNotifier(ref.read(shipmentRepositoryProvider));
    });
