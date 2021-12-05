import 'package:uuid/uuid.dart';

class FutureWorkout {
  /// Class to hold all relevant information for scheduled workouts

  // Member variables
  DateTime time;
  Duration goal;
  String notes;
  late final String id;
  String? route;

  // Default constructor, assumes new scheduled workout
  FutureWorkout(this.time, this.goal, this.notes, [this.route]) {
    id = const Uuid().v4();
  }

  // Constructor for creating object from existing workout info
  FutureWorkout.existing(this.time, this.goal, this.notes, this.id,
      [this.route]);
}
