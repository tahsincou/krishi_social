import 'shipment.dart';
import 'shipment_timeline.dart';

class ShipmentDetails {
  final Shipment shipment;
  final List<ShipmentTimeline> timeline;

  const ShipmentDetails({required this.shipment, required this.timeline});
}
