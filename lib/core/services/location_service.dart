import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AppLocation {
  final String address;
  final String district;
  final double latitude;
  final double longitude;

  const AppLocation({
    required this.address,
    required this.district,
    required this.latitude,
    required this.longitude,
  });
}

class LocationService {
  const LocationService();

  Future<AppLocation> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw const LocationException('Location service is turned off.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationException('Location permission was not granted.');
    }

    final position = await Geolocator.getCurrentPosition();

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final placemark = placemarks.isNotEmpty ? placemarks.first : null;

    final addressParts = [
      placemark?.street,
      placemark?.subLocality,
      placemark?.locality,
    ].whereType<String>().where((value) => value.trim().isNotEmpty);

    return AppLocation(
      address: addressParts.join(', '),
      district: placemark?.administrativeArea ?? '',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}

class LocationException implements Exception {
  final String message;

  const LocationException(this.message);

  @override
  String toString() => message;
}
