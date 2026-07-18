import '../../domain/entities/shipment.dart';

class ShipmentModel extends Shipment {
  const ShipmentModel({
    required super.trackingId,
    required super.customer,
    required super.phone,
    required super.address,
    required super.status,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      trackingId: json['trackingId'] as String,
      customer: json['customer'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trackingId': trackingId,
      'customer': customer,
      'phone': phone,
      'address': address,
      'status': status,
    };
  }
}
