import 'dart:async';

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
  late Future<Position> pos;
  StreamSubscription<Position> posStream = Geolocator.getPositionStream(
          desiredAccuracy: LocationAccuracy.best, distanceFilter: 10)
      .listen((Position position) {
    print(position == null
        ? 'Unknown'
        : position.latitude.toString() + ', ' + position.longitude.toString());
  });

  @override
  void initState() {
    _checkPermissions().then((value) => setState(() {
          permission = value;

          if (permission) {
            pos = Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.best);
          }
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure proper permissions ahve been granted before showing the map
    if (permission) {
      // Wait until the user's location is found to display the map
      return FutureBuilder(
          future: pos,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.hasData) {
              // Return map widget
              return FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                        snapshot.data!.latitude, snapshot.data!.longitude),
                    maxZoom: 18.4,
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate: widget.url,
                        additionalOptions: {
                          'accessToken': widget.token,
                          'id': 'mapbox.satellite'
                        })
                  ]);
            } else {
              //return loading screen
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                        child: CircularProgressIndicator(),
                        width: 60,
                        height: 60),
                    Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Loading Location...'))
                  ],
                ),
              );
            }
          });
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
