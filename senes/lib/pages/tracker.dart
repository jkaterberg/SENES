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
  /// Page for tracking location during a workout

  Tracker({Key? key}) : super(key: key);

  // Route for navigation
  static const String routename = '/tracker';

  // Member variables

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  // Member variables
  bool ready = false;
  List<RoutePoint> points = [];

  // Things for triggering events whenever user moves 15m
  Stream<Position> posStream = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.best, distanceFilter: 15);
  late StreamSubscription subscription;

  @override
  void initState() {
    /// Initialise the page. Subscribe to position stream to get data whenever
    /// user moves
    subscription = posStream.listen((data) {
      setState(() {
        RoutePoint last =
            RoutePoint(LatLng(data.latitude, data.longitude), data.altitude);

        // store new location point
        if (points.isEmpty || points.last.latlng != last.latlng) {
          points.add(last);
        }
        ready = true;
      });
    }, cancelOnError: true);

    super.initState();
  }

  @override
  void dispose() {
    // Get rid of subscription
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Begin collecting location information if permission is granted
    if (Global.LOCATION_PERMISSION) {
      return FutureBuilder(
          // wait until at least one point is collected
          future: posStream.first,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.hasData && ready) {
              // Collect information about workout
              DateTime startTime = DateTime.now();

              return Scaffold(
                appBar: AppBar(title: const Text("Tracking Workout"), actions: [
                  // Button to save the workout
                  IconButton(
                    onPressed: () async {
                      // build workout object
                      Workout workout = Workout(
                          startTime,
                          DateTime.now(),
                          await Weather.getCurrent(points.first.latlng),
                          points);

                      // save to db
                      await DBHelper.dbHelper.insertWorkout(workout);

                      // go back to previous page
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save),
                  ),

                  // Cancel the current workout without saving
                  IconButton(
                      onPressed: () {
                        //cancel save workout
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.cancel)),
                ]),
                body: Column(children: [
                  // Map that autoupdates with each point
                  SizedBox(
                    height: 562,
                    child: MapWidget(points, dotenv.env["MAP_URL"]!,
                        dotenv.env["MAP_TOKEN"]!, points.last.latlng),
                  ),
                  // Graph the plots altitude in real time
                  SizedBox(
                    height: 100,
                    child: AltitudeChart(points),
                  ),
                ]),
              );
            } else {
              //return loading screen
              return Scaffold(
                  appBar: AppBar(),
                  body: Center(
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
                  ));
            }
          });
    } else {
      return const Scaffold(body: Text("Enable location services to continue"));
    }
  }
}
