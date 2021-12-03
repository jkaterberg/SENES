import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:senes/helpers/route_point.dart';

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

  MapController _controller = MapController();
  List<RoutePoint> points = [];

  // Automatically get coordinates when the device moves more than 15m
  // I think this will need to move elsewhere at some point if we want to
  // still track the route in the background
  StreamSubscription<Position> posStream = Geolocator.getPositionStream(
          desiredAccuracy: LocationAccuracy.best, distanceFilter: 15)
      .listen((Position position) {});

  @override
  void initState() {
    //Permissions should be checked before app starts
    // Perhaps be better to check for boolean flag set from that?
    _checkPermissions().then((value) => setState(() {
          permission = value;

          if (permission) {
            pos = Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.best);
            pos.then((value) => points.add(RoutePoint(
                LatLng(value.latitude, value.longitude), value.altitude)));
          }
        }));
    super.initState();
  }

  @override
  void dispose() {
    posStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    posStream.onData((data) => setState(() {
          points.add(
              RoutePoint(LatLng(data.latitude, data.longitude), data.altitude));
          print(points.last);
          _controller.move(points.last.latlng, _controller.zoom);
        }));

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
                      center: points.last.latlng,
                      maxZoom: 18.4,
                      zoom: 20,
                      controller: _controller,
                      onMapCreated: (c) {
                        _controller = c;
                      }),
                  layers: [
                    TileLayerOptions(
                        urlTemplate: widget.url,
                        additionalOptions: {
                          'accessToken': widget.token,
                          'id': 'mapbox.satellite'
                        }),
                    MarkerLayerOptions(
                        markers: List<Marker>.generate(points.length, (int i) {
                      return Marker(
                          point: points[i].latlng,
                          builder: (BuildContext context) {
                            return IconButton(
                              icon: const Icon(Icons.circle),
                              iconSize: 10.0,
                              color: Colors.redAccent,
                              onPressed: () {
                                print(
                                    "Marker pressed: ${points[i].latlng.toString()}");
                              },
                            );
                          });
                    })),
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
