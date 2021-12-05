import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:senes/helpers/openweather_wrapper.dart';
import 'package:senes/helpers/route_point.dart';
import 'package:senes/helpers/workout.dart';
import 'package:senes/widgets/altitude_graph.dart';
import 'package:intl/intl.dart';
import 'package:senes/widgets/map.dart';

class PastWorkout extends StatelessWidget {
  PastWorkout(this.workoutID, {Key? key}) : super(key: key);
  String workoutID;

  @override
  Widget build(BuildContext context) {
    DateFormat date = DateFormat('yyyy-MM-dd');
    DateFormat time = DateFormat('HH:mm');
    return FutureBuilder(
        future: getWorkout(),
        builder: (BuildContext context, AsyncSnapshot<Workout> snapshot) {
          if (snapshot.hasData) {
            Workout data = snapshot.data!;
            return Scaffold(
              appBar: AppBar(title: const Text("Past Workout")),
              body: ListView(
                children: [
                  SizedBox(
                    height: 562,
                    child: MapWidget(data.route, dotenv.env['MAP_URL']!,
                        dotenv.env['MAP_TOKEN']!, data.route[0].latlng),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text("Date: ${date.format(data.startTime)}"),
                                Text(
                                    "Start Time: ${time.format(data.startTime)}"),
                                Text("End Time: ${time.format(data.endTime)}"),
                                Text(
                                    "Duration: ${data.duration.toString().split('.').first.padLeft(8, "0")}"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    "Temperature: ${(data.weather.temp! - 273).toInt()} C"),
                                Text("Humidity: ${data.weather.humidity} %"),
                                Text("Cloud Cover: ${data.weather.clouds}"),
                                Text(
                                    "Wind: ${data.weather.wind!["deg"]} @ ${data.weather.wind!["speed"]} km/h"),
                                Text("Pressure: ${data.weather.pressure} hPa"),
                              ],
                            )
                          ])),
                  SizedBox(
                    height: 200,
                    child: AltitudeChart(snapshot.data!.route),
                  ),
                ],
              ),
            );
          } else {
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
                        child: Text('Loading...'))
                  ]),
            );
          }
        });
  }

  Future<Workout> getWorkout() async {
    return Workout(DateTime.now(), DateTime.now(),
        Weather(275.7, "few clouds", 1015, 75, {"speed": 4.63, "deg": 230}), [
      RoutePoint(LatLng(43.9373, -78.8890), 145.0),
      RoutePoint(LatLng(43.937, -78.8895), 140.0)
    ]);
  }
}
