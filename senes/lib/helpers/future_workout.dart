import 'package:uuid/uuid.dart';

class FutureWorkout {
  DateTime time;
  Duration goal;
  String notes;
  late final String id;
  String? route;

  FutureWorkout(this.time, this.goal, this.notes, [this.route]) {
    id = const Uuid().v4();
  }
}
