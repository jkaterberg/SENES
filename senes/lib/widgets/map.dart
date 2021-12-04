import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:senes/helpers/route_point.dart';

class MapWidget extends StatefulWidget {
  MapWidget(this.points, this.url, this.token, this.center, {Key? key})
      : super(key: key);
  final String url;
  final String token;
  List<RoutePoint> points;
  final bool center;
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController controller = MapController();
  bool built = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (built) {
      controller.move(widget.points.last.latlng, controller.zoom);
    }

    built = true;

    return FlutterMap(
        mapController: controller,
        options: MapOptions(
          center: widget.points.last.latlng,
          maxZoom: 18.4,
          zoom: 20,
        ),
        layers: [
          TileLayerOptions(urlTemplate: widget.url, additionalOptions: {
            'accessToken': widget.token,
            'id': 'mapbox.satellite'
          }),
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
