import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:senes/helpers/route_point.dart';

class MapWidget extends StatefulWidget {
  /// Widget that will plot a list of points onto a map

  MapWidget(this.points, this.url, this.token, this.center, {Key? key})
      : super(key: key);

  // Member variables
  final String url;
  final String token;
  List<RoutePoint> points;
  final LatLng center;
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController controller = MapController();
  bool built = false;

  @override
  Widget build(BuildContext context) {
    // Avoid a LateSubstantiationError
    if (built) {
      controller.move(widget.center, controller.zoom);
    }
    built = true;

    return FlutterMap(
        mapController: controller,
        options: MapOptions(
          center: widget.center,
          maxZoom: 18.4,
          zoom: 20,
        ),
        layers: [
          // Layer for map. Uses MapBox. Credentials are put in .env
          TileLayerOptions(urlTemplate: widget.url, additionalOptions: {
            'accessToken': widget.token,
            'id': 'mapbox.satellite'
          }),
          // Layer for point markers
          MarkerLayerOptions(
              markers: List<Marker>.generate(widget.points.length, (int i) {
            return Marker(
                point: widget.points[i].latlng,
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.circle),
                    iconSize: 10.0,
                    color: Colors.redAccent,
                    onPressed: () {
                      print(
                          "Marker pressed: ${widget.points[i].latlng.toString()}");
                    },
                  );
                });
          })),
        ]);
  }
}
