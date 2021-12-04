import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:senes/helpers/env_conditions.dart';
import 'package:senes/helpers/route_point.dart';
import 'package:senes/widgets/map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senes/helpers/openweather_wrapper.dart';
import 'package:senes/helpers/globals.dart';

class Tracker extends StatefulWidget {
  Tracker({Key? key}) : super(key: key);

  List<RoutePoint> points = [];
  Stream<Position> posStream = Geolocator.getPositionStream(
    desiredAccuracy: LocationAccuracy.best,
    distanceFilter: 15,
  );

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  @override
  Widget build(BuildContext context) {
    widget.posStream.listen((data) {
      setState(() {
        widget.points.add(
            RoutePoint(LatLng(data.latitude, data.longitude), data.altitude));
      });
    });
    // Begin collecting location information
    if (Global.LOCATION_PERMISSION) {
      return FutureBuilder(
          future: widget.posStream.first,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.hasData) {
              // Collect information about workout
              DateTime startTime = DateTime.now();

              return Scaffold(
                floatingActionButton: FloatingActionButton(onPressed: () async {
                  // Save the workout information, return to main screen
                  print(startTime);
                  print(await Weather.getCurrent(widget.points.first.latlng));
                }),
                body: MapWidget(widget.points, dotenv.env["MAP_URL"]!,
                    dotenv.env["MAP_TOKEN"]!, true),
              );
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
      return const Text("Enable location services to continue");
    }
  }
}
