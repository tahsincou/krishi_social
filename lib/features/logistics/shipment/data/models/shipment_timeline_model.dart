import '../../domain/entities/shipment_timeline.dart';

class ShipmentTimelineModel extends ShipmentTimeline {
  const ShipmentTimelineModel({
    required super.title,
    required super.time,
    required super.completed,
  });

  factory ShipmentTimelineModel.fromJson(Map<String, dynamic> json) {
    return ShipmentTimelineModel(
      title: json['title'] as String,
      time: json['time'] == null
          ? null
          : DateTime.parse(json['time'] as String),
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time?.toIso8601String(),
      'completed': completed,
    };
  }
}
