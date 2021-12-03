import 'package:latlong2/latlong.dart';

class RoutePoint {
  RoutePoint(this.latlng, this.altitude) {
    time = DateTime.now();
  }

  LatLng latlng;
  double altitude;
  late DateTime time;

  @override
  String toString() {
    return "Coodinates: ${latlng.latitude.toStringAsFixed(4)}, ${latlng.longitude.toStringAsFixed(4)} \tAltitude: ${altitude.toString()} \tTime: ${time.toIso8601String()}";
  }
}
