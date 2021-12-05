import 'package:latlong2/latlong.dart';

class RoutePoint {
  RoutePoint(this.latlng, this.altitude) {
    time = DateTime.now();
  }
  RoutePoint.withTime(this.latlng, this.altitude, this.time);

  LatLng latlng;
  double altitude;
  late DateTime time;

  @override
  String toString() {
    return "Coodinates: ${latlng.latitude.toStringAsFixed(4)}, ${latlng.longitude.toStringAsFixed(4)} \tAltitude: ${altitude.toString()} \tTime: ${time.toIso8601String()}";
  }
}
