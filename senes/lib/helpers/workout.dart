import 'package:senes/helpers/route_point.dart';
import 'package:senes/helpers/openweather_wrapper.dart';
import 'package:uuid/uuid.dart';

class Workout {
  /// Class meant to hold all relevant information about completed workouts

  //Member variables
  DateTime startTime;
  DateTime endTime;
  Weather weather;
  List<RoutePoint> route;

  late Duration duration;
  late final String workoutID;

  // Constructors
  Workout(this.startTime, this.endTime, this.weather, this.route) {
    workoutID = const Uuid().v4();
    duration = Duration(
        milliseconds: (endTime.millisecondsSinceEpoch -
            startTime.millisecondsSinceEpoch));
  }

  Workout.workout(this.startTime, this.endTime, this.weather, this.route,
      this.duration, this.workoutID);

  @override
  String toString() {
    /// Return String representation of this object
    return "{workoutid: $workoutID, startTime: $startTime, endTime: $endTime, duration: $duration, weather: $weather, route: $route}";
  }
}
