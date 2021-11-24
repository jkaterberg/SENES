import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(this.url, this.token, {Key? key}) : super(key: key);
  final String url;
  final String token;
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          center: LatLng(1, 1),
          maxZoom: 18.4,
        ),
        layers: [
          TileLayerOptions(urlTemplate: widget.url, additionalOptions: {
            'accessToken': widget.token,
            'id': 'mapbox.satellite'
          })
        ]);
  }
}
