import 'package:latlong2/latlong.dart';

class RoutePoint {
  RoutePoint(this.latlng) {
    time = DateTime.now();
  }

  LatLng latlng;
  late DateTime time;
}
