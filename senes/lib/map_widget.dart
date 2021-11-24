import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(this.url, this.token, {Key? key}) : super(key: key);
  final String url;
  final String token;
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  bool permission = false;
  @override
  void initState() {
    _checkPermissions().then((value) => setState(() {
          permission = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure proper permissions ahve been granted before showing the map
    if (permission) {
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
    } else {
      // Prompt the user to go to settings to enable permissons
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text('Insufficient Permissions',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Text('Enable location in settings to continue')
        ],
      ));
    }
  }

  Future<bool> _checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    //Check if app has correct permissions. If it doesn't, nicely ask for them
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    // We have correct permissions
    return true;
  }
}
