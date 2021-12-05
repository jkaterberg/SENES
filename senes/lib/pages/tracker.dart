import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:senes/helpers/route_point.dart';
import 'package:senes/helpers/workout.dart';
import 'package:senes/widgets/altitude_graph.dart';
import 'package:senes/widgets/map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:senes/helpers/openweather_wrapper.dart';
import 'package:senes/helpers/globals.dart';
import 'package:senes/helpers/database_helper.dart';

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
  bool ready = false;
  @override
  Widget build(BuildContext context) {
    widget.posStream.listen((data) {
      setState(() {
        RoutePoint last =
            RoutePoint(LatLng(data.latitude, data.longitude), data.altitude);

        if (widget.points.isEmpty || widget.points.last.latlng != last.latlng) {
          widget.points.add(last);
          print(widget.points.last);
        }
        ready = true;
      });
    });
    // Begin collecting location information
    if (Global.LOCATION_PERMISSION) {
      return FutureBuilder(
          future: widget.posStream.first,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.hasData && ready) {
              // Collect information about workout
              DateTime startTime = DateTime.now();

              return Scaffold(
                appBar: AppBar(title: const Text("Tracking Workout"), actions: [
                  IconButton(
                    onPressed: () async {
                      // Save the workout information, return to main screen
                      print(startTime);
                      print(
                          await Weather.getCurrent(widget.points.first.latlng));

                      Workout workout = Workout(
                          startTime,
                          DateTime.now(),
                          await Weather.getCurrent(widget.points.first.latlng),
                          widget.points);

                      DBHelper.dbHelper.insertWorkout(workout);
                      await DBHelper.dbHelper.getWorkout(workout.workoutID);

                      //TODO navigate back to homepage
                    },
                    icon: const Icon(Icons.save),
                  ),
                  IconButton(
                      onPressed: () {
                        //cancel save workout
                        print("cancel");

                        //TODO: return to the main page
                      },
                      icon: const Icon(Icons.cancel)),
                ]),
                body: Column(children: [
                  SizedBox(
                    height: 562,
                    child: MapWidget(widget.points, dotenv.env["MAP_URL"]!,
                        dotenv.env["MAP_TOKEN"]!, widget.points.last.latlng),
                  ),
                  SizedBox(
                    height: 100,
                    child: AltitudeChart(widget.points),
                  ),
                ]),
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
