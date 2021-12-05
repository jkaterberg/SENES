import 'package:latlong2/latlong.dart';

class RoutePoint {
  /// Class meant to hold all relevant information for each point along a route

  /// Default contructor
  RoutePoint(this.latlng, this.altitude) {
    time = DateTime.now();
  }

  /// Constructor for existing point
  RoutePoint.withTime(this.latlng, this.altitude, this.time);

  /// Member variables
  LatLng latlng;
  double altitude;
  late DateTime time;

  @override
  String toString() {
    /// String representation of this object
    return "Coodinates: ${latlng.latitude.toStringAsFixed(4)}, ${latlng.longitude.toStringAsFixed(4)} \tAltitude: ${altitude.toString()} \tTime: ${time.toIso8601String()}";
  }
}
