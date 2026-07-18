import '../../domain/entities/shipment_details.dart';
import 'shipement_model.dart';
import 'shipment_timeline_model.dart';

class ShipmentDetailsModel extends ShipmentDetails {
  ShipmentDetailsModel({required super.shipment, required super.timeline});

  factory ShipmentDetailsModel.fromJson(Map<String, dynamic> json) {
    return ShipmentDetailsModel(
      shipment: ShipmentModel.fromJson(json),
      timeline: (json['timeline'] as List? ?? [])
          .map((e) => ShipmentTimelineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
